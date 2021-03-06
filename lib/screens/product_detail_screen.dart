//this screen widget will show product details

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; //to use provider of context
import 'package:shop_app/providers/products_provider.dart';
import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "Product-detail"; //named route for this screen

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments
        as String; //fetch the id from argument passed into named route of this screen

    //to load the product we tapped in
    final loadedProduct = Provider.of<Products>(context,
            listen:
                false //with this agrument that this build method is not triggered if somewhere else the data in Products class changes
            )
        .findById(productId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: (MediaQuery.of(context).size.height -
                    56 -
                    MediaQuery.of(context).padding.top) /
                2,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadedProduct.title,
                style:TextStyle(
                  backgroundColor: Colors.black54
                  ),
                ),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Text(
              "\$ ${loadedProduct.price}",
              style: TextStyle(color: Colors.grey, fontSize: 20),textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                loadedProduct.description,style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
                softWrap:
                    true, //so if description is to big it will wrap to a new line
              ),
            ),
            SizedBox(height:800)
          ]))
        ],
      ),
    );
  }
}
