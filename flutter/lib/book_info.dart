import 'package:flutter/material.dart';
import 'main.dart';
import 'add_book.dart';

//Creates a final variable for the max lines allowed for the description.
//TODO: Maybe set a final variable for the max lines allowed for the title...
final int descMaxLines = 3;

//Creates the Book Info class as a stateful widget
class BookInfo extends StatefulWidget{
  //Constructor with a require title, book, and addbook
  const BookInfo({super.key, required this.title,
  required this.book, required this.addBook});

  //Initializes the title, book and addbook
  //The book is what will be displayed, the addBook determines whether the add book button shows or not
  final String title;
  final Book book;
  final bool addBook;

  //Creates the book info state
  @override
  State<BookInfo> createState() => _BookInfoState();
}

//Initializes the book info state with the contents
class _BookInfoState extends State<BookInfo>{
  //Initializes a boolean to hide the description until the show more button is clicked
  bool _showDescription = false;

  @override
  Widget build(BuildContext context){
    //Sets the title and book to the title and book passed to the widget
    String title = widget.title;
    Book book = widget.book;

    //Sets the global variables of screenWidth and screenHeight to the media device's width and height
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      //Creates the generic appbar used through out with the same decoration and functionality
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

      //Creates the hamburg menu drawer
      drawer: Drawer(
        child: HamburgerMenu(title: title,),
      ),

      //Sets the background color to be the default page color
      backgroundColor: defaultPageColor,

      //This displays the book information from the book variable
      body: Center(
        //Creates a container variable to create a smaller window in the middle of the screen
        child: Container(
          //Sets the padding, width, height, and color of the smaller window
          padding: EdgeInsetsGeometry.all(15.0),
          width: screenWidth * .80,
          height: screenHeight * .80,
          color: Color(0xFFB08968),

          //Creates our stack. This is used to display widgets on top of each other
          child: Stack(
            children: [
              //First we create the column with the book info itself
              Column(
                //Centers the column
                crossAxisAlignment: CrossAxisAlignment.start,

                //This is what shows the book info
                children: [
                  //Shows the add book button if the add book bool is true
                  if (widget.addBook)
                    Center(
                      //Generic button with the light button style initialized in the main.dart file
                      child: ElevatedButton(
                        style: lightButtonStyle,

                        //If pressed, it will add the book to the list and navigate to the main page
                        onPressed: (){
                          addBookToList(book);

                          Navigator.pushNamed(context, '/');
                        },

                        //Add book text with the light button text styel global variable
                        child: Text(

                          "Add Book",
                          style: lightButtonTextStyle,
                        ),
                      ),
                    ),
                  //Book Title
                  Center(
                    //Creates a text widget that is centered and displays the book's title with the corresponding text style
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
                    //Shows the book's author with the corresponding text style
                    "By: ${book.getAuthor()}",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  //Book image
                  //TODO: Actually make this work correctly. This only works with network images and is really just a test. Figure a better system for images
                  if (book.getImage().isNotEmpty)
                    Image.network(book.getImage(), width: 100, height: 100),
                  //Book description and button.
                  LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints){
                        //Creates a text painter with the descritipn and text styling below
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

                        //Checks if the text exceeded the max lines allotted at the top of the page or not
                        if (textPainter.didExceedMaxLines){
                          //If so, display the description with an ellipsis overflow and a show more button
                          return Column(
                            children: [
                              //Description text
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
                              //Show more button with light button style and light button text style
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
                          //If it did not overflow, show the description in its entirety
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
                    //Aligns the text to the left and displays the book availability with the style below
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
                    //Aligns the reviews to the left and shows the review average with the text styling below
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

                  //Request book and leave review buttons
                  //Makes sure that the book has an owner
                  if (book.getOwner().isNotEmpty)
                    //Displays the request book and leave review buttons
                    Center(
                      //Centers and lays the buttons on top of each other
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Request Book Button with light button style and light button text style
                          ElevatedButton(
                            style: lightButtonStyle,
                            onPressed: (){

                            },
                            child: Text(
                              "Request Book",
                              style: lightButtonTextStyle,
                            ),
                          ),
                          //Leave Review Button with light button style and light button text style
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
              //TODO: We can probably remove this stack variable as it is not useful here
              Stack(
                alignment: Alignment.center,
                children: [

                  //Shows the full description on a scrollable text element if the user presses the show more button
                  if (_showDescription)
                    Column(
                      children: [
                        //This is the actual description on a sized box wiht a single child scroll view element
                        //This essentially allows the user to scroll the box to see the text
                        SizedBox(
                          height: screenHeight * .7,
                          width: screenWidth,
                          child: SingleChildScrollView(
                            //Dialog element for easy text showing with no corner rounding
                            child: Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.zero,
                              ),

                              //Actual book description text
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

                        //Show less button that will hide the description scrolling pane
                        ElevatedButton(
                          //Creates the show less button with the light button style and light button text styling
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
