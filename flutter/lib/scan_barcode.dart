import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';

import 'add_book.dart';
import 'book_info.dart';
import 'main.dart';
import 'constants.dart';

late MobileScannerController barcodeScanner;

class ScanBarcode extends StatefulWidget{
  const ScanBarcode({super.key, required this.title});

  final String title;

  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode>{
  void _loadBook(BuildContext context, List<Barcode> barcodes) async{
    String isbn = "";

    try{
      isbn = barcodes[0].rawValue!;
    }catch(_){
      isbn = "";
    }

    if (isbn.isEmpty){
      return;
    }

    http.Response resp = await getBook(isbn);

    if (resp.statusCode != 200){
      return;
    }

    Map<String, dynamic> bookInfo = jsonDecode(resp.body);

    currentBook = await Book.getBookFromJson(bookInfo);
  }

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Position Barcode Within Frame",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: subHeadingFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: boxSpacing,),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: screenHeight * .6,
                    width: screenWidth * .8,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 10.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: MobileScanner(
                      scanWindow: Rect.fromCenter(
                        center: Offset.zero,
                        width: screenWidth * .8,
                        height: screenHeight * .6,
                      ),
                      tapToFocus: true,
                      controller: barcodeScanner,
                      onDetect: (result) async{
                        if (result.barcodes.isEmpty){
                          return;
                        }
                        _loadBook(context, result.barcodes);

                        if (context.mounted && currentBook.getTitle().isNotEmpty){
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
                          barcodeScanner.stop();
                        }
                      },
                    ),
                  ),
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
              SizedBox(height: boxSpacing,),
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

  @override
  void initState() {
    barcodeScanner = MobileScannerController();
    super.initState();
  }

  @override
  void dispose(){
    barcodeScanner.stop();
    barcodeScanner.dispose();
    super.dispose();
  }
}