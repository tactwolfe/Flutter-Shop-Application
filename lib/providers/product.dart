//this will be model following which we will create our products

import 'package:flutter/foundation.dart';

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

    void toggleFavouriteStatus(){
      isFavourite = !isFavourite;
      notifyListeners();
    }
  
}