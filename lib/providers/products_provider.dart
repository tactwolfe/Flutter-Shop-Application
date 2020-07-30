//products provider class

import 'package:flutter/material.dart';
import 'dart:convert'; //to convert data into json
import 'package:http/http.dart' as http;
import 'package:shop_app/secrets.dart';
import './product.dart';


//mixin classed provide utility that we can use in our classes

//this changenotifier is related to inherited widget behind the scene so to establish tunnels 
//of communication between this and widget that will required this provider directly through 
//the widget of which he is child of and this provider is connected to using context object
class Products with ChangeNotifier {

  final secret = Secrets();

    List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

    //getter which will return all the products
    List<Product> get items {
   
      return [..._items];
    }

    //this getter will return only the products which have isFavourite true
    List<Product> get favouriteItems{
      return _items.where((prod) => prod.isFavourite).toList();
    }

   
    //this method return us a products from _items list with a particular id to display in required widget
    Product findById(String id){
      return _items.firstWhere((prod) => prod.id == id );
    }

    //method to add new products
    Future<void>addProducts(Product product){ //make the method return void to wait to pop the screen using this function this this finish its execution

      //----------------------saving data to our online database--------------------------//

      //url of our firebase application server where we are going to save the data
      final url ="${secret.fireBaseUrl}/products.json";
      
      //post method to save the data recieve in our database we send the data as map because json.encode accept data that way
      //note:this post method returns a future object thus we can use then method just after this
      //method completes it execution
      
      //we return the entire thing because post and then returns a future which satisfiies our return type of this function also we can use this future to popuser product screen only after data is saved to database
      return     
      http.post(url,body: json.encode({
          'title':product.title,
          'description':product.description,
          'imageUrl':product.imageUrl,
          'price':product.price,
          'isFavourite':product.isFavourite
       })
      )
      //----------------------saving data to our online database--------------------------//
      
      //-----------------------saving data to our local memory----------------------------//

      .then((response)  { //this then method of post recieves some response from the server that we are going to use to create our product id
        
        final newProduct = Product(        //move this enitre logic to add product to our local memory
        title: product.title,              //so we can add id of the product base on info we get from 
        description: product.description,  //response we get from the then method here
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'] //this adds the cryptic value we get from
                                               //response inside the key name to our 
                                              //product id so we can easily find our data in online server
      );
      _items.add(newProduct);
      notifyListeners();
      })
      //-----------------------saving data to our local memory----------------------------//
     
      //---------------------------------error handling-----------------------------------//
     .catchError((err) { 
       print(err);
       throw err; //to throw this error to another error handler listining to this function ps:the one in our saveForm function that is using this method and getting a future as returned by this function thus using that future in there it can catch the error thrown by this catchError function that also send this error as a future
     });

     //---------------------------------error handling-----------------------------------//

    }

    //method used to update our product
    void updateProduct(String id, Product newProduct){
      final prodIndex= _items.indexWhere((prod) => prod.id == id );
      if(prodIndex >= 0){
          _items[prodIndex] = newProduct;
          notifyListeners();
      }
      else{
        print("...");
      }
    }

    void deleteProduct(String id){
      _items.removeWhere((prod) => prod.id == id );
      notifyListeners();
    }

}