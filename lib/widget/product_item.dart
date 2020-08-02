import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth_provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: FadeInImage(
            placeholder:AssetImage("assets/images/product-placeholder.png") ,
            image: NetworkImage(product.imageUrl),
            fit: BoxFit.cover,
          ) 
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          
          //--------------------------error because of this part ---------------------------------------------------------------//
          // leading: Consumer<Product>(
          //   builder: (ctx, product, _) => IconButton(  
          //     icon: Icon(
          //       product.isFavourite ? Icons.favorite : Icons.favorite_border,
          //     ),
          //     color: Theme.of(context).accentColor,
          //     onPressed: () => 
          //     product.toggleFavouriteStatus(
          //       authData.token,
          //       authData.userId
          //       )
          //   ),
          // ),

           //--------------------------error because of this part ---------------------------------------------------------------//
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(
                  productId: product.id,
                  price: product.price,
                  title: product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("Added item to the Cart!"),
                  duration: Duration(seconds: 3),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
