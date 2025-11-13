import 'package:flutter/material.dart';
import 'main.dart';
import 'add_book.dart';

final int descMaxLines = 3;

class BookInfo extends StatefulWidget{
  const BookInfo({super.key, required this.title,
  required this.book, required this.addBook});

  final String title;
  final Book book;
  final bool addBook;

  @override
  State<BookInfo> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo>{
  bool _showDescription = false;

  @override
  Widget build(BuildContext context){
    String title = widget.title;
    Book book = widget.book;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
          child: Row(
            children: [
              Container(
                //Sets the color of the button and makes the button
                //round
                decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                //Sets the icon for the button to be the menu icon
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  //Opens the left-hand drawer if the button is
                  //pressed
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(width: boxSpacing,),
              Text(title,
                style:TextStyle(
                    color: Color(0xFFE6CCB2),
                    fontSize: 24
                ),
              ),
            ],
          ),
        ),

      ),

      drawer: Drawer(
        child: HamburgerMenu(title: title,),
      ),

      backgroundColor: defaultPageColor,
      body: Center(
        child: Container(
          padding: EdgeInsetsGeometry.all(15.0),
          width: screenWidth * .80,
          height: screenHeight * .80,

          color: Color(0xFFB08968),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.addBook)
                    Center(
                      child: ElevatedButton(
                        style: lightButtonStyle,
                        onPressed: (){
                          addBookToList(book);

                          Navigator.pushNamed(context, '/');
                        },
                        child: Text(

                          "Add Book",
                          style: lightButtonTextStyle,
                        ),
                      ),
                    ),
                  //Book Title
                  Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      book.getTitle(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  //Book author
                  Text(
                    "By: ${book.getAuthor()}",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  //Book image
                  if (book.getImage().isNotEmpty)
                    Image.network(book.getImage(), width: 100, height: 100),
                  //Book description and button.
                  LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints){
                        final TextPainter textPainter = TextPainter(
                          text: TextSpan(
                            text: "Description: \n${book.getDescription()}",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 25,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(3.0, 3.0),
                                ),
                              ],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          maxLines: descMaxLines,
                          textDirection: TextDirection.ltr,

                        )..layout(maxWidth: constraints.maxWidth);

                        if (textPainter.didExceedMaxLines){
                          return Column(
                            children: [
                              Text(
                                "Description: \n${book.getDescription()}",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 25,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      offset: Offset(3.0, 3.0),
                                    ),
                                  ],
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: descMaxLines,
                              ),
                              ElevatedButton(
                                style: lightButtonStyle,
                                onPressed: (){
                                  setState(() {
                                    _showDescription = true;
                                  });
                                },
                                child: Text(
                                  "Show more...",
                                  style: lightButtonTextStyle,
                                ),
                              ),
                            ],
                          );
                        }else{
                          return Text(
                            "Description: \n${book.getDescription()}",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 25,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(3.0, 3.0),
                                ),
                              ],
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: descMaxLines,
                          );
                        }
                      }
                  ),

                  //Availability
                  Text(
                    textAlign: TextAlign.left,
                    "Availability: ${book.getAvailability()}",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(3.0, 3.0),
                        ),
                      ],
                    ),
                  ),
                  //Reviews
                  Text(
                    textAlign: TextAlign.left,
                    "Reviews: ${book.getReviewAverage()} / 10.0",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(3.0, 3.0),
                        ),
                      ],
                    ),
                  ),

                  if (book.getOwner().isNotEmpty)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Request Book Button
                          ElevatedButton(
                            style: lightButtonStyle,
                            onPressed: (){

                            },
                            child: Text(
                              "Request Book",
                              style: lightButtonTextStyle,
                            ),
                          ),
                          //Leave Review Button
                          ElevatedButton(
                            style: lightButtonStyle,
                            onPressed: (){

                            },
                            child: Text(
                              "Leave Review",
                              style: lightButtonTextStyle,
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),

              //Book description show more...
              Stack(
                alignment: Alignment.center,
                children: [

                  if (_showDescription)
                    Column(
                      children: [
                        SizedBox(
                          height: screenHeight * .7,
                          width: screenWidth,
                          child: SingleChildScrollView(
                            child: Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.zero,
                              ),
                              child: Text(
                                book.getDescription(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: lightButtonStyle,
                          onPressed: (){
                            setState(() {
                              _showDescription = false;
                            });
                          },
                          child: Text(
                            "Show less...",
                            style: lightButtonTextStyle,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        )
      )
    );
  }
}