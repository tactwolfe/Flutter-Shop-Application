//this is the screen used for showing product add by user to sell on our products in app

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widget/app_drawer.dart';
import '../widget/user_product_item.dart';
import '../providers/products_provider.dart';
import './edit_product_screen.dart';


class UserProductScreen extends StatelessWidget {

  static const routeName = '/user-product';

  Future<void>_refreshProducts(BuildContext context) async{
     await Provider.of<Products>(context,listen: false).fetchAndSetProducts(true); //pass the bool true to filter the products this user added so he/she can edit it in edit product screen
  }



  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context); => this would have triggered an infinite build loop
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
      body: FutureBuilder(
            future: _refreshProducts(context), //=>to refresh the screen everytime we visit there
            builder:(ctx,snapshot) => snapshot.connectionState == ConnectionState.waiting ?
              Center(child: CircularProgressIndicator(),
              )
            :
            RefreshIndicator(
            onRefresh: ()=> _refreshProducts(context),
            child: Consumer<Products>( // this only build part of our widget and wont trigger infinite loop
              builder:(ctx,productData, _)=>Padding(
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
            ),
        ),
      ),
        drawer: AppDrawer(),
      
    );
  }
}