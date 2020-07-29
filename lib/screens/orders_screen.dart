//this is the widget that will show us to order screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/app_drawer.dart';
import '../widget/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {

  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {

    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title:Text("Your Orders") ,
        ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx,index)=> OrderItem(orderData.orders[index]),
        )
    );
  }
}