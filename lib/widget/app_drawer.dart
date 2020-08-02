import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/products_overview_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/auth_provider.dart';
import '../helpers/custom_route_animation.dart';


class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:Column(
        children: <Widget>[
           AppBar(
            title: Text("Hello Friend!"),
            automaticallyImplyLeading: false, //it will not apply backbutton in the appBar now
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.shop),
              title: Text("Shop"),
              onTap: (){
                Navigator.of(context).pushReplacementNamed(ProductOverviewScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text("My Orders"),
              onTap: (){
                Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
                // Navigator.of(context).
                // pushReplacement(CustomRoute(
                //   builder: (ctx)=>OrdersScreen(),
                //   ),
                // );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Manage Products"),
              onTap: (){
                Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed("/");
                Provider.of<Auth>(context,listen: false).logout();
              },
            )

        ],
      ) ,
    );
  }
}