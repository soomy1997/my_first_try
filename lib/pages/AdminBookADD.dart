import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:myfirsttry/Models/BookTypes.dart';
import 'package:path/path.dart' as Path;
import 'dart:typed_data';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:myfirsttry/Models/book.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfirsttry/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myfirsttry/pages/AdminBookList.dart';
class AdminBookADD extends StatefulWidget {

  AdminBookADD({ Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);


  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  List<book> booklist;
  String appBarTitle="1";


  @override
  State<StatefulWidget> createState() => new AdminBookDetailsState(this.booklist, this.appBarTitle,this.auth,this.logoutCallback,this.userId);
}

class AdminBookDetailsState extends State<AdminBookADD> {



  List<book> booklist;
  String appBarTitle="2";
  BaseAuth auth;
   VoidCallback logoutCallback;
   String userId ;
   
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<BookType> _Booktypes = BookType.getbooktype();
  List<DropdownMenuItem<BookType>> _dropdownMenuItems;
  BookType _selectedType;
String typeController;
  StreamSubscription<Event> _onbookAddedSubscription;
  StreamSubscription<Event> _onbookChangedSubscription;
  Query _BookQuery;

  @override
  void initState() {
     _dropdownMenuItems = buildDropdownMenuItems(_Booktypes);
         _selectedType = _dropdownMenuItems[0].value;
      typeController=_dropdownMenuItems[0].value.name;
    super.initState();
     
 
    //_checkEmailVerification();

    booklist = new List();
    _BookQuery = _database
        .reference()
        .child("books")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _onbookAddedSubscription = _BookQuery.onChildAdded.listen(onEntryAdded);
    _onbookChangedSubscription =
        _BookQuery.onChildChanged.listen(onEntryChanged);


  }

  
 List<DropdownMenuItem<BookType>> buildDropdownMenuItems(List<BookType> booktypes) {

 List<DropdownMenuItem<BookType>> items = List();
    for (BookType booktype in booktypes) {
      items.add(
        DropdownMenuItem(
          value: booktype,
          child: Text(booktype.name),
        ),
      );
    }
    return items;

        }


  TextEditingController titleController = TextEditingController();
  TextEditingController editionController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  
  TextEditingController priceController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  File _image;
  String _uploadedFileURL;
  String url;
  bool visibilityObs = false;

 

  AdminBookDetailsState(this.booklist, this.appBarTitle, this.auth, this.logoutCallback, this.userId);

  @override
  Widget build(BuildContext context) {
    print("auth:${widget.logoutCallback}");
    TextStyle textStyle = Theme.of(context).textTheme.title;
    visibilityObs=false;

    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor:Colors.green[100],
            elevation: .5,
            title: Text(' Add Book',

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

          body:
 

          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 60.0, right: 60.0),
            child: ListView(
              children: <Widget>[
               _uploadedFileURL==null ? Padding(
                     padding: EdgeInsets.only(top: 0, bottom: 0),
                ) :Padding(
                   
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Image( width:500 ,height: 400,image:NetworkImage("$_uploadedFileURL")
                                 ),
                ),
            
                Padding(
                  padding: EdgeInsets.only(top: 2.0, left: 60.0, right: 60.0,),
                  child: RaisedButton(
                      color: Colors.green[100],
                      textColor: Colors.black,
                      child:

                      Text("ADD image"
                      ),
                      onPressed:() async{
                        await ImagePicker.pickImage(source: ImageSource.gallery).then((image) async {
                          setState(() {
                            _image = image;
                          });
                          StorageReference storageReference = FirebaseStorage.instance
                              .ref()
                              .child('chats/${Path.basename(_image.path)}}');

                          StorageUploadTask uploadTask = storageReference.putFile(_image);
                          uploadTask.onComplete;
                          print('File Uploaded');
                          storageReference.getDownloadURL().then((fileURL) {
                            setState(() {
                              _uploadedFileURL = fileURL;
                              _changed(true);
                            });
                          });
                        },);}


                  ),),


                // // First  Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {

                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: editionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');

                    },
                    decoration: InputDecoration(
                        labelText: 'Edition',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: authorController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');

                    },
                    decoration: InputDecoration(
                        labelText: 'Author',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child:   DropdownButton(
                  value: _selectedType,
                  items: _dropdownMenuItems, 
                  
                  onChanged: (BookType value) {
                    setState(() {

                      _selectedType=value;
                           typeController=value.name;
                    });
                   
                    },
              
                ),
                ),

                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: priceController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');

                    },
                    decoration: InputDecoration(
                        labelText: 'Price',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                // Fourth Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Colors.green[100],
                          textColor: Colors.black,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            String title=titleController.text;
                            String author=authorController.text;
                            String edition=editionController.text;
                            String price=priceController.text;
                            String descprtion= typeController;

                            addNewBook(title,author,edition,price,descprtion,_uploadedFileURL);

                          },
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),

        ));
  }

  void moveToLastScreen() {

    Navigator.pop(context, true);
  }
  void navigateToDetail() async {
  

    Navigator.push(context, new MaterialPageRoute(builder: (ctxt) => new AdminBookList(
   key: widget.key,
      userId: widget.userId,
      auth: widget.auth,
      logoutCallback:widget.logoutCallback,

    )));
  }


  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    return true; // return true if the route to be popped
  }

  onEntryChanged(Event event) {
    var oldEntry = booklist.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      booklist[booklist.indexOf(oldEntry)] =
          book.fromSnapshot(event.snapshot);
    });

  }

  void onEntryAdded(Event event) {
    booklist.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      booklist.add(book.fromSnapshot(event.snapshot));
    });
  }
  void addNewBook(String title, String author, String edition, String price, String descprtion,String imageUrl) {
    if (title.length > 0 && author.length > 0 && edition.length > 0 &&
        price.length > 0 && descprtion.length > 0) {
      book b = new book(title, author, edition, price, descprtion, imageUrl);
      _database.reference().child("book").push().set(b.toJson());
      Fluttertoast.showToast(
          msg: "added Successfuly",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );

      navigateToDetail();
    }else{
      Fluttertoast.showToast(
          msg: "Please fill all fields",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
        Navigator.pop(context, true);
    } catch (e) {

    }
  }
   void _changed(bool visibility) {
    setState(() {
        visibilityObs = visibility;
      
    });
  }


}





