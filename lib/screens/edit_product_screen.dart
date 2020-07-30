//this widget will be used as screen to edit a product and add a new product
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  //-----------Focus nodes---------------//
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  //-----------Focus nodes---------------//

  final _imageUrlController =
      TextEditingController(); //this is going to be used to help the user the preview of the image he wants to add

  final _form = GlobalKey<FormState>();

  var _editedProduct = Product( //global map that which is the object of product class which will be used to save value tha is inputted into the textformfield
    id: null,
    title: "",
    price: 0,
    description: "",
    imageUrl: ""
    );
  
  var _isInit = true; //a boolean we create to make sure that didChangedependency doesnt run everytime
  
  var _isLoading = false;

  var _initValue = { //to add initial values to our text Field
    'title':'',
    'description':'',
    'price':'',
    'imageUrl':''
  };


  @override
  void initState() {
    _imageUrlFocusNode.addListener( _updateImageUrl);
    super.initState();
  }

  //gonna use this method to fetch a product that have an existing listing so we can edit it
  @override
  void didChangeDependencies() {
    if(_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String; //getting product id from argument
      
      //added this check so that when we are creating new products and we dont have a product id this change dependency wont run the below codes which might throw an error
      if(productId !=null){
      
      _editedProduct = Provider.of<Products>(context,listen: false).findById(productId); //fetching the product with that product id
        //assigning fetched product with _editedProduct so we can show some default value on editing screen so user can edit whatever he/she wants about the product
      
      _initValue = {
        'title': _editedProduct.title,
        'description': _editedProduct.description,
        'price': _editedProduct.price.toString(),
        // 'imageUrl': _editedProduct.imageUrl
        'imageUrl' : "",
       };
       _imageUrlController.text = _editedProduct.imageUrl;
     }
   }
    _isInit =false;
    super.didChangeDependencies();
  }


  
  //we use this dispose method becuse when we are done with this screen even then focusnodes and controllers  will remain in device memory which can leads to memory leaks thus to avoid that we use this method
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener( _updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  //function used to update url and show image preview
  void _updateImageUrl() {
    if(!_imageUrlFocusNode.hasFocus){
      
      
      setState(() {
        //validation check that will show or not show image preview based on conditions
        if(( !_imageUrlController.text.startsWith("http" ) 
        || !_imageUrlController.text.startsWith("https")) &&
        ( !_imageUrlController.text.endsWith(".png") 
        && !_imageUrlController.text.endsWith(".jpg") 
        && !_imageUrlController.text.endsWith(".jpeg"))){
        return ;
        }
        if(_imageUrlController.text.isEmpty){ //to do not keep previewing image if we delete image url inputted
          _imageUrlController.clear();
        }
      });
    }
  }

  Future<void>_saveForm() async{
   final isValidate = _form.currentState.validate(); //manual validation using global key
   if(! isValidate){
     return; //if not valid then this will simply retun and this function execution will stop and form wont save
   }
   _form.currentState.save(); //this will help to save/update the state of our form i.e the value entered into the textform field will be saved into global map and this will help to do so  

    setState(() {
      _isLoading = true;
    });
    

    //update if exist
    if(_editedProduct.id !=null ){
      await Provider.of<Products>(context,listen: false).updateProduct(_editedProduct.id, _editedProduct);
      
    } 
    //add if dont exist
    else{ 
       try{
         //here we called product provider listner and to that we call a method inside that provider class which add products to list of products and passed _edited products to send info about new product user inputs
         await Provider.of<Products>(context,listen: false).addProducts(_editedProduct);
         
       }catch(err){
           await showDialog<Null>( //added await here to wait for the user to close this dialog then proceed for finally if erro happen 
            context: context, 
            builder: (ctx)=> Container(
              child: AlertDialog(
                title: Text("An error Occurred"),
                content: Container(
                  height: MediaQuery.of(context).size.height/4,
                  child: Column(children: <Widget>[
                      Text("Something Went Wrong!"),
                      SizedBox(height: 10,),
                      Image.asset("assets/images/error.png",height: 100,width: 100,)
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
       }

      //  finally{ //this runs no matter we run into an error or everything runs smoothly
      //     setState(() {
      //      _isLoading = false;
      //     });
      //     Navigator.of(context).pop();
      //  }        
    }  
    setState(() {
      _isLoading = false;
      });
       Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save), 
            onPressed: _saveForm )
        ],
      ),
      body:
       _isLoading ? 
       Center(
         child: CircularProgressIndicator(),
       )

      :Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            key: _form,
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              //form field for product title
              TextFormField(
                initialValue: _initValue['title'],
                decoration: InputDecoration(labelText: "Product Title"),
                textInputAction: TextInputAction
                    .next, //to make sure once we done typing ,the softkeyboard will show next key pressing which will take us to next textfield
                onFieldSubmitted: (value) {
                  //here the value is the value we entered in the textfield and the onsubmit field method then can be used to go to next textfield using focusScope
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (inputValue) {
                  //we created a new product object because the property of product is final thus we need to create a new product 
                  _editedProduct = Product(
                    title: inputValue,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite
                  );
                } ,
                validator:(inputvalue){
                  if(inputvalue.isEmpty){
                    return 'Please provide a value';
                  }
                  return null;
                } ,
              ),


              //form field for product price
              TextFormField(
                initialValue: _initValue['price'],
                decoration: InputDecoration(labelText: "Product Price"),
                keyboardType: TextInputType
                    .number, //to make a number only keyboard appear to insert into this textfield
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,

                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                  onSaved: (inputValue) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: double.parse(inputValue),//parse t because price want double and the inputted price is of typr string
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite
                  );
                } ,
                validator: (inputValue){
                  if(inputValue.isEmpty){
                    return 'Please enter a price';
                  }
                  if(double.tryParse(inputValue) == null){
                    return 'Please enter a valid number';
                  }
                  if(double.parse(inputValue) <= 0) {
                    return 'Please enter a number greater than zero';
                  }
                  return null;
                }
              ),

              //form field for product description
              TextFormField(
                initialValue: _initValue['description'],
                decoration: InputDecoration(labelText: "Product Description"),

                //since description can be longer we use this argument to assign 3 lines to input description in this text field just for display because the user can indeed add more lines by press newline key on softkeyboard
                maxLines:3,
                
                // textInputAction: TextInputAction.next, //we dont need this argument because the multiline keyboard auomatically gives us the next key

                keyboardType: TextInputType
                    .multiline, //this gives us keyboard suitable for multiline textinputs

                //we dont use this onfieldSubmit because we dont know how long the user description will be so he/she has to go to next textfield manually
                // onFieldSubmitted: (_){
                //   FocusScope.of(context).requestFocus(_priceFocusNode);
                // },
                focusNode: _descriptionFocusNode,
                onSaved: (inputValue) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: inputValue,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite
                  );
                } ,
                validator: (inputValue) {
                  if(inputValue.isEmpty){
                    return 'Please Enter a Description of the product';
                  }
                  if(inputValue.length < 10 ){
                    return "Should be at least 10 character long";
                  }
                  return null;
                },
                
              ),

              //we use row in here because we not only want user to input image url but we also want to show him the preview of the image
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  //this conatiner will be used to show image preview
                  Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 20, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text("Enter a URL to preview the image",textAlign: TextAlign.center,)
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                                ),
                            )),

                  //the user will provide image url into this textField
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: "Image URL"),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_){
                      _saveForm();
                      },
                      onSaved: (inputValue) {
                       _editedProduct = Product(
                         title: _editedProduct.title,
                         price: _editedProduct.price,
                         description: _editedProduct.description,
                         imageUrl:inputValue,
                         id: _editedProduct.id,
                         isFavourite: _editedProduct.isFavourite
                       );
                     } ,
                     validator: (inputValue){
                       if(inputValue.isEmpty){
                         return "Enter an image URL";
                       }
                       if( !inputValue.startsWith("http" ) || !inputValue.startsWith("https") ){
                         return "please enter a valid URL";
                       }
                       if( !inputValue.endsWith(".png") && !inputValue.endsWith(".jpg") && !inputValue.endsWith(".jpeg") ){
                         return "Please enter a valid image URL";
                       }
                       return null;
                     },
                    ),
                  )
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
