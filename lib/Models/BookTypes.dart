class BookType {
  int id;
  String name;
 
  BookType(this.id, this.name);
 
  static List<BookType> getbooktype() {
    return <BookType>[
      BookType(1, 'Computer And Technology'),
      BookType(2, 'Self Devlopment'),
      BookType(3, 'Chlidren Books'),
      BookType(4, 'Cookery'),
      BookType(5, 'Learning Languges'),
    ];
  }
}


   List<String> ChildKeyList = [];
   List<String> DevlopmentKeyList = [];
   List<String> ComputerKeyList = [];
   List<String> CookeryKeyList = [];
   List<String> LangugesKeyList = [];