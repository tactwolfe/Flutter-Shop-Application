// this provider is used to manage order

import 'package:flutter/foundation.dart';
import 'dart:convert'; //to convert data into json
import 'package:http/http.dart' as http;
import './cart.dart';
import 'package:shop_app/secrets.dart';

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

  final secrets = Secrets();

  Future<void> addOrder( List<CartItems> cartProducts , double total) async {

    final url = "${secrets.fireBaseUrl}/orders.json";
    final timestamp = DateTime.now(); //to store a timestamp and used it to create order both locally and in database with exactly the same time stamp because http request take some time thus the database versiona and local version datestamp might have varied

      final response = await http.post(url,body: json.encode({
      
      'amount':total,
      'datetime':timestamp.toIso8601String(),
      'products' : cartProducts.map((cartprod) => {
             'id':cartprod.id,
             'title':cartprod.title,
             'quantity':cartprod.quantity,
              'price':cartprod.price
        }).toList(),

    }
    ));

    //use the insert method to make recent transaction to first index likes in amazona and flipkart
    _orders.insert(
      0, 
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        datetime: timestamp,
        products: cartProducts
        ));
        notifyListeners();

  }

  Future<void>fetchAndSetOrders() async {
    final url = "${secrets.fireBaseUrl}/orders.json";
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map <String,dynamic>;
    if(extractedData == null){
      return;
    }

    extractedData.forEach((orderId, orderData) { 
      loadedOrders.add(OrderItem(
        id: orderId, 
        amount: orderData['amount'], 
        datetime: DateTime.parse(orderData['datetime']),
        products: (orderData['products'] as List<dynamic>).map(
          (item) => CartItems(
            id: item['id'], 
            title: item['title'], 
            quantity: item['quantity'], 
            price: item['price'])         
          ).toList(), 
        
        ));

        _orders = loadedOrders.reversed.toList(); //added reverse.tolist to add newer order to top of the list
        notifyListeners();    
    });
  }

}