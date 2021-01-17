import 'package:firebase_database/firebase_database.dart';

class bookId {

  String key;
  String _TITLE;

  String _PRICE ;
  String _ImageURL;

  bookId(this._TITLE,  this._PRICE,this._ImageURL);
  bookId.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        _TITLE = snapshot.value["Title"],

        _PRICE = snapshot.value["Price"],

        _ImageURL=snapshot.value["Image"];


  toJson() {
    return {
      "Title":_TITLE,
      "Price":_PRICE ,
      "Image":_ImageURL,
    };

  }

 setKey(String keyvalue) {
   key=keyvalue;

    }

  String get KEYID=>key;

  set KEYID(String value) {
    key = value;
  }

  String get ImageURL => _ImageURL;

  set ImageURL(String value) {
    _ImageURL = value;
  }



  String get PRICE => _PRICE;

  set PRICE(String value) {
    _PRICE = value;
  }





  String get TITLE => _TITLE;

  set TITLE(String value) {
    _TITLE = value;
  }



}