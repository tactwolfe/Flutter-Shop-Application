//this is the screen used for showing product add by user to sell on our products in app

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widget/app_drawer.dart';
import '../widget/user_product_item.dart';
import '../providers/products_provider.dart';
import './edit_product_screen.dart';


class UserProductScreen extends StatelessWidget {

  static const routeName = '/user-product';

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add), 
            onPressed: (){
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            }
            )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productData.items.length ,
          itemBuilder: ( _ , index) => 
          Column(children: <Widget>[
          UserProductItem(
              productData.items[index].id,
              productData.items[index].title, 
              productData.items[index].imageUrl
           ),
           Divider() 
          ],
            
          )

          ),
        ),
        drawer: AppDrawer(),
      
    );
  }
}