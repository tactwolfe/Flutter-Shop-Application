//this will be model following which we will create our products

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //to convert data into json
import '../secrets.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite; //this is not final because it is changable attribute of the product based on user preferanses at any given time

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false, 
                //here isFavourite is not necessarily required so we dont use 
                 //the decorator @required rather just initialize with some default values
    });

    var secrets = Secrets();
    
    //function that help to roll back previous favourite values in case of an error
    void _setFavValue(bool newValue){
      isFavourite = newValue;
      notifyListeners();
    }

    Future<void> toggleFavouriteStatus(String token , String userId) async {

      var oldStatus = isFavourite; //this var is used to start the inital value of favourite before change
      isFavourite = !isFavourite;  //toggling the value of isFavourite from true to false and vice versa
      notifyListeners(); //notifying all its listners

      final url = "${secrets.fireBaseUrl}/userFavorites/$userId/$id.json?auth=$token";

      try {
            //  final response = await http.patch(
            //     url, 
            //     body: json.encode({
            //         'isFavourite':isFavourite,
            //      }
            //  ));

             final response = await http.put(
                url, 
                body: json.encode(
                  isFavourite,
             ));
             
             if(response.statusCode >= 400){
                 _setFavValue(oldStatus);
             }
      }
      catch(err){
        _setFavValue(oldStatus);
      }

    }
  
}