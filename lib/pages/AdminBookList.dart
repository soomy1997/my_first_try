import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfirsttry/Models/book.dart';

import 'package:myfirsttry/pages/AdminBookDetails.dart';
import 'package:myfirsttry/services/authentication.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfirsttry/pages/AdminBookADD.dart';

import '../main.dart';

class AdminBookList extends StatefulWidget {
  AdminBookList({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new AdminBookListState();
}


class AdminBookListState extends State<AdminBookList> {

  List<book> bookList = [];
  List<String> KeyList = [];
  StreamSubscription<Event> _onbookAddedSubscription;
  StreamSubscription<Event> _onbookChangedSubscription;

  void initState() {
    super.initState();
    getbookList();
  }
   void getbookList(){
     DatabaseReference bookRef = FirebaseDatabase.instance.reference().child(
         "book");

     bookRef.once().then((DataSnapshot snap) {
       var KEYS = snap.value.keys;
       var Data = snap.value;

       bookList.clear();
       for (var individualKey in KEYS) {

         book bookData = new book(
           Data[individualKey]['Title'],
           Data[individualKey]['Author'],
           Data[individualKey]['Edition'],
           Data[individualKey]['Price'],
           Data[individualKey]['Type'],
           Data[individualKey]['Image'],

         );

         bookList.add(bookData);

       }
       KeyList.clear();
       for( var getKey in KEYS){

         KeyList.add(getKey.toString());

       }

       setState(() {
         print('Length : $bookList.length');
         print('KeyList :${widget.userId}');

       });
     });
   }


  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (bookList == null) {
      bookList = List<book>();
    }

    return Scaffold(

      appBar: AppBar(
          leading: new Container(),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor:Colors.green[100],
          elevation: .5,
          title: Text('Books',

            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,

        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.black)),
              onPressed: signOut)
        ],
      ),

      body: ListView.builder(
        itemCount: bookList.length,
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
                               image:NetworkImage("${bookList[position].ImageURL}"

                               ),height: 150,

                               alignment:Alignment.topLeft,
                             ),),
                           ],
                         ),

                  Padding(padding: EdgeInsets.fromLTRB(100,0,0,0)),
                  new Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.fromLTRB(320,15,0,0)),
                        Text("${bookList[position].TITLE}")
                        ,
                        Padding(padding: EdgeInsets.only(top: 15.0)),
                        Text("${bookList[position].EDITION}"),
                        Padding(padding: EdgeInsets.only(top: 15.0)),
                        Text("${bookList[position].AUTHOR}"
                        ),
                        Padding(padding: EdgeInsets.only(top: 15.0)),
                        Text("${bookList[position].PRICE} USD"
                        ),
                        Padding(padding: EdgeInsets.only(top: 15.0)),


                      ]),

                ]),
                trailing: GestureDetector(
                  child: Icon(Icons.edit, color: Colors.grey,),
                  onTap: () async{
                    String keyitem=KeyList[position];
                    String Title=bookList[position].TITLE;
                    String Author=bookList[position].AUTHOR;
                    String Edition=bookList[position].EDITION;
                    String Type=bookList[position].Descrption;
                    String Price=bookList[position].PRICE;
                    String Image=bookList[position].ImageURL;

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString("keyID", keyitem);
                    prefs.setString("Title", Title);
                    prefs.setString("Author", Author);
                    prefs.setString("Edition", Edition);
                    prefs.setString("Type", Type);
                    prefs.setString("Price", Price);
                    prefs.setString("Image", Image);
                    navigateToDetail();
                  },
                ),
              ));
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[100],
        onPressed: () {

          navigateToADDDetail();

        },
        tooltip: 'Add Note',

        child: Icon(Icons.add,
        color:Colors.black ,),

      ),
    );
  }
  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
       Navigator.push(context, new MaterialPageRoute(builder: (ctxt) => new MyApp()));
    
    } catch (e) {
      print(e);
    }
  }
  void navigateToDetail() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
                
    Navigator.push(context, new MaterialPageRoute(builder: (ctxt) => new AdminBookDetails(

      key: widget.key,
      userId: widget.userId,
      auth: widget.auth,
      logoutCallback:widget.logoutCallback,
      imageurl: prefs.getString("Image"),
    )));
  }
  void navigateToADDDetail() async {
    Navigator.push(context, new MaterialPageRoute(builder: (ctxt) => new AdminBookADD(
      key: widget.key,
      userId: widget.userId,
      auth: widget.auth,
      logoutCallback:widget.logoutCallback,
    )));
  }



  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}