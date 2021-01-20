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
hjhvdcyavvcdi
gjycc
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black26,
        body: SafeArea(
          child: Container(
            height: 60,
            width: 60,
            color: Colors.white,
            child: Text('hi everyone,'),
          ),
        ),
      ),
    );
  }
}
