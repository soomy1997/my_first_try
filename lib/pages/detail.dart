
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfirsttry/Models/purchasedBooks.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'dart:typed_data';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:myfirsttry/Models/book.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myfirsttry/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'Home_Page.dart';

import 'ShoppingCart.dart';

class Detail extends StatefulWidget {
 Detail({ Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);


  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new DetailState();
  
  }
  
  class DetailState extends State<Detail> {

  book booklist=new book('','','','','','');

  List<bookId> bookList = [];
   bookId books=new bookId('','','');
   
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  StreamSubscription<Event> _onbookAddedSubscription;
  StreamSubscription<Event> _onbookChangedSubscription;
  Query _BookQuery;

  @override
  void initState() {


    super.initState();

       bookList = new List();
    _BookQuery = _database
        .reference()
        .child("books")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _onbookAddedSubscription = _BookQuery.onChildAdded.listen(onEntryAdded);
    _onbookChangedSubscription =
        _BookQuery.onChildChanged.listen(onEntryChanged);




  populatingObject();
 
  }

   void populatingObject() async{

    
  SharedPreferences prefs = await SharedPreferences.getInstance();
  booklist.Descrption=prefs.getString("Type");
  booklist.ImageURL=prefs.getString("Image");
  booklist.AUTHOR=prefs.getString("Author");
  booklist.EDITION=prefs.getString("Edition");
  booklist.TITLE=prefs.getString("Title");
  booklist.PRICE=prefs.getString("Price");
  setState(() {
         
  });
  
   }


        
         @override
         Widget build(BuildContext context) {
      
           //app bar
           final appBar = AppBar(
             iconTheme: IconThemeData(
               color: Colors.black, //change your color here
             ),
             backgroundColor:Colors.green[100],
             elevation: .5,
             title: Text(' Book Description',

               style: TextStyle(color: Colors.black),
             ),
             centerTitle: true,

           );

                         ///detail of book image and it's pages
                         final topLeft = Column(
                           children: <Widget>[
                      
                             Container(
                       

                               padding: EdgeInsets.only(top: 15.0, left: 30.0, right: 0.0,),
                                 child:
                              
                                 Image( width:500 ,height: 400,image:NetworkImage("${booklist.ImageURL}")
                                 )
                             ),

                           ],
                         );
                     
                         ///detail top right
                         final topRight = Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                         Container(
                         padding: EdgeInsets.only(top: 95.0, left: 30.0, right: 0.0,),
                             child:
                             text("${booklist.TITLE}",
                                 size: 24, isBold: true, padding: EdgeInsets.only(top: 16.0)
                                 )),
                           Container(
                         padding: EdgeInsets.only(top: 15.0, left: 30.0, right: 0.0,),
                              child:
                             text(
                               "${booklist.AUTHOR}",
                               color: Colors.black54,
                               size: 24,
                              isBold: true
                              //padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                             )),
                             Row(
                               children: <Widget>[
                               Container(
                                 padding: EdgeInsets.only(top: 15.0, left: 30.0, right: 0.0,),
                                   child:
                                 text(
                                   "${booklist.PRICE} USD",
                                   size: 24,
                                   isBold: true,
                                 // padding: EdgeInsets.only(right: 8.0),
                                 )),
                            
                               ],
                             ),

                             SizedBox(height: 32.0),
                                  Container(
                                padding: EdgeInsets.only(top: 1.0, left: 30.0, right: 0.0,),
                                     child:
                                     Material(
                               borderRadius: BorderRadius.circular(20.0),
                               shadowColor: Colors.blue.shade200,
                               elevation: 5.0,
                                     child: MaterialButton(

                                 onPressed: ()
                                  {
                        addBook(booklist.TITLE,booklist.PRICE,booklist.ImageURL);
                         print("user details  ${widget.userId}");
                               
                                 },
                                 minWidth: 10.0,
                                 color:  Colors.green[100],
                                 child: text('BUY IT NOW', color: Colors.black, size: 15,isBold: true),
                               ),
                             ),)
                           ],
                         );
                     
                         final topContent = Container(
                           color:  Colors.white,
                           padding: EdgeInsets.only(bottom: 0),
                           child: Row(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: <Widget>[
                              Flexible(flex: 1, child: topLeft),
                               Flexible(flex: 1, child: topRight),
                             ],
                           ),
                         );

                         ///scrolling text description
                    
                         return Scaffold(
                           backgroundColor: Colors.white,
                           appBar: appBar,
                           body: Column(
                             children: <Widget>[topContent

                           ],
                           ),
                         );
                       }
                       ///create text widget
                       text(String data,
                               {Color color = Colors.black87,
                               num size = 14,
                               EdgeInsetsGeometry padding = EdgeInsets.zero,
                               bool isBold = false}) =>
                           Padding(
                             padding: padding,
                             child: Text(
                               data,
                               style: TextStyle(
                                   color: color,
                                   fontSize: size.toDouble(),
                                   fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
                             ),
                           );
                     
              
  void navigateToCart() async {

    Navigator.push(context, new MaterialPageRoute(builder: (ctxt) => new ShoppingCart(
      key : widget.key,
      userId: widget.userId,
      auth: widget.auth,
      logoutCallback:widget.logoutCallback,
    )));
  }

  void onEntryAdded(Event event) {
    bookList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      bookList.add(bookId.fromSnapshot(event.snapshot));
    });
  }

  onEntryChanged(Event event) {
    var oldEntry = bookList.singleWhere((entry) {
      return entry.key == event.snapshot.key;

    });

    setState(() {
      bookList[bookList.indexOf(oldEntry)] =
          bookId.fromSnapshot(event.snapshot);
    });

  }


  void addBook (String _TITLE, String _PRICE, String ImgURL)async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
   String OrderId =prefs.getString("OrderID");
    if (OrderId!=null){
      bookId b = new bookId(_TITLE,  _PRICE, ImgURL);
      _database.reference().child(widget.userId).child("orders").child(OrderId).child("OrderItems").push().set(b.toJson()); 
    }
    else if(OrderId==null){
   Random random = new Random();
    int randomNumber = random.nextInt(10000)+ 1;

     OrderId = randomNumber.toString();

    bookId b = new bookId(_TITLE,  _PRICE, ImgURL);

                   prefs.setString("OrderID", OrderId);

    _database.reference().child(widget.userId).child("orders").child(OrderId).child("OrderItems").push().set(b.toJson());
     
    }

       Fluttertoast.showToast(
          msg: "added to cart Successfuly",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
  }       
              
  
  }
