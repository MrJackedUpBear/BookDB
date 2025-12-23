import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'Classes.dart';
import 'book_info.dart';
import 'main.dart';
import 'constants.dart';

import 'package:http/http.dart' as http;

//Initializes the book search, book info, book cover, extra book info, and book work info API URLs
final String bookSearchAPI = "https://openlibrary.org/search.json?limit=10&lang=eng&";
final String bookInfoAPI = "https://openlibrary.org/isbn/";
final String bookCoverAPI = "https://covers.openlibrary.org/b/isbn/";
final String getExtraBookInfoAPI = "https://openlibrary.org/books/"; //Make sure to append .json to the end
final String getBookWorkInfoAPI = "https://openlibrary.org/works/"; //Make sure to append .json

//Sets the userAgent map that is used in each API call.
final Map<String, String> userAgent =
{HttpHeaders.userAgentHeader:
'Personal Book DB/0.4 (Contact: jwtaylor771@proton.me)'};

//Will keep this on the client side to improve speed of searching
//books.
//This makes an API call and returns the response gotten from the API.
Future<http.Response> searchBooks(String query) async{
  return await http.get(
    Uri.parse(bookSearchAPI + query),
    headers: userAgent
  );
}

//Can be on the server side.
//TODO: Set this up on the server side API instead.
//This makes an API call and returns the response gotten from the API.
Future<http.Response> getBook(String isbn) async{
  return await http.get(
    Uri.parse("$bookInfoAPI$isbn.json"),
    headers: userAgent
  );
}

//Can be on the server side.
//TODO: Set this up on the server side API instead.
//This makes an API call and returns the response gotten from the API.
Future<http.Response> getBookCover(String isbn, String size) async{
  return await http.get(
    Uri.parse("$bookCoverAPI$isbn-$size.jpg"),
    headers: userAgent,
  );
}

//This makes an API call and returns the response gotten from the API.
Future<http.Response> getExtraBookInfo(String coverEdition) async {
  return await http.get(
    Uri.parse("$getExtraBookInfoAPI$coverEdition.json?lang=eng"),
    headers: userAgent,
  );
}

//This makes an API call and returns the response gotten from the API.
Future<http.Response> getWorkInfo(String work) async{
  return await http.get(
    Uri.parse("$getBookWorkInfoAPI$work.json"),
    headers: userAgent,
  );
}

//Adds the book to the list
void addBookToList(Book b){
  addBook(b);
}

//Creates the add book class widget
class AddBook extends StatefulWidget{
  const AddBook({super.key, required this.title});

  //Title for the page
  final String title;

  //Creates the state for the add book page
  @override
  State<AddBook> createState() => AddBookState();
}

//Add book state 
class AddBookState extends State<AddBook>{
  //Function that searches for books and then loads them into a list
  Future<void> searchAndLoadBooks(BuildContext context) async {
    //Sets the author name and book title to the text controller values inputted by the user
    var authorSearchName = _authorName.text;
    var bookSearchTitle = _bookTitle.text;

    //Resets the text controllers
    _authorName.text = "";
    _bookTitle.text = "";

    //If both inputs are empty, then don't complete the request
    if (authorSearchName.isEmpty && bookSearchTitle.isEmpty){
      return;
    }

    //Initializes the query string
    var query = "";

    //Adds title to the query if the title is not empty
    if (bookSearchTitle.isNotEmpty){
      query += "title=$bookSearchTitle";
    }

    //Adds the author name if the author name is not empty
    if (authorSearchName.isNotEmpty){
      if (query.isNotEmpty){
        query += "&";
      }
      query += "author=$authorSearchName";
    }

    //Sets the loading state (still a work in progress...)
    setState(() {
      _isLoading = true;
    });

    //Makes an API call to search for the books.
    http.Response resp = await searchBooks(query);

    //If it is not a okay response, return
    if (resp.statusCode != 200){
      return;
    }

    //Decodes the json and stores it in the json body variable
    Map<String, dynamic> jsonBody = jsonDecode(resp.body);

    //Gets a json list by searching for the docs in the json body. This comes from the API documentation
    List<dynamic> json = jsonBody['docs'];
    
    //If there is nothing in the list, return
    if (json[0] == null){
      return;
    }

    //Sets the list of books to the function that gets books from a json object
    foundBooks = await Book.getBooksFromJson(json);
  }

  //Searches for an isbn and sets the current book to the book gotten from the isbn
  Future<void> getBookFromISBN(BuildContext context) async {
    //Initializes the current book to a new book
    currentBook = Book();

    //Sets the isbn string to the text controllers value
    String isbn = _isbn.text;

    //Sends the api request to get the book info
    http.Response resp = await getBook(isbn);

    //If it is a bad response code, just return
    if (resp.statusCode != 200){
      return;
    }

    //Creates a bookinfo map from the response body
    Map<String, dynamic> bookInfo = jsonDecode(resp.body);

    //Sets the current book to the value returned from the get book from json function
    currentBook = await Book.getBookFromJson(bookInfo);
  }

  //Initializes the author, boot title, and isbn text editing controllers.
  final TextEditingController _authorName = TextEditingController();
  final TextEditingController _bookTitle = TextEditingController();
  final TextEditingController _isbn = TextEditingController();

  //Initializes an is loading boolean that will be used later. Still needs some work
  bool _isLoading = false;

  //Initializes the foundBooks list and current book for future use
  List<Book> foundBooks = [];
  Book currentBook = Book();

  //Creates the builder widget
  @override
  Widget build(BuildContext context){
    //Sets the title to the title passed through this widget
    String title = widget.title;

    //Initializes the screen width and screenheight
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    //Sets the box spacing values
    boxSpacing = MediaQuery.of(context).size.height * .05;

    //Returns the main scaffold of the widget
    return Scaffold(
      //Sets the background color to the default page color
      backgroundColor: defaultPageColor,

      //Creates the appbar at the top of the page
      appBar: AppBar(
        //Sets the background color to be the primary color passed with the context
        backgroundColor: Theme.of(context).colorScheme.primary,

        //Sets the leading widget for the hamburger menu
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

      //Sets the drawer that opens to be the hamburger menu
      drawer: Drawer(
        child: HamburgerMenu(title: title,),
      ),

      //This centers the main body line for adding books
      body: Center(
        //Arranges the widgets in a column
        child: Column(
          children: <Widget>[
            //Puts spacing between the top and the next element
            SizedBox(height: boxSpacing,),

            //Creates a button for navigating to the scan barcode page
            ElevatedButton(
              //Sets the button style to the default button style
              style: defaultButtonStyle,

              //Navigates to the scan barcode page on button press
              onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/ScanBarcode',
                      (Route<dynamic> route) => false,
                );
              },

              //Sets the text, text style, and centers the words
              child: Text(
                "Don't Want to Enter Manually?\nScan Barcode",
                textAlign: TextAlign.center,
                style: defaultButtonTextStyle,
              )
            ),

            //Adds spacing between the above element and the next element
            SizedBox(height: boxSpacing,),

            //Main container containing the book search menu
            Container(
              //Sets the color of the container
              //TODO: Change this color to some constant value.
              color: Color(0xFFB08968),

              //Sets the height and width to 60% of the screen height and 80% of the screen width
              height: screenHeight * .6,
              width: screenWidth * .8,

              //Adds the child for the container to contain a column with the form info
              child: Column(
                children: <Widget>[
                  //Adds spacing from the top to the next element
                  SizedBox(height: screenHeight * .05,),

                  //Adds the ISBN text info with the text style specified
                  //TODO: Set the text style to be some constant value
                  Text(
                    "Enter ISBN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  //Adds a row widget that will display the isbn textbox and submit button next to each other
                  Row(
                    children: <Widget>[
                      //ISBN text box with the size being controlled by the sized box
                      SizedBox(
                        //Sets the width to be 60% of the screen width
                        width: screenWidth * .6,

                        //Sets the child to be the text field with the _isbn controller
                        child: TextField(
                          controller: _isbn,

                          //Sets the input decoration for the text field with the ISBN hint and the sub heading font size
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

                      //Submit button
                      TextButton(
                        //Sets the text button style
                        //TODO: Set the style of the text button to be a constant value
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFDDB892),
                          shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadiusGeometry.zero,
                          ),
                        ),

                        //If the button is pressed, go get the book with the isbn entered
                        onPressed: () async{
                          await getBookFromISBN(context);

                          //Makes sure the page is loaded and we were able to load a book
                          if (context.mounted && currentBook.getTitle().isNotEmpty){
                            //Navigate to the book info page with the book loaded
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => BookInfo(
                                    title: "",
                                    book: currentBook,
                                    addBook: true,
                                  )
                              ),
                                  (Route<dynamic> route) => false,
                            );
                          }
                        },
                        
                        //Sets the text and text style
                        //TODO: Set the text style to some constant variable instead
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

                  //Adds spacing between the element above and the element below
                  SizedBox(height: screenHeight * .3,),

                  //Initializes a TextButton that will open the form for searching for a book with the book title and/or author
                  TextButton(
                    //Sets the style to be the light button style
                    style: lightButtonStyle,

                    //When the button is pressed, we load the form for searching for a book
                    onPressed: () {
                      //This is like a drawer from the bottom page that shows the book search form
                      showModalBottomSheet(
                        //Sets the context to the current context
                        context: context,

                        //Creates a builder with context
                        builder: (BuildContext context) {
                          //TODO: Fix the _isLoading functionality as it does not work properly
                          if (!_isLoading){
                            //Returns the main container showing the author and book title text fields to enter
                            return Container(
                              //Sets the color to the hexadecimal value
                              //TODO: Make this color a constant value
                              color: Color(0xFFB08968),

                              //Sets the height of the container to be 50% of the screen height
                              height: screenHeight * .5,

                              //Centers a column containing the form
                              child: Center(
                                child: Column(
                                  children: [
                                    //Author label and text field
                                    //Text value with text and text style
                                    //TODO: Constants
                                    Text(
                                      "Enter Author",
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                      ),
                                    ),

                                    //Author text field to handle user input
                                    TextField(
                                        //Sets the controller to the _authorName controller
                                        controller: _authorName,

                                        //Sets the text style 
                                        //TODO: Constants
                                        style: TextStyle(
                                          fontSize: 30,
                                        ),
                                        
                                        //Sets the decoration of the text field 
                                        //TODO: Constants
                                        decoration: InputDecoration(
                                          //Sets the hint text
                                          hintText: "Author...",

                                          //Sets the style of the hint text
                                          hintStyle: TextStyle(
                                            fontSize: 30,
                                          ),

                                          //Fills the text input with white
                                          filled: true,
                                          fillColor: Colors.white,

                                          //Sets a border with the color and width defined below
                                          //TODO: Constants
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF9C6644),
                                              width: 5.0,
                                            ),
                                          ),
                                        )
                                    ),

                                    //Adds spacing between the author input and the book title input
                                    SizedBox(height: boxSpacing,),

                                    //Title label and text field
                                    //Title label with text styling
                                    //TODO: Constants
                                    Text(
                                      "Enter Title",
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                      ),
                                    ),

                                    //The text field input for the book title
                                    TextField(
                                      //Sets the controller to the _bookTitle controller
                                      controller: _bookTitle,

                                      //Sets the text style
                                      //TODO: Constants
                                      style: TextStyle(
                                        fontSize: 30,
                                      ),

                                      //Sets the decoration of the input
                                      decoration: InputDecoration(
                                        //Sets the hint text and style
                                        //TODO: Constants
                                        hintText: "Title...",
                                        hintStyle: TextStyle(
                                          fontSize: 30,
                                        ),

                                        //Fills the text field with white
                                        filled: true,
                                        fillColor: Colors.white,

                                        //Sets the border to the color specified below with the specified width
                                        //TODO: Constants
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFF9C6644),
                                            width: 5.0,
                                          ),
                                        ),
                                      ),
                                    ),

                                    //Adds Spacing between the book title and the button
                                    SizedBox(height: boxSpacing,),

                                    //Search button
                                    ElevatedButton(
                                      //On pressed, search for the books and then load them
                                      onPressed: () async {
                                        await searchAndLoadBooks(context);

                                        //Makes sure the page is loaded
                                        if (context.mounted){
                                          //Pops out of the bottom drawer menu 
                                          Navigator.pop(context);

                                          //Loads the main page with the list of books found and the title
                                          Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) => MyHomePage(
                                                  title: title,
                                                  books: foundBooks,
                                                )
                                            ),
                                                (Route<dynamic> route) => false,
                                          );
                                        }
                                      },

                                      //Sets the button text and style
                                      //TODO: Constants
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

                    //Sets the text and the button style
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