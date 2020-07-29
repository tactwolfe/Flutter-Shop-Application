//this is a screen wiget which will show the products we have in a grid view

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widget/app_drawer.dart';
import '../widget/products_grid.dart';
import '../widget/badge.dart';
import './cart_screen.dart';

//the enums we are going to use as values for our PopupMenuItems
enum FilterOptions { Favourites, All }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = 'product-overview';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavouriteData =
      false; //this bool is used to toggle our gridview of products to show all items or favourite items

  @override
  Widget build(BuildContext context) {
    // final cart = Provider.of<Cart>(context, listen: false); //object of provider class

    return Scaffold(
      appBar: AppBar(
        title: Text(" MyShop 🛒"),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (ctx, cart, ch) =>
                Badge(child: ch, value: cart.itemCount.toString()),
            child: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favourites) {
                  _showOnlyFavouriteData = true;
                } else {
                  _showOnlyFavouriteData = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favourite'),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer() ,
      body: ProductsGrid(
          _showOnlyFavouriteData), //pass the value of  _showOnlyFavouriteData to product grid to toggle between favourite itesm and all items  we recieved this bool at productGrid as an argument to its constructor
    );
  }
}
