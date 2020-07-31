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
    return Scaffold(
      appBar: AppBar(
        title:Text("Your Orders") ,
        ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context,listen: false).fetchAndSetOrders(),
        builder: (ctx,dataSnapshot) {
          //if the data snapshot we get from our future builder is waiting because the future argument still executing then we return Circularprogress indicator
          if(dataSnapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          } else{
            if(dataSnapshot.error != null){
              //...
              //do error handling stuffs here....
              return Center(child: Text("An error has occur"),);
            }else{

                //if the datasnapshot is done and we dont have any error then we will show the list view of order
                return Consumer<Orders>(
                  builder: (ctx, orderData, _) =>  
                  ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx,index)=> OrderItem(orderData.orders[index]),
               )
                  
              );    
            }
          }
        }
        ) 
    );
  }
}