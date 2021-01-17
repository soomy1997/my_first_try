import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfirsttry/pages/ShoppingCart.dart';
import 'package:myfirsttry/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myfirsttry/creditCard/flutter_credit_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:myfirsttry/creditCard/credit_card_form.dart';
import 'package:myfirsttry/creditCard/credit_card_model.dart';

class Payment extends StatefulWidget {

  Payment({ Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);


  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  bool isPressedd=false;
  String method;




  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  List<Orders> orders = List();
  Orders order;
  DatabaseReference ref;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  var isPressed;
  String city;
  String street;
  String houseNo;
  String neighborhood;
  String PhoneNumber;
  String total="0.00";
  String Orderid;


  StreamSubscription<Event> _onbookAddedSubscription;
  StreamSubscription<Event> _onbookChangedSubscription;

  void getprice() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    total=prefs.getString("Price");
    Orderid=prefs.getString("OrderID");

    setState(() {

    });

  }

  @override
  void initState() {
    super.initState();
    getprice();

    order = Orders(
        "",
        "",
        "",
        "",
        "");
    ref = _database.reference().child(widget.userId);

    Query OrderQ = _database
        .reference()
        .child(widget.userId)
        .orderByChild("orders")
        .equalTo(widget.userId);

    _onbookAddedSubscription = OrderQ.onChildAdded.listen(onEntryAdded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(

          leading: new Container(),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor:Colors.green[100],
          elevation: .5,
          title: Text('Checkout',

            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,

        ),

      resizeToAvoidBottomInset: true,
      body: new LayoutBuilder(
        builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
              BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: Column(
                  children:<Widget> [
                    CreditCardWidget(
                        cardNumber: cardNumber,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDate,
                        cvvCode: cvvCode,
                        showBackView: isCvvFocused,
                        height:200,
                        width: MediaQuery.of(context).size.width,
                        animationDuration:Duration(microseconds: 1000 )

                    ),
                    Text(
                      "Proceed to pay with credit Card",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      "Total:",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      "${total} SR",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),

                    ),




                    Container(

                      child: CreditCardForm(
                        onCreditCardModelChange: onCreditCardModelChange,

                      ),
                    ),



                    SizedBox(width: 10.0 ),

                    Container(
                      padding: const EdgeInsets.all(18.0),
                      child:  Center(
                        child: Column(

                          children: <Widget>[
                            Container(
                              child: new TextField(
                                decoration: new InputDecoration(
                                    hintText: "Street"

                                ),
                                onChanged: (String st){
                                  setState(() {
                                    street=st;
                                  });
                                },
                              ),
                            ),
                            Container(child: new TextField(
                                decoration: new InputDecoration(
                                    hintText: "neighborhood"

                                ),
                                onChanged: (String nb) {
                                  setState(() {
                                    neighborhood = nb;
                                  });
                                }
                            ),
                            ),
                            Container(child: new TextField(
                                decoration: new InputDecoration(
                                    hintText: "house number"

                                ),
                                onChanged: (String h) {
                                  setState(() {
                                    houseNo = h;
                                  });
                                }
                            ),
                            ),
                            Container(child: new TextField(
                                decoration: new InputDecoration(
                                    hintText: "City"

                                ),
                                onChanged: (String c) {
                                  setState(() {
                                    city = c;
                                  });
                                }
                            ),
                            ),
                            Container(child: new TextField(
                                keyboardType: TextInputType.number,
                                decoration: new InputDecoration(
                                  hintText: "Phone number",
                                ),
                                onChanged: (String pn) {
                                  setState(() {
                                    PhoneNumber = pn;
                                  });
                                }
                            ),
                            ),

                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: 200.0,
                      height: 70.0,

                      margin: const EdgeInsets.all(10.0),
                      child : new RaisedButton(
                        color: Colors.indigo,
                        child: Text(
                          ' Confirm Purchase',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed:  () {
                          addNewTodo(street, neighborhood, city, PhoneNumber,
                              houseNo);
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),

                      ),
                    )

                    // remaining stuffs
                  ]
              ),
            ),
          );
        },
      )
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;

      expiryDate = creditCardModel.expiryDate;

      cardHolderName = creditCardModel.cardHolderName;

      cvvCode = creditCardModel.cvvCode;

      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }



  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(

      title: Text(title),

      content: Text(message),

    );

    showDialog(

        context: context,

        builder: (_) => alertDialog

    );
  }

  void purchase() {


  }

  void onEntryAdded(Event event) {
    orders.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      orders.add(Orders.fromsnapshot(event.snapshot));
    });
  }

  void addNewTodo(String street, String neigb, String city, String phonenumber,
      String house) async{
    if (street.length > 0 && neigb.length > 0 && city.length > 0 &&
        phonenumber.length > 0 && house.length > 0  ) {
      Orders b = new Orders(street, neigb, city, phonenumber, house);
      _database.reference().child(widget.userId).child("orders").child(Orderid).push().set(b.tojson());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("OrderID", null);
  Fluttertoast.showToast(
          msg: "Your Order is complete",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
     Navigator.push(context, new MaterialPageRoute(builder: (ctxt) => new ShoppingCart(
   userId:widget.userId,
     auth:widget.auth,
     logoutCallback: widget.logoutCallback,
    )));

    }
  }

}

class Orders{
  String key;
  String city;
  String street;
  String houseNo;
  String neighborhood;
  String PhoneNumber;




  Orders( this.PhoneNumber,this.city,this.neighborhood,this.street,this.houseNo);
  Orders.fromsnapshot(DataSnapshot snapshot)
      :  key = snapshot.key,
        city=snapshot.value["city"],
        street=snapshot.value["street"],
        houseNo=snapshot.value["HouseNo"],
        neighborhood=snapshot.value["neighborhood"],
        PhoneNumber=snapshot.value["PhoneNumber"];




  tojson()
  {
    return {
      "city": city,
      "street": street,
      "HouseNo":houseNo,
      "neighborhood":neighborhood,
      "PhoneNumber":PhoneNumber,


    };

  }



}


