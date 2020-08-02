//authentication provider class

import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../secrets.dart';
import '../model/http_exceptions.dart'; //my own exception model

class Auth with ChangeNotifier{

  String _token;
  DateTime _expiryDate;
  String _userId;

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
      notifyListeners();

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

}
