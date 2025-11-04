import 'package:flutter/material.dart';
import 'main.dart';

class BookInfo extends StatefulWidget{
  const BookInfo({super.key, required this.title,
  required this.book});

  final String title;
  final Book book;

  @override
  State<BookInfo> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo>{
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
              const SizedBox(width: boxSpacing,),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: boxSpacing),
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
                ),
              ),
              const SizedBox(height: boxSpacing),
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
              const SizedBox(height: boxSpacing),
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
              const SizedBox(height: boxSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Request Book Button
                  ElevatedButton(
                    onPressed: (){

                    },
                    child: Text(
                      "Request Book"
                    ),
                  ),
                  //Leave Review Button
                  ElevatedButton(
                    onPressed: (){

                    },
                    child: Text(
                      "Leave Review"
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      )
    );
  }
}