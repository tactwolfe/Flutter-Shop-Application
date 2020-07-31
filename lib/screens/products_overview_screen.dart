//this is a screen wiget which will show the products we have in a grid view

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widget/app_drawer.dart';
import '../widget/products_grid.dart';
import '../widget/badge.dart';
import './cart_screen.dart';
import '../providers/products_provider.dart';

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
  var _isInit = true;
  var _isLoading =false;

  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
        _isLoading = true;
      });
      
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
        
      }).catchError((err){
        setState(() {
          _isLoading = false;
        });
        showDialog<Null>( //added await here to wait for the user to close this dialog then proceed for finally if erro happen 
            context: context, 
            builder: (ctx)=> Container(
              child: AlertDialog(
                title: Text("Error fetching the data"),
                content: Container(
                  height: MediaQuery.of(context).size.height/4,
                  child: Column(children: <Widget>[
                      Text("No Products found"),
                      SizedBox(height: 10,),
                      Image.asset("assets/images/sad_dog.png",height: 100,width: 100,)
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Okay"),
                    onPressed: (){
                    Navigator.of(ctx).pop();
                   })
                ],
              ),
            )
            );
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }


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
      body: _isLoading ?
      Center(
        child: CircularProgressIndicator(),
        ) 
      :ProductsGrid( _showOnlyFavouriteData), //pass the value of  _showOnlyFavouriteData to product grid to toggle between favourite itesm and all items  we recieved this bool at productGrid as an argument to its constructor
    );
  }
}
