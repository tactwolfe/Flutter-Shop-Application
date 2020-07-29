//this is cart item widget that gets return to cart screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId; //to used in ondismmed function to remove an item from cart
  final double price;
  final String title;
  final int quantity;

  CartItem({
    this.id, 
    this.productId,
    this.title, 
    this.price, 
    this.quantity
    });

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context,listen: false);

    return Dismissible(  // so we can delete an item by swipping its cart
      direction: DismissDirection.endToStart , //direction to swipe to delete the item from cart
      key: ValueKey(id), //to make sure we delete a particular cart item not anything else
      background: Container(  //to give background design to dismissal widget
        color: Theme.of(context).errorColor ,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
          Text(
            "DELETE",
            style:TextStyle(color:Colors.white) ,
            ),
          Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        ],
        ),
        // alignment: Alignment.centerRight, // use this argument if not using row widget to show more than 1 and using iits mainAxis llignment to allign
        padding: EdgeInsets.only(right: 20),
      ),
      confirmDismiss: (direction){
        return showDialog( 
          context: context,
          builder: (ctx)=> AlertDialog(
            title : Column(children: <Widget>[
             Icon(Icons.block,color: Colors.red,) ,
             Text("Are You Sure???")
             ],
            ),
            content: Text("Do you want to remove the item from the cart?"),
            elevation: 10,
            
            actions: <Widget>[

              FlatButton(
                child: Text("No"),
                onPressed: (){
                  Navigator.of(ctx).pop(false); //this will close the dialog if we press no and return false so item wont get delete
                }, 
              ),
              
              FlatButton(
                child: Text("yes"),
                onPressed: (){
                  Navigator.of(ctx).pop(true);//this will close the dialog if we press yes and return true so item will get delete
                }, 
              )
            ],

          )
          );
      },
      onDismissed: (direction){
          cart.removeItem(productId);
      },
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text("\$$price")),
              ),
            ),
            title: Text(title),
            subtitle: Text("Total : ${price * quantity}"),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
