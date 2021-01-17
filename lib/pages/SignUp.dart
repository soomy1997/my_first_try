import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirsttry/services/authentication.dart';
import 'package:myfirsttry/pages/SignUp.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myfirsttry/pages/AdminBookList.dart';

import '../main.dart';
import 'login_signup_page.dart';
class SignupPage extends StatefulWidget {
  SignupPage({this.auth,this.loginCallback});
  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<SignupPage> {
  final _formKey = new GlobalKey<FormState>();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String _email;
  String _password;
  String _Username;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";

        firebaseAuth
            .createUserWithEmailAndPassword(
            email: _email, password:_password)
            .then((result) {
          _database.reference().child(result.user.uid).set({
            "email": _email,
            "name": _Username
          }).then((res) {
              Navigator.push(context, new MaterialPageRoute(builder: (ctxt) => new MyApp()),
            );
          });
        }).catchError((err) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text(err.message),
                  actions: [
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        });
      }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          leading: Container(),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor:Colors.green[100],
          elevation: .5,
          title: Text('Book Store App',

            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }


  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showNameInput(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: Image.asset('assests/Logo.png'
          ,
            height: 200,
          ),
        ),

    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }
  Widget showNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Full Name',
            icon: new Icon(
              Icons.perm_identity,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Full Name can\'t be empty' : null,
        onSaved: (value) => _Username = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            'Have an account' ,
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed:(){
          getAccess();
        } );
  }
  void getAccess(){
    Navigator.push(context, new MaterialPageRoute(builder: (ctxt) => new LoginSignupPage(
      auth: widget.auth,
      loginCallback:widget.loginCallback,
    )));
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(40.0, 45.0, 40.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.green[100],
            child: new Text( 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.black)),
            onPressed: validateAndSubmit,

                    ),
        ));
  }
}