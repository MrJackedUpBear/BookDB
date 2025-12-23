import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';

import 'Classes.dart';
import 'add_book.dart';
import 'book_info.dart';
import 'main.dart';
import 'constants.dart';

//Initializes the mobile scanner object (This scans for barcodes with the camera)
late MobileScannerController barcodeScanner;

//Creates the scan barcode class widget
class ScanBarcode extends StatefulWidget{
  const ScanBarcode({super.key, required this.title});

  //Title of the screen
  final String title;

  //Sets the state of the scanbarcode widget
  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

//Defines the state for the scanbarcode class
class _ScanBarcodeState extends State<ScanBarcode>{
  //Load book function that takes the context and a list of barcodes to load the specific book
  void _loadBook(BuildContext context, List<Barcode> barcodes) async{
    //Initializes the isbn string 
    String isbn = "";

    //Simple try-catch block that tries to set the isbn string to the first barcodes value. 
    //If it cannot successfully set the string, it will return.
    try{
      isbn = barcodes[0].rawValue!;
    }catch(_){
      return;
    }

    //Calls the getBook api call from add_book.dart and stores the response as a http response variable resp
    http.Response resp = await getBook(isbn);

    //Checks if the status code is not okay. If it isn't just return (failed API call).
    if (resp.statusCode != 200){
      return;
    }

    //Creates a dynamic, string map that holds the bookinfo from the response body
    Map<String, dynamic> bookInfo = jsonDecode(resp.body);

    //Sets the current book by getting the book from the json response we got. This sends the call to the main.dart file to get the book 
    //in the book class
    currentBook = await Book.getBookFromJson(bookInfo);
  }

  //Initializes the current book to a new book
  Book currentBook = Book();

  //Creates the widget
  @override
  Widget build(BuildContext context){

    //Sets the title to the title passed
    String title = widget.title;

    //Sets the screen height and width to the height and width of the screen
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    //Sets the boxSpacing variable to 5% of the screen height
    boxSpacing = MediaQuery.of(context).size.height * .05;

    //The main scaffolding of the widget
    return Scaffold(
      //Sets the background color to the default page color constant
      backgroundColor: defaultPageColor,

      //Creates the appbar with the barcode scanning functionality
      appBar: AppBar(
        //Sets the background color to the primary color from the theme
        backgroundColor: Theme.of(context).colorScheme.primary,

        //The leading area of the appbar adds the hamburger menu button
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

        //Sets the title in the senter with the color and font size
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

      //Creates a drawer the contains the hamburger menu created in main.dart
      drawer: Drawer(
        child: HamburgerMenu(title: title,),
      ),

      //Creates the body in the center of the page
      body: Center(
        child: Center(
          child: Column(
            //Makes sure the widget is centered
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //General text to help the user.
              Text(
                "Position Barcode Within Frame",
                //Aligns the text to the center and sets the font size and weight
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: subHeadingFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //Sized box for spacing
              SizedBox(height: boxSpacing,),
              
              //Stacks the barcode scanner and the overlay on top of each other
              Stack(
                //Centers the stack
                alignment: Alignment.center,

                children: [
                  //Container with the barcode scanner
                  Container(
                    //Sets the height and width of the container to be 60% of the screen height and 80% of the screen width
                    height: screenHeight * .6,
                    width: screenWidth * .8,
                    
                    //Centers the alignment
                    alignment: Alignment.center,

                    //Adds padding around the outside of the camera
                    padding: const EdgeInsets.all(20.0),

                    //Creates a white border around the camera
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 10.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    //Actually adds the mobile scanner widget to the container
                    child: MobileScanner(
                      //Sets the size of the scan window to be center with 80% of the screen width and 60% of the screen height
                      scanWindow: Rect.fromCenter(
                        center: Offset.zero,
                        width: screenWidth * .8,
                        height: screenHeight * .6,
                      ),

                      //Allows tap to focus
                      tapToFocus: true,

                      //Sets the controller to be the barcode scanner controller initialized above
                      controller: barcodeScanner,

                      //If a barcode is detected, this is called
                      onDetect: (result) async{
                        //Checks to make sure it is not empty. If it is, then return
                        if (result.barcodes.isEmpty){
                          return;
                        }

                        //Tries to load the current book with the barcode gotten
                        _loadBook(context, result.barcodes);

                        //Checks to make sure everything is loaded and the _loadBook function actually got a book
                        if (context.mounted && currentBook.getTitle().isNotEmpty){
                          //Navigates to the book info page with the current book loaded from the barcode
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
                          //Stops the barcode scanner after loading the new page.
                          barcodeScanner.stop();
                        }
                      },
                    ),
                  ),

                  //Container with the box overlay
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 10.0,

                      )
                    ),
                    width: screenWidth * .5,
                    height: screenHeight * .1,
                  ),
                ],
              ),
              
              //Adds box spacing
              SizedBox(height: boxSpacing,),

              //Adds a button to navigate to the add book page if the user does not have the book on hand
              ElevatedButton(
                style: defaultButtonStyle,
                onPressed: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/AddBook',
                      (Route<dynamic> route) => false,
                  );
                },
                child: Text(
                  "Don't Have the Book?\nEnter Manually",
                  style: defaultButtonTextStyle,
                ),
              )
            ],
          )
        ),
      ),
    );
  }

  //Initial state initializes the barcodeScanner
  @override
  void initState() {
    barcodeScanner = MobileScannerController();
    super.initState();
  }

  //Dispose state makes sure to stop and dispose of the barcode scanner object
  @override
  void dispose(){
    barcodeScanner.stop();
    barcodeScanner.dispose();
    super.dispose();
  }
}