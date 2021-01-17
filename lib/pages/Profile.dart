
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:myfirsttry/pages/ShoppingCart.dart';
import 'package:myfirsttry/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myfirsttry/Models/user.dart';
import 'package:myfirsttry/pages/Home_Page.dart';
import '../main.dart';
import 'ShoppingCart.dart';
import 'login_signup_page.dart';

class ProfilePage extends StatefulWidget {

  ProfilePage({ this.auth, this.userId, this.logoutCallback})
      : super();


  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  String appBarTitle="Profile";


  @override
  State<StatefulWidget> createState() => new ProfilePageState(this.appBarTitle);
}

class ProfilePageState extends State<ProfilePage> {

  ProfilePageState(this.appBarTitle);

  List<user> UserList = [];

  String appBarTitle="Profile";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int Key;
  int individualKey1;
  user bookData=new user("","");
  @override
  void initState() {
    super.initState();
    getuser();
  }
void getuser(){
  DatabaseReference bookRef = FirebaseDatabase.instance.reference().child(widget.userId);
  bookRef.once().then((DataSnapshot snap) {
    var Data = snap.value;
    bookData = new user(
      Data['name'],
      Data['email'],
    );
    setState(() {
      print('Length : $UserList.length');
      print('KeyList :${widget.userId}');

    });
  });
}
  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    var _willPopCallback;
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(

          appBar: AppBar(
            leading: new Container(),
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor:Colors.green[100],
              elevation: .5,
              title: Text('Profile',

                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
        
          ),

          body:
          Container(
                            
                              decoration: backgroundGradient(),
                              child: Stack(
                                children: <Widget>[
                          
                              
                                Padding(
                                  padding: EdgeInsets.fromLTRB(40, 0, 40, 30),
                                  child: Center(
                                    child: Container(
                                      width: 330,
                                      height: 400,

                                      decoration: BoxDecoration(

                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(color: Colors.green[100], spreadRadius: 3),
                                        ],
                                      ),
                                      child: Column(

                                      children: <Widget>[

                                         Padding(
                                        padding: EdgeInsets.fromLTRB(0,10,20,15),
                                         child: Image.asset(
                          "assests/profileimage.png",height: 100,
                      ),
                    ),

                  // // First  Element
                                  Padding(
                    padding: EdgeInsets.fromLTRB(10,10,20,15),
                    child: Text(" Name : ${bookData.Name}",
                      style: textStyle,
                          )
                      ),

                  Padding(
                      padding: EdgeInsets.fromLTRB(10,10,10,15),
                      child: Text(" Email : ${bookData.Email}   ",
                        style: textStyle,
                      )



                  ),



                ],
                    ),
                                    ),
                                  ),
                                ),

     

                                ]
                     
                                

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
         index:0 ,
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
                 
          ),

        );
  }
 

}


