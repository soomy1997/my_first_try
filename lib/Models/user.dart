import 'package:firebase_database/firebase_database.dart';

class user {

String key;
  String _Name;
  String _Email;


  user(this._Name, this._Email);
  user.fromSnapshot(DataSnapshot snapshot) :

        _Name = snapshot.value["name"],
        _Email = snapshot.value["email"];



  toJson() {
    return {
      "name":_Name,
      "email":_Email ,

    };
  }

  String get Email => _Email;

  set Email(String value) {
    _Email = value;
  }

  String get Name => _Name;

  set Name(String value) {
    _Name = value;
  }


}