import 'package:firebase_database/firebase_database.dart';

class book {


  String key;
  String _TITLE;
  String _AUTHOR;
  String _EDITION ;
  String _PRICE ;
  String _Descrption;
  String _ImageURL;



  book(this._TITLE, this._AUTHOR, this._EDITION, this._PRICE,this._Descrption,this._ImageURL);
  book.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        _TITLE = snapshot.value["Title"],
        _AUTHOR = snapshot.value["Author"],
        _EDITION = snapshot.value["Edition"],
        _PRICE = snapshot.value["Price"],
        _Descrption=snapshot.value["Type"],
        _ImageURL=snapshot.value["Image"];


  toJson() {
    return {
      "Title":_TITLE,
      "Author":_AUTHOR ,
      "Edition":_EDITION ,
      "Price":_PRICE ,
      "Type":_Descrption ,
      "Image":_ImageURL,
    };



  }



  String get KEYID=>key;

  set KEYID(String value) {
    key = value;
  }

  String get ImageURL => _ImageURL;

  set ImageURL(String value) {
    _ImageURL = value;
  }

  String get Descrption => _Descrption;

  set Descrption(String value) {
    _Descrption = value;
  }

  String get PRICE => _PRICE;

  set PRICE(String value) {
    _PRICE = value;
  }

  String get EDITION => _EDITION;

  set EDITION(String value) {
    _EDITION = value;
  }

  String get AUTHOR => _AUTHOR;

  set AUTHOR(String value) {
    _AUTHOR = value;
  }

  String get TITLE => _TITLE;

  set TITLE(String value) {
    _TITLE = value;
  }



}