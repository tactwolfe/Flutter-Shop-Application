import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {

    // final product = Provider.of<Product>(context); //listening to changes in products provider
    final product = Provider.of<Product>(context, listen: false); //alternate way with using consumer to make a part of widget to listen to change and rebuild/rerun not the entire widget
    
    final cart = Provider.of<Cart>(context,listen: false);//object listening to changes in cart provider 
    //here we make listen false because we just want to add the item to cart but interested in change to the cart so no need to call rebuild method for this widget
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id //passed id as agrument into named route
                );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(

          leading: Consumer<Product>(
            builder: (ctx, products, child) => IconButton(
                icon: Icon(product.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  product.toggleFavouriteStatus();
                }),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItem(
                  productId:product.id,
                  title:product.title,
                  price:product.price
                  );
                Scaffold.of(context).hideCurrentSnackBar(); //to hide a current snackbar if a new snack bar is created in case of rapid adding of items to cart 
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Added item to the cart"), //message in our snackbar
                    duration: Duration(seconds: 3), //duration of our snackbar
                    action: SnackBarAction(  //action on snackbae e.g UNDO
                      label: "UNDO", 
                      onPressed: (){
                        cart.removeSingleItem(product.id);
                      }
                      ),

                  )
                );
              }
            ),
          backgroundColor: Colors.black87,
        ),
      ),
    );
  }
}
