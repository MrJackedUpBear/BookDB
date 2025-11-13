import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'book_info.dart';
import 'main.dart';

import 'package:http/http.dart' as http;

final String bookSearchAPI = "https://openlibrary.org/search.json?limit=10&lang=eng&";
final String bookInfoAPI = "https://openlibrary.org/isbn/";
final String bookCoverAPI = "https://covers.openlibrary.org/b/isbn/";
final String getExtraBookInfoAPI = "https://openlibrary.org/books/"; //Make sure to append .json to the end
final String getBookWorkInfoAPI = "https://openlibrary.org/works/"; //Make sure to append .json

final Map<String, String> userAgent =
{HttpHeaders.userAgentHeader:
'Personal Book DB/0.4 (Contact: jwtaylor771@proton.me)'};

//Will keep this on the client side to improve speed of searching
//books.
Future<http.Response> searchBooks(String query) async{
  return await http.get(
    Uri.parse(bookSearchAPI + query),
    headers: userAgent
  );
}

//Can be on the server side.
//TODO: Set this up on the server side API instead.
Future<http.Response> getBook(String isbn) async{
  return await http.get(
    Uri.parse("$bookInfoAPI$isbn.json"),
    headers: userAgent
  );
}

//Can be on the server side.
//TODO: Set this up on the server side API instead.
Future<http.Response> getBookCover(String isbn, String size) async{
  return await http.get(
    Uri.parse("$bookCoverAPI$isbn-$size.jpg"),
    headers: userAgent,
  );
}

Future<http.Response> getExtraBookInfo(String coverEdition) async {
  return await http.get(
    Uri.parse("$getExtraBookInfoAPI$coverEdition.json?lang=eng"),
    headers: userAgent,
  );
}

Future<http.Response> getWorkInfo(String work) async{
  return await http.get(
    Uri.parse("$getBookWorkInfoAPI$work.json"),
    headers: userAgent,
  );
}

void addBookToList(Book b){
  addBook(b);
}

class AddBook extends StatefulWidget{
  const AddBook({super.key, required this.title});

  final String title;

  @override
  State<AddBook> createState() => AddBookState();
}

class AddBookState extends State<AddBook>{
  Future<void> searchAndLoadBooks(BuildContext context) async {
    var authorSearchName = _authorName.text;
    var bookSearchTitle = _bookTitle.text;

    _authorName.text = "";
    _bookTitle.text = "";

    if (authorSearchName.isEmpty && bookSearchTitle.isEmpty){
      return;
    }

    var query = "";

    if (bookSearchTitle.isNotEmpty){
      query += "title=$bookSearchTitle";
    }

    if (authorSearchName.isNotEmpty){
      if (query.isNotEmpty){
        query += "&";
      }
      query += "author=$authorSearchName";
    }

    setState(() {
      _isLoading = true;
    });

    http.Response resp = await searchBooks(query);

    if (resp.statusCode != 200){
      return;
    }

    Map<String, dynamic> jsonBody = jsonDecode(resp.body);

    List<dynamic> json = jsonBody['docs'];
    
    if (json[0] == null){
      return;
    }

    foundBooks = await Book.getBooksFromJson(json);
  }

  Future<void> getBookFromISBN(BuildContext context) async {
    currentBook = Book();
    String isbn = _isbn.text;

    http.Response resp = await getBook(isbn);

    if (resp.statusCode != 200){
      return;
    }

    Map<String, dynamic> bookInfo = jsonDecode(resp.body);



    currentBook = await Book.getBookFromJson(bookInfo);
  }

  final TextEditingController _authorName = TextEditingController();
  final TextEditingController _bookTitle = TextEditingController();
  final TextEditingController _isbn = TextEditingController();

  bool _isLoading = false;

  List<Book> foundBooks = [];
  Book currentBook = Book();

  @override
  Widget build(BuildContext context){
    String title = widget.title;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    boxSpacing = MediaQuery.of(context).size.height * .05;


    return Scaffold(
      backgroundColor: defaultPageColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Builder(
          builder: (context){
            return Container(
              //Sets the color of the button and makes the button
              //round
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(10.0),
              ),
              //Sets the icon for the button to be the menu icon
              child: IconButton(
                icon: Icon(Icons.menu),
                //Opens the left-hand drawer if the button is
                //pressed
                onPressed: (){
                  Scaffold.of(context).openDrawer();
                },
              ),
            );
          },
        ),
        title: Center(
          //Gets the title set from the first method.
          child: Text(
              title,
              style:TextStyle(
                color: Color(0xFFE6CCB2),
                fontSize: 24
            ),
          ),
        ),
      ),

      drawer: Drawer(
        child: HamburgerMenu(title: title,),
      ),

      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: boxSpacing,),
            ElevatedButton(
              style: defaultButtonStyle,
              onPressed: (){
                Navigator.pushNamed(
                  context,
                  '/ScanBarcode'
                );
              },
              child: Text(
                "Don't Want to Enter Manually?\nScan Barcode",
                textAlign: TextAlign.center,
                style: defaultButtonTextStyle,
              )
            ),
            SizedBox(height: boxSpacing,),
            Container(
              color: Color(0xFFB08968),
              height: screenHeight * .6,
              width: screenWidth * .8,
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenHeight * .05,),
                  Text(
                    "Enter ISBN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: screenWidth * .6,
                        child: TextField(
                          controller: _isbn,
                          decoration: InputDecoration(
                            hint: Text(
                              //Sets the text and font size.
                              "ISBN...",
                              style: TextStyle(
                                fontSize: subHeadingFontSize,
                              ),
                            ),
                            //fills the text field with the color white, sets the borded to the specified color with the specified width.
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF9C6644),
                                width: 5.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFDDB892),
                          shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadiusGeometry.zero,
                          ),
                        ),
                        onPressed: () async{
                          await getBookFromISBN(context);

                          if (context.mounted && currentBook.getTitle().isNotEmpty){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookInfo(
                                  title: title,
                                  book: currentBook,
                                  addBook: true,
                                )
                              )
                            );
                          }
                        },
                        child: Text(
                          "Go!",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * .3,),
                  TextButton(
                    style: lightButtonStyle,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          if (!_isLoading){
                            return Container(
                              color: Color(0xFFB08968),
                              height: screenHeight * .5, // Adjust height as needed
                              child: Center(
                                child: Column(
                                  children: [
                                    //Author label and text field
                                    Text(
                                      "Enter Author",
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextField(
                                        controller: _authorName,
                                        style: TextStyle(
                                          fontSize: 30,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Author...",
                                          hintStyle: TextStyle(
                                            fontSize: 30,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF9C6644),
                                              width: 5.0,
                                            ),
                                          ),
                                        )
                                    ),
                                    SizedBox(height: boxSpacing,),

                                    //Title label and text field
                                    Text(
                                      "Enter Title",
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextField(
                                      controller: _bookTitle,
                                      style: TextStyle(
                                        fontSize: 30,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Title...",
                                        hintStyle: TextStyle(
                                          fontSize: 30,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFF9C6644),
                                            width: 5.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: boxSpacing,),

                                    //Search button
                                    ElevatedButton(
                                      onPressed: () async {
                                        await searchAndLoadBooks(context);

                                        if (context.mounted){
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => MyHomePage(
                                                    title: title,
                                                    books: foundBooks,
                                                  )
                                              )
                                          );
                                        }
                                      },
                                      child: Text(
                                        "Search",
                                        style: TextStyle(
                                          fontSize: 30,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }else{
                            return Container(
                              color: Color(0xFFB08968),
                              child: Center(
                                child: Text("Loading..."),
                              ),
                            );
                          }
                        },
                      );
                    },
                    child: Text(
                      "Don't Have the ISBN?",
                      style: lightButtonTextStyle,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}