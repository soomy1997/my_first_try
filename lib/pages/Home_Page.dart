import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfirsttry/Models/BookTypes.dart';
import 'package:myfirsttry/pages/ShoppingCart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfirsttry/Models/book.dart';
import 'package:myfirsttry/services/authentication.dart';
import 'package:myfirsttry/services/authentication.dart';

import '../main.dart';
import 'ShoppingCart.dart';

import 'Profile.dart';
import 'detail.dart';
import 'login_signup_page.dart';

class HomeList extends StatefulWidget {
  HomeList({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new HomeListState(this.auth,this.logoutCallback,this.userId);
  
}
    class HomeListState extends State<HomeList>  {
   List<book> ChildbookList = [];
   List<book> DevlopmentbookList = [];
   List<book> ComputerbookList = [];
   List<book> CookerybookList = [];
   List<book> LangugesbookList = [];
   List<String> ChildKeyList = [];
   List<String> DevlopmentKeyList = [];
   List<String> ComputerKeyList = [];
   List<String> CookeryKeyList = [];
   List<String> LangugesKeyList = [];
  final VoidCallback logoutCallback;
  final String userId;
  StreamSubscription<Event> _onbookAddedSubscription;
  StreamSubscription<Event> _onbookChangedSubscription;

  HomeListState(firebaseAuth, this.logoutCallback, this.userId);
  
void initState() {
    super.initState();
    DatabaseReference bookRef = FirebaseDatabase.instance.reference().child(
        "book");

    bookRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var Data = snap.value;
    
      ChildbookList.clear();
      for (var individualKey in KEYS) {

        book bookData = new book(
           Data[individualKey]['Title'],
           Data[individualKey]['Author'],
           Data[individualKey]['Edition'],
           Data[individualKey]['Price'],
           Data[individualKey]['Type'],
           Data[individualKey]['Image'],
        );

         if(bookData.Descrption=="Chlidren Books"){
        ChildbookList.add(bookData);
            ChildKeyList.add(individualKey.toString());
        
        }
         else if(bookData.Descrption=="Self Devlopment"){
        DevlopmentbookList.add(bookData);
            DevlopmentKeyList.add(individualKey.toString());
        
        }

          else if(bookData.Descrption=="Computer And Technology"){
        ComputerbookList.add(bookData);
            ComputerKeyList.add(individualKey.toString());
        
        }

          else if(bookData.Descrption=="Cookery"){
        CookerybookList.add(bookData);
            CookeryKeyList.add(individualKey.toString());
        
        }

          else if(bookData.Descrption=="Learning Languges"){
        LangugesbookList.add(bookData);
            LangugesKeyList.add(individualKey.toString());
        
        }
      }
      
         
      setState(() {
           
       // print('Length : $bookList.length');
        print('KeyList :${widget.userId}');
          print('authin :${widget.auth}');


      }
      );
    }
    );
  }
  
@override
    Widget build(BuildContext context) {
    HomeList o;
            return Scaffold(
      
                 appBar: AppBar(
                    leading: new Container(),
                    backgroundColor:Colors.green[100],
                   elevation: .5,
                   title: Text('Home',
                   style: TextStyle(color: Colors.black),
                   ),
                   centerTitle: true,
    
                 ),
                       
                            body: Container(
                            
                 
                              child: Stack(
                                children: <Widget>[
                        
                                       Container(
                                       child: SingleChildScrollView(
                                        child:  Column(
                                         children: <Widget>[
           
                                BookListView(
                                  title: "Childrens",
                                  books: ChildbookList,
                                   keys: ChildKeyList,
                                    auth: widget.auth,
                                   userid: widget.userId,
                                   
                                ),
                                   BookListView(
                                  title: "Cookery",
                                  books: CookerybookList,
                                   keys: CookeryKeyList,
                                        auth: widget.auth,
                                   userid: widget.userId,
                                ),
                                   BookListView(
                                  title: " Computer And Technology",
                                  books: ComputerbookList,
                                   keys: ComputerKeyList,
                                        auth: widget.auth,
                                   userid: widget.userId,
                                ),

                                

                                   BookListView(
                                  title: "Learning Languges",
                                  books: LangugesbookList,
                                   keys: LangugesKeyList,
                                        auth: widget.auth,
                                   userid: widget.userId,
                                ),

                                   BookListView(
                                  title: "Self Devlopment",
                                  books: DevlopmentbookList,
                                   keys: DevlopmentKeyList,
                                     auth: widget.auth,
                                   userid: widget.userId
                                ),
                          


                                         ]
                                          )
                                          )
                                      ),
                          ],
                        ),
                      ),

                      bottomNavigationBar:CurvedNavigationBar(
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
          index: 1,
        
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
   logoutCallback();
      Navigator.push(context, new MaterialPageRoute(builder: (ctxt) => new MyApp()));
    
    } catch (e) {
      print(e);
    }     
                              }
                 
                           },
                           
                           
                           
                      ),
                    );
              
              }
                
                
                  

}
  
    BoxDecoration backgroundGradient() {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          tileMode: TileMode.mirror,
          stops: [0.0, 0.3, 0.4, 1,1.2],
          colors: [
           Colors.white,
           Colors.white,
           Colors.white,
           Colors.white,
           Colors.white,
          ],
        ),
      );
    }
  
  
class BookListView extends StatelessWidget {
  final String title;
  final List<book> books;
  final BaseAuth auth;
  final String userid;

  final List<String>  keys;

  const BookListView({Key key, @required this.title, @required this.books,@required this.keys,@required this.auth,@required this.userid
   })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return CustomPaint(
      painter: LinePainter(),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 36.0),
            child: Text(title, style: Theme.of(context).textTheme.subtitle),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            height: 200,
           
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: books.length,
              itemBuilder: (BuildContext context, int index) {
                return BookCard( 
                  
                 bookValue:books[index],
                 keys:keys[index],
                 userid: userid,
                 auth: auth,
                
                );
              },
            ),
            
          ),

        ],
      ),
    );
  }
}

class BookCard extends StatelessWidget {

  final book bookValue;

  final String  keys;
    final BaseAuth auth;
  final String userid;

  const BookCard({  @required this.bookValue,@required this.keys,@required this.auth,@required this.userid
   })
      : super();

  @override
  Widget build(BuildContext context) {
   
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 1,
            offset: Offset(4, 5),
            blurRadius: 5,
          )
        ],
      ),
      
      child: GestureDetector(
  onTap: () async {
   String keyitem=keys;
                    String Title=bookValue.TITLE;
                    String Author=bookValue.AUTHOR;
                    String Edition=bookValue.EDITION;
                    String Type=bookValue.Descrption;
                    String Price=bookValue.PRICE;
                    String Image=bookValue.ImageURL;

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString("keyID", keyitem);
                    prefs.setString("Title", Title);
                    prefs.setString("Author", Author);
                    prefs.setString("Edition", Edition);
                    prefs.setString("Type", Type);
                    prefs.setString("Price", Price);
                    prefs.setString("Image", Image);
                    
        print("UserID in BookCard: $userid");
      print("Auth in BookCard: $auth");
         Navigator.push(context, new MaterialPageRoute(builder: (ctxt) => new Detail(
       userId: userid,
       auth: auth,
      
    )));

                      }, // handle your image tap here
                      child:  Image( image:NetworkImage("${bookValue.ImageURL}"),  ),
                    ),
                        );
                      }
                    
               
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green[100]
      ..strokeWidth = 0.2
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(0, size.height + 10);
    path.lineTo(size.width, size.height + 10);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
  


}


