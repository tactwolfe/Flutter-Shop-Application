import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {  //for a particular route to show custom route transition
  CustomRoute({
    WidgetBuilder builder ,
    RouteSettings settings
    }) 
    : super(
      builder : builder ,
      settings : settings
    );

    @override
  Widget buildTransitions(
    BuildContext context, 
    Animation<double> animation, 
    Animation<double> secondaryAnimation, 
    Widget child
    ) {
    if(settings.name == "/") {
      return child;
    }
    return FadeTransition(
      opacity: animation, 
      child : child
      );
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder { //to use as pagetransition theme for the whole app

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context, 
    Animation<double> animation, 
    Animation<double> secondaryAnimation, 
    Widget child
    ) {
    if(route.settings.name == "/") {
      return child;
    }
    return FadeTransition(
      opacity: animation, 
      child : child
      );
  }

}