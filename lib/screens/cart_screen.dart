//this is the screen widget to show our cart screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widget/cart_item.dart';
import '../providers/cart.dart' show Cart; //did this to avoid name conflict of cartItem
import '../widget/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            // color: Colors.yellow,
            // shadowColor: Colors.yellowAccent,
            elevation: 5,
            margin: EdgeInsets.all(15),
            child: Padding(
            padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total", 
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(), //this widget alling widgets to its either side to their extreme ends
                  Chip(
                    label: Text(
                      "\$${cart.totalAMount.toStringAsFixed(3)}",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed: () {
                      final order = Provider.of<Orders>(context,listen: false);
                      order.addOrder(
                        cart.items.values.toList(), 
                        cart.totalAMount
                        );
                        cart.clear();
                    },
                    child: Text("ORDER NOW"),
                    textColor: Theme.of(context).accentColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemBuilder:(ctx,index)=> CartItem (
                id:cart.items.values.toList()[index].id, //cart id
                productId: cart.items.keys.toList()[index], //product id use the key to get the value of key we used which in our case is our product id
                title:cart.items.values.toList()[index].title,
                price:cart.items.values.toList()[index].price,
                quantity:cart.items.values.toList()[index].quantity
              ) ,
            itemCount: cart.itemCount,
            )
            )
        ],
      ),
    );
  }
}
