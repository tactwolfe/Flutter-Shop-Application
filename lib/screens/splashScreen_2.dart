import 'package:flutter/material.dart';
import '../screens/products_overview_screen.dart';
import 'dart:async';


class MySplashScreen2 extends StatefulWidget {
  @override
  _MySplashScreen2State createState() => _MySplashScreen2State();
}

class _MySplashScreen2State extends State<MySplashScreen2> {

  @override
  // void initState() {


  //   super.initState();
  //   Timer(
  //     Duration(seconds: 3),
  //     () => Navigator.of(context)
  //         .pushReplacementNamed(ProductOverviewScreen.routeName),
  //   );
  // }
  void didChangeDependencies() {

    super.didChangeDependencies();
      Timer(
      Duration(seconds: 3),
      () => Navigator.of(context)
          .pushReplacementNamed(ProductOverviewScreen.routeName));
  }



  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: Colors.white,
          ),
          Positioned(
            top: ((MediaQuery.of(context).size.height / 2) - 330),
            left: MediaQuery.of(context).size.width / 4,
            right: MediaQuery.of(context).size.width / 4,
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/images/shop_logo.gif",
                  height: 500,
                ),
                CircularProgressIndicator()
              ],
            ),
          )
        ],
      ),
    );
  
  }
}