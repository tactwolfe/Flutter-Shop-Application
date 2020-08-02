import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import '../providers/auth_provider.dart';
import '../model/http_exceptions.dart';

enum AuthMode { Signup, Login } //this enum is used to switch between two auth mode i.e login & signup

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.title.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin {

  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  
  AnimationController _controller; //animation controller
  Animation<Size>_heightAnimation; //the type of animation we want here hight animation only

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _heightAnimation = Tween<Size>(
      begin: Size(double.infinity, 260), //container min height during animation
      end: Size(double.infinity, 320) //container max height during animation
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
        // _heightAnimation.addListener(
        //   ()=> setState((){})
        // );
  }

  @override
  void dispose() {
    
    super.dispose();
    _controller.dispose();
  }



  //method to show a dialog to the user incase an error had occured during authentication
  void _showErrorDialog(String message){
    showDialog(
      context: context,
      builder: (ctx)=> AlertDialog(
        title: Text("An error occured!"),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text("Okay"),
            onPressed: (){
              Navigator.of(ctx).pop();
            }, 
            )
        ],
      )
      );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {  
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context,listen: false).login(
          _authData["email"], 
          _authData["password"]
          );
      } else {
        // Sign user up by using provider to call signup method in auth provider and forward email and password
        await Provider.of<Auth>(context,listen: false).signup(
          _authData['email'],
          _authData['password']
        );
      }
    }
    on HttpExceptions catch(error) { //a special type of error catching function that catch a specific type of error

      var errorMessage = "Authentication failed"; //default error message

      //----------------------------more customed error message----------------------------------//
      
      if(error.toString().contains("EMAIL_EXISTS")){
        errorMessage = "This email address is already in use";
      }
      else if(error.toString().contains("INVALID_EMAIL")){
        errorMessage = "this is not a valid email address";
      }
      else if(error.toString().contains("WEAK_PASSWORD")){
        errorMessage = "This password is to weak";
      }
      else if(error.toString().contains("EMAIL_NOT_FOUND")){
        errorMessage = "Could not find a user with that email";
      }
      else if(error.toString().contains("INVALID_PASSWORD")){
        errorMessage = "Invalid Password";
      }

      _showErrorDialog(errorMessage);

       //----------------------------more customed error message----------------------------------//
    }
    catch(error){ //this catch method execute if there was no httpexception error happend that we had defined
      const errorMessage = "Could not authenticate you right now. please try again later";
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward(); //to increase the height of our animated container to show confirm password
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();//to decrease the height of our animated container to show email and login only
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300), //duration of animation
        curve: Curves.easeIn, //what kind of curve animation we want
        height: _authMode == AuthMode.Signup ? 320 : 260,
        // height: _heightAnimation.value.height,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260,),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child:  Form( //child argument that is passed into the builder to remain constant and not rebuild since we dont want to animate this
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                     return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true, //to hide password and show star markings
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                
                //this button chnages the auth mode
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, //to shrink the button
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ) ,
        ),
    );
  }
}
