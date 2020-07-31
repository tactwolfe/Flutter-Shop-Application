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
                  OrderButton(cart: cart)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading? CircularProgressIndicator():Text("ORDER NOW"),
      textColor: Theme.of(context).accentColor,
      onPressed: (widget.cart.totalAMount<=0 || _isLoading)
      ? null 
      : () async { //if total order amount is 0 or less than that with this we disabled the button
        
        setState(() {
          _isLoading = true;
        });
        
         await Provider.of<Orders>(context,listen: false).
         addOrder(
          widget.cart.items.values.toList(), 
          widget.cart.totalAMount
          );
          setState(() {
              _isLoading = false;
          });
          widget.cart.clear();
      },
    );
  }
}
