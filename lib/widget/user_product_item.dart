// this widget used to display listview in userproduct screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id,this.title,this.imageUrl);


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage:NetworkImage(imageUrl), //here Network image is the image provider object not an widget
      ) ,
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[

            IconButton(
              icon: Icon(Icons.edit,color: Colors.grey,), 
              onPressed: (){
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,arguments: id
                  );
              }
            ),

            IconButton(
              icon: Icon(Icons.delete,color: Theme.of(context).errorColor,), 
              onPressed: (){
                Provider.of<Products>(context,listen: false).deleteProduct(id);
              }
              ),

          ],
        ),
      ),
    );
  }
}