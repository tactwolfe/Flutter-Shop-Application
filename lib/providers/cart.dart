//this will be provider class widget for our cart

import 'package:flutter/Material.dart';

//here we merged the cartItem model and cart into a single provider file because unlike previous case where we are favouriting
//a product we didnt need to actually manupulate a parameter of the model 

//model for cart items
class CartItems {
  
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItems({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price
    });
}

class Cart with ChangeNotifier{

Map<String,CartItems> _items={}; //map of items that take productid as key and have other cart information 

Map<String,CartItems> get items { //getter method for this cart
  return {..._items}; 
}

//getter method that return items count in our cart
int get itemCount{
  return  _items.length; 
}

//getter that returns total amount
double get totalAMount{
  double total = 0.0;
  _items.forEach((key, cartItem) { 
    total += cartItem.price * cartItem.quantity;
  } );
  return total;
}


//method to add a new item to cart
void addItem({String productId,String title,double price}){

  //check if we alreaady have that item in our cart the increase its quantity we can check it because in the map we have used productid as key 
  if(_items.containsKey(productId)) { 
    _items.update(
      productId, 
      //change quantity of a product in a cart if its already exist here the value in anynomous function contain the values of existing cardItems
      (value) => CartItems(
        id: value.id,
        title: value.title,
        price: value.price,
        quantity: value.quantity + 1 //here we update the quantity
        ));
  }

  //to add a new product to cart if it doesnt exist
  else{                                
    _items.putIfAbsent(
      productId, 
      //anaynomous fuction that is created to recive the value into cart items
      () => CartItems(
        id: DateTime.now().toString(), 
        title: title, 
        quantity: 1, //we dont need to pass a constructor agrument to define quantity by default when a product is added its quantity is one and if again the same item is added we have the logic above to increase its quantity
        price: price
      ));
    }
    notifyListeners();
  }

  //to delete a item using dsmissal in our case
  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  //to delete a addition to cart from our snackbar in product overview screen
  void removeSingleItem(String productId){
    if( !_items.containsKey(productId)) { //if the item is not the part of the cart return nothing
      return;
    }
    if(_items[productId].quantity > 1) { //if  more than one similar product is added simultaneously
      _items.update(productId, (cartValue) => CartItems(
        id: cartValue.id,
        price: cartValue.price,
        title: cartValue.title,
        quantity: cartValue.quantity - 1 //in this case we decrease the quantity by 1
      ));
    }else{
      _items.remove(productId);
    }

    notifyListeners();
  }

  //to clear the cart after placing order
  void clear(){
    _items = {};
    notifyListeners();
  }
    
}