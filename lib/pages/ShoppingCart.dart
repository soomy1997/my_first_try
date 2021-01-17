import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfirsttry/Models/purchasedBooks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfirsttry/Models/book.dart';
import 'package:myfirsttry/pages/Home_Page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myfirsttry/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'Profile.dart';
import 'checkout.dart';

class ShoppingCart extends StatefulWidget {

 ShoppingCart({ Key key, this.auth, this.userId, this.logoutCallback})
    : super(key: key);

 final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}



class _ShoppingCartState extends State<ShoppingCart> {

  book booklist = new book('', '', '', '', '', '');


  List<bookId> books = [];
  List<String> KeyList = [];
  ShoppingCart cart;
  String total= "0.00";
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  StreamSubscription<Event> _onbookAddedSubscription;
  StreamSubscription<Event> _onbookChangedSubscription;
  Query _BookQuery;


  void initState() {
    super.initState();
      _BookQuery = _database
        .reference()
        .child("books")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _onbookAddedSubscription = _BookQuery.onChildAdded.listen(onEntryAdded);
    _onbookChangedSubscription =
        _BookQuery.onChildChanged.listen(onEntryChanged);

    getbook();
   

  }
  void getbook()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
     String OrderId =prefs.getString("OrderID");
    DatabaseReference bookRef = FirebaseDatabase.instance.reference().child(widget.userId).child("orders").child(OrderId).child("OrderItems");

    bookRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var Data = snap.value;

      books.clear();
      for (var individualKey in KEYS) {
        bookId bookData = new bookId(
          Data[individualKey]['Title'],
          Data[individualKey]['Price'],
          Data[individualKey]['Image'],
        );

        books.add(bookData);

      }
      KeyList.clear();
      for( var getKey in KEYS){

        KeyList.add(getKey.toString());

      }
    
      setState(() {
      
        
                print('Length : $books.length');
                print('KeyList :${widget.userId}');
        
              });
            });
          }
        
        
      
        
          @override
          Widget build(BuildContext context) {
              total=returnTotalAmount(books);
            if (books == null) {
              books = List<bookId>();
            }
        
            return Scaffold(
        
        
              appBar: AppBar(
        
                leading: new Container(),
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                backgroundColor:Colors.green[100],
                elevation: .5,
                title: Text('Shopping Cart',
        
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
        
              ),
        
              body: books.isEmpty ? Center(child: Text('No items in the cart')) : ListView.builder(
                itemCount: books.length ,
                itemBuilder: (BuildContext context, int position) {
                  return Card(
                      color: Colors.white,
                      elevation: 2.0,
                      child: ListTile(
        
                        title: new Stack(children: <Widget>[
                 Row(
                           children: <Widget>[
                          Container(
                            width:70,

                            child:
                             Image(
                               image:NetworkImage("${books[position].ImageURL}"

                               ),height: 150,

                               alignment:Alignment.topLeft,
                             ),),
                           ],
                         ),

                        Padding(padding: EdgeInsets.fromLTRB(100,0,0,0)),
                  new Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.fromLTRB(320,15,0,0)),
                        Text("${books[position].TITLE}")
                        ,
                      
                        Padding(padding: EdgeInsets.only(top: 15.0)),
                        Text("${books[position].PRICE} USD"
                        ),
                        Padding(padding: EdgeInsets.only(top: 15.0)),


                      ]),

                        ]),

                 trailing: GestureDetector(
                  child: Icon(Icons.delete, color: Colors.grey,),
                  onTap: () {
                    delete(position);
                                       },
                                     )
                                                                   )
                                                               );
                                                             },
                                                     
                                                           ),
                                                         persistentFooterButtons: 
                                                         <Widget>[
                                                          
                                                               Text(
                                                                 "Total:",
                                                                 style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                                                               ),
                                                               Text(
                                                                 "$total",
                                                                 style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
                                                          
                                                         ),
                                                         new RaisedButton(
                                                                color: Colors.green[100],
                                                                child: Text(
                                                                  'Checkout',
                                                                  style: TextStyle(color: Colors.black),
                                                                ),
                                                               
                                                                shape: new RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(10.0)
                                                                ), onPressed: () { 
                                                                  navigateToCheckout(context);
                                                                  
                                                                 },
                                                     
                                                              ),
                                                         ],
                                                         
                                                           
                                                           bottomNavigationBar: CurvedNavigationBar(
                                                        backgroundColor:Colors.green[100],
                                                                height: 50,
                                                               items: <Widget>[
                                                                Icon(Icons.person_outline , color:Colors.black, ),
                                                               Icon(Icons.home , color:Colors.black),
                                                               Icon(Icons.shopping_cart , color:Colors.black),
                                                               Icon(Icons.exit_to_app , color:Colors.black),
                                                     
                                                               ],
                                                               animationDuration: Duration(
                                                                 microseconds: 200
                                                               ),
                                                               animationCurve: Curves.bounceInOut,
                                                               index: 2,
                                                             
                                                               onTap: (index)async{
                                                                  if (index==1){
                                                                  
                                                         Navigator.push(context, new MaterialPageRoute(builder: (ctxt) => new HomeList(
                                                        userId:widget.userId,
                                                          auth:widget.auth,
                                                          logoutCallback: widget.logoutCallback,
                                                         )));
                                                       
                                                                    
                                                                  }
                                                                  if(index==0){
                                                                   
                                                       Navigator.push(context, new MaterialPageRoute(builder: (ctxt) => new ProfilePage(
                                                        userId:widget.userId,
                                                          auth:widget.auth,
                                                          logoutCallback: widget.logoutCallback,
                                                         )));
                                                       
                                                            
                                                                    
                                                                  }
                                                                           if(index==2){
                                                                           
                                                       Navigator.push(context, new MaterialPageRoute(builder: (ctxt) => new ShoppingCart(
                                                        userId:widget.userId,
                                                          auth:widget.auth,
                                                          logoutCallback: widget.logoutCallback,
                                                         )));
                                                       
                                                            
                                                                    
                                                                  }
                                                                   if (index==3){
                                                               
                                                                try {
                                                                       
                                                           await widget.auth.signOut();
                                                             widget.logoutCallback();
                                                           Navigator.push(context, new MaterialPageRoute(builder: (ctxt) => new MyApp()))
                                                         
                                                         ;
                                                         } catch (e) {
                                                           print(e);
                                                         }     
                                                                                   }
                                                                      
                                                                                },
                                                                                
                                                                                
                                                                                
                                                                           ),
                                                         );
                                             
                                                       }
                                                       signOut() async {
                                                         try {
                                                          await widget.auth.signOut();
                                                          widget.logoutCallback();
                                                         } catch (e) {
                                                           print(e);
                                                         }
                                                       }
                                                     
                                                      
                             
                                   String returnTotalAmount(List<bookId> books) {
                                     String total="0.00";
                                       double totalAmount = 0.0;
                                     for(int i=0 ; i<books.length;i++){
                                         double prices = double.parse(books[i].PRICE);
                                           
                                             
                                                 totalAmount = totalAmount + prices;
                                             
                                                 total=totalAmount.toStringAsFixed(2); 
                                                
                                     }
                                              
                                             
                                                 return total;
                                             
                                               }
                                                 void navigateToCheckout(BuildContext context) async {
                                                  
                                         SharedPreferences prefs = await SharedPreferences.getInstance();
                                         prefs.setString("Price", total);
                                                         Navigator.push(context, new MaterialPageRoute(builder: (ctxt) =>
                                                         new Payment(
                                                           key: widget.key,
                                                          userId:widget.userId,
                                                           auth: widget.auth,
                                                           logoutCallback: widget.logoutCallback,
                                                         )));
                                                       }
                     
                          
                                    void onEntryAdded(Event event) {
        books.singleWhere((entry) {
          return entry.key == event.snapshot.key;
        });
        setState(() {
          books.add(bookId.fromSnapshot(event.snapshot));
        });
      }
    
      onEntryChanged(Event event) {
        var oldEntry = books.singleWhere((entry) {
          return entry.key == event.snapshot.key;
    
        });
    
        setState(() {
          books[books.indexOf(oldEntry)] =
              bookId.fromSnapshot(event.snapshot);
        });
    
      }
    
      void delete(int position) async{

           
  SharedPreferences prefs = await SharedPreferences.getInstance();
   String OrderId =prefs.getString("OrderID");
           String keyitem=KeyList[position];
           
                 _database.reference().child(widget.userId).child("orders").child(OrderId).child("OrderItems").child("$keyitem").remove();
                  (context as Element).reassemble();
    Navigator.push(context, new MaterialPageRoute(builder: (ctxt) => new ShoppingCart(
      key: widget.key,
      userId: widget.userId,
      auth: widget.auth,
      logoutCallback:widget.logoutCallback,

    )));
    Fluttertoast.showToast(
        msg: "Deleted Successfuly",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );




        
      }
                                
                                  }

















