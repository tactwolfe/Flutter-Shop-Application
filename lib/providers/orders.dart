// this provider is used to manage order

import 'package:flutter/foundation.dart';
import './cart.dart';

//model for our orderItem
class OrderItem {
  final String id;
  final double amount;
  final List<CartItems>products;
  final DateTime datetime;

  OrderItem({
   @required this.id,
   @required this.amount,
   @required this.products,
   @required this.datetime});

}

class Orders with ChangeNotifier{

  List<OrderItem> _orders =[];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder( List<CartItems> cartProducts , double total) {

    //use the insert method to make recent transaction to first index likes in amazona and flipkart
    _orders.insert(
      0, 
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        datetime: DateTime.now(),
        products: cartProducts
        ));
        notifyListeners();

  }

}