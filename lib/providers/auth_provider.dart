//authentication provider class

import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



import '../secrets.dart';
import '../model/http_exceptions.dart'; //my own exception model

class Auth with ChangeNotifier{

  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  final secrets = Secrets();

  //common authentication method because of some small change code for both signin  & sinup is same
  Future<void> _authenticate (String email,String password ,String urlSegment) async {

    final url="https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=${secrets.firebaseApi}";
    
    try{
      final response = await http.post(
      url,
      body: json.encode(
        {
        "email" :email,
        "password" :password,
        "returnSecureToken":true,
       }
     )
   );
    final responseData = json.decode(response.body);
    // print(responseData);
    //this means if error exist PS- here we use 'error' because that's how we get our error in here inside an 'error' key in response as we have seen by printing the response
    if (responseData['error'] != null) {
        throw HttpExceptions(responseData['error']['message']); //inside the message key we get the type of error
    }
    _token = responseData['idToken'];
    print(_token);
    _userId = responseData['localId'];
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(
          responseData['expiresIn']
          ),
        ),
      );
      _autoLogout();  //thir here will automatically call logout after some time
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({ 
        'token':_token ,
        'userId':_userId ,
        'expiryDate':_expiryDate.toIso8601String()
        });

      prefs.setString('userData', userData);


   }catch(error){
     throw error;
   }
  }

  //signup method
  Future<void> signup (String email,String password) async {
   return _authenticate(email, password, "signUp");
  }

//login method
  Future<void> login (String email,String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  //getter to get token
  String get token {
    if( _expiryDate != null && 
     _expiryDate.isAfter(DateTime.now()) &&
     _token !=null  ) {
      return _token;
    }
    return null;
    
  }

  //getter to check authentication status
  bool get isAuth{
    return token != null;
  }

  //getter to get user id
  String get userId{
    return _userId;
  }

  //method to log out
  Future<void> logout() async{
    _token = null;
    _userId = null;
    _expiryDate = null;
    if(_authTimer!= null){
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    
    // prefs.remove("userData"); //use this method if we are storing many information in our shared preferances and only want to remove a particluar data from it

    prefs.clear(); //here we use this because we are only storing our user data in sharedpreferances thus when we logout we want to delete it so that auto login dont kicked in & logged us in
  }

  //method to auto logout
  void _autoLogout(){

     if(_authTimer != null) {
       _authTimer.cancel();
     } 

    var timeToExpiry =_expiryDate.difference(DateTime.now()).inSeconds;
     _authTimer = Timer(
      Duration(seconds: timeToExpiry), //time remain for expiration of token
      logout  //if token expire call the method logout
    );
  }

  //method to auto login
  Future<bool> tryAutoLogin () async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString("userData")) as Map<String , Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if(expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }
}
