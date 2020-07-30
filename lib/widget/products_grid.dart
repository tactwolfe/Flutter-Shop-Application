import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_item.dart';
import '../providers/products_provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavourite;

  ProductsGrid(this.showFavourite); //reciver this from product overview screen to know whether to show favourite only products by calling favourite getter method from the provider or to get all items by calling general getter method to get all items


  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context); //object of Products_provider class 

    final products = showFavourite? productsData.favouriteItems: productsData.items; //use the object above to access the favourite getter method of that provider class 
    //filtering logic  ^^^^^^^^^^ is assigned to show only favourite items or all

    return GridView.builder(

      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,

      itemBuilder: (ctx,i)=>ChangeNotifierProvider.value( //alternative changenotifierprovider syntax it can be used when we dont need any context
        // create: (ctx)=> products[index],                   //this approach is correct to be used in listview and grid view with builder function to avoid error because they recycled widget
        value: products[i],                               //used when we reuse existing object like here products that uses productData
        child:ProductItem(
        // products[index].id, 
        // products[index].title, 
        // products[index].imageUrl
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // max no. of grid item allower per row
        childAspectRatio: 3 / 2, //what will be the ratio of height and width of each  item
        crossAxisSpacing: 10,//distance between column  of the grid
        mainAxisSpacing: 10 //distance between rows of the grid

        ),
        );
  }
}