//products provider class

import 'package:flutter/material.dart';
import './product.dart';


//mixin classed provide utility that we can use in our classes

//this changenotifier is related to inherited widget behind the scene so to establish tunnels 
//of communication between this and widget that will required this provider directly through 
//the widget of which he is child of and this provider is connected to using context object
class Products with ChangeNotifier {

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
    void addProducts(Product product){

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id:DateTime.now().toString()
      );
      _items.add(newProduct);
      notifyListeners();
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