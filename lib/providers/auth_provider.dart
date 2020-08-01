



import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/secrets.dart';

class Auth with ChangeNotifier{

  String _token;
  String _expiryDate;
  String _userId;

  final secrets = Secrets();


  Future<void> signup (String email,String password) async {
      
    final url="https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${secrets.firebaseApi}";
    
    final response = await http.post(url,body: json.encode({

        "email" :email,
        "password" :password,
        "returnSecureToken":true,
       }
     )
   );
   print(json.decode(response.body));
  }

  Future<void> login (String email,String password) async {

    final url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${secrets.firebaseApi}";

    final response = await http.post(url,body: json.encode({

      "email" : email,
      "password" :password,
      "returnSecureToken" : true
       }
     )
   );
   print(json.decode(response.body));
  }

}