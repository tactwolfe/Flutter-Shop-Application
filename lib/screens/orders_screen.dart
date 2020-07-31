//this is the widget that will show us to order screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/app_drawer.dart';
import '../widget/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatefulWidget {

  static const routeName = "/orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  
  var _isLoading = false;

//init state hack to recieve future values to initialize our order screen
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
         _isLoading = true;
      });
     
     await Provider.of<Orders>(context,listen: false).fetchAndSetOrders();

     setState(() {
       _isLoading = false;
     });
    
    });
    
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title:Text("Your Orders") ,
        ),
      drawer: AppDrawer(),
      body: _isLoading ? 
      Center(child: CircularProgressIndicator())
      :ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx,index)=> OrderItem(orderData.orders[index]),
        )
    );
  }
}