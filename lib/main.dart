import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:myfirsttry/services/authentication.dart';
import 'package:myfirsttry/pages/root_page.dart';

void main() {
  runApp(
    Phoenix(
      child: new MyApp(),
    ),
  );
}
gvghvj
hhhh
hvvcDVUCUKQW
HCXDVWHGCDWGHV XCDG
dchvhjsvxgcghcSGCHSG
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter log in demo',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth()));
  }
}