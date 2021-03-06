//products provider class

import 'package:flutter/material.dart';
import 'dart:convert'; //to convert data into json
import 'package:http/http.dart' as http;
import '../model/http_exceptions.dart';
import 'package:shop_app/secrets.dart';
import './product.dart';


//mixin classed provide utility that we can use in our classes

//this changenotifier is related to inherited widget behind the scene so to establish tunnels 
//of communication between this and widget that will required this provider directly through 
//the widget of which he is child of and this provider is connected to using context object
class Products with ChangeNotifier {

  final secret = Secrets();

    List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];



    //getter which will return all the products
    List<Product> get items {
   
      return [..._items];
    }

    
    final String authtoken;
    final String userId;

    Products(this.authtoken,this.userId,this._items);

    //this getter will return only the products which have isFavourite true
    List<Product> get favouriteItems{
      return _items.where((prod) => prod.isFavourite).toList();
    }

   
    //this method return us a products from _items list with a particular id to display in required widget
    Product findById(String id){
      return _items.firstWhere((prod) => prod.id == id );
    }

    //method to fetch product to be render on our product overview screen
    Future<void>fetchAndSetProducts([ bool filterByUser = false ]) async { //added this boolean argument with a default and wrap it into square bracket to make it optional positional argument value to turn on and off the filtering logic

      final filterString  = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

      //fetched data for a specific authorized user
      var url ='${secret.fireBaseUrl}/products.json?auth=$authtoken&$filterString';  
     
      try{
        final response = await http.get(url); //http get method
        final extractedData = json.decode(response.body) as Map<String,dynamic>; //store the response we get as a map
        if(extractedData == null){
          return;
        }

        url = "${secret.fireBaseUrl}/userFavorites/$userId.json?auth=$authtoken";
        final favoriteResponse = await http.get(url);
        final favoriteData = json.decode(favoriteResponse.body);
       
        final List<Product>loadedProduct = []; //created an empty list which will be assigned to our _items so item list will update and everyone listening to it get data we get from our server
       
        extractedData.forEach((prodId, prodData) {
          loadedProduct.insert( 0,
            Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavourite:  favoriteData == null ? false :  favoriteData[prodId] ?? false,
          ));
         });
          _items = loadedProduct; //assign our dummy list to ur main list of products
          notifyListeners(); //notify the listener about the change
      
      }catch(err){
        throw(err);
      }
      
    }


    //method to add new products
    Future<void>addProducts(Product product) async { //async methods automatically returns a future

      //----------------------saving data to our online database--------------------------//
      print(product.isFavourite);
      //url of our firebase application server where we are going to save the data
      final url ="${secret.fireBaseUrl}/products.json?auth=$authtoken";
      
      //post method to save the data recieve in our database we send the data as map because json.encode accept data that way
      //note:this post method returns a future object thus we can use then method just after this
      //method completes it execution
      
      //here we wrap both storing data into database and locally into try block to handle an error 
      //because since we are using await keyword we cannot use then(),catcherror() method
      //because await automatically executes the rest of the code when its complete the execution of 
      //method it is assigned to but there is no future return by our local storing method 
      // thus we cannot use the future generated by await which it automatically returns a
      //response the we save ina variable and assigned to id of the product in our local storing statergy 
      //thus the chain break and threfore we have
      //to use our genreal try and catch block to handle error
      try {
        final response = await http.post(url,body: json.encode({ //await automatically returns a 
          'title':product.title,                                 //future thus we dont use 
          'description':product.description,                     //return keyword
          'imageUrl':product.imageUrl,
          'price':product.price,
          'creatorId': userId
          // 'isFavourite':product.isFavourite not sending this because we are managing fav in another collection
       })
        
      );
      //----------------------saving data to our online database--------------------------//
      
      //-----------------------saving data to our local memory----------------------------//

        final newProduct = Product(        
        title: product.title,             
        description: product.description,  
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'] //this adds the cryptic value we get from
                                               //response inside the key " name " to our 
                                              //product id so we can easily find our data in online server
      );
      _items.add(newProduct);
      notifyListeners();

       //-----------------------saving data to our local memory----------------------------//
      }
      //---------------------------------error handling-----------------------------------//
      catch(err){
          print(err);
          throw err; //to throw this error to another error handler listining to this function ps:the one in our saveForm function that is using this method and getting a future as returned by this function thus using that future in there it can catch the error thrown by this catchError function that also send this error as a future
      }
      //---------------------------------error handling-----------------------------------//

    }

    //method used to update our product
    Future<void> updateProduct(String id, Product newProduct) async{
      final prodIndex= _items.indexWhere((prod) => prod.id == id );
      if(prodIndex >= 0){

        //-------------------------update the product in database-----------------------------//

        final url ="${secret.fireBaseUrl}/products/$id.json?auth=$authtoken"; //modified url with id of product
                                                              //store in database to update it
                                                              //ps product id locally and online is same
        
        await http.patch(url,body: json.encode({
          'title':newProduct.title,
          'description':newProduct.description,
          'imageUrl':newProduct.imageUrl,
          'price':newProduct.price
        }));

        //-------------------------update the product in database-----------------------------//
         
        //---------------=------------update the product locally------------------------------//
          _items[prodIndex] = newProduct;
          notifyListeners();

        //---------------=------------update the product locally------------------------------//
      }
      else{
        print("...");
      }
    }

    Future<void> deleteProduct(String id) async {

      //----------------------deleting product from database----------------------------------//

      final url ="${secret.fireBaseUrl}/products/$id.json?auth=$authtoken";

      //store the index of the product we are trying to delete
      final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
      //store the the product we want to delete in a variable to store it in memory
      var existingProducts = _items[existingProductIndex];


      //-----------------------------deleting product locally---------------------------------//

      _items.removeAt(existingProductIndex); 
      notifyListeners();

      //-----------------------------deleting product locally---------------------------------//

      //----------optimistic updating to rollback if any erro occur during deletion-----------// 

      final response =await http.delete(url);
      
        print(response.statusCode);
        if( response.statusCode >=400 ){

            //if error occurs us this rollback deletion
           _items.insert(existingProductIndex, existingProducts);
            notifyListeners();

            throw HttpExceptions("Could not delete Product."); //throw our custom exception which will be catched by catchError
        
        }else{

             existingProducts = null ; // if delete is successful then remove the product from memory too
        }
         
      //----------optimistic updating to rollback if any erro occur during deletion-----------//

      //----------------------deleting product from database----------------------------------//

      
    }

}