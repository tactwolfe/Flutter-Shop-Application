import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; //to register our provider
import 'package:shop_app/providers/orders.dart';

import './screens/splashScreen.dart';
import 'screens/splashScreen_2.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products_provider.dart'; //link to our provider class
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //this class allows to register a provider class to which
    //the child widget can listen and whenever this provider class updates the widgets which are
    //listening (not all widget) to this provider class get notified about the change in data

    //we use this MultiProvier if we want to pass more than one provider to same root widget
    return MultiProvider(providers:[

       ChangeNotifierProvider(
        create: (_)=> Auth(),//create/builder method that return new instance of our Auth provided class
      ),

      //this syntax is used when we try to create a new object for the provided class
      ChangeNotifierProxyProvider< Auth , Products >(
      create: (_) => Products(null,null, []),
      update: (ctx,auth,previousProducts) => 
      Products(
        auth.token,
        auth.userId,
        previousProducts.items == null ? [] : previousProducts.items 
        ), //create/builder method that return new instance of our Products provided class
      ),

      ChangeNotifierProvider(
        create: (_)=> Cart(), //create/builder method that return new instance of our cart provided class
      ),

      ChangeNotifierProxyProvider<Auth , Orders>(
        create: (_)=> Orders(null,null,[]),
        //create/builder method that return new instance of our order provided class
        update: (ctx , auth , previousOrder) =>
        Orders(
          auth.token,
          auth.userId,
          previousOrder.orders == null ? [] : previousOrder.orders
        ), 
        
      ),

     
    ],
      child:
       Consumer<Auth>(
      builder:(ctx, auth, _) => 
       MaterialApp(
          title: "Shop App",
          theme: ThemeData(
              primarySwatch: Colors.deepOrange,
              accentColor: Colors.deepOrangeAccent,
              fontFamily: 'Lato'),
          home: 
          auth.isAuth ? ProductOverviewScreen() :
           AuthScreen(),
          // auth.isAuth ? MySplashScreen2() 
          // : MySplashScreen(),
          //  auth.isAuth ? ProductOverviewScreen() 
          // : MySplashScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            CartScreen.routeName: (ctx)=> CartScreen(),
            OrdersScreen.routeName: (ctx)=> OrdersScreen(),
            UserProductScreen.routeName: (ctx)=> UserProductScreen(),
            EditProductScreen.routeName: (ctx)=>EditProductScreen(),
            AuthScreen.routeName: (ctx)=>AuthScreen(),
          }),
      )
    );
  }
}


