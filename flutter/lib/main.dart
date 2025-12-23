import 'dart:convert';

import 'package:book_db/setting.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Classes.dart';
import 'book_info.dart';
import 'add_book.dart';
import 'scan_barcode.dart';
import 'constants.dart';

//Initializes the screen width and screen height variables that will be used later...
double screenWidth = 0.0;
double screenHeight = 0.0;

//Creates a default buttons style for easy button styling
final defaultButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(Color(0xFF9C6644)),
    shape: WidgetStateProperty.all<BeveledRectangleBorder>(
      BeveledRectangleBorder(
        borderRadius: BorderRadiusGeometry.all(Radius.circular(5.0)
        ),
      ),
    ),
    maximumSize: WidgetStateProperty.all<Size>(
    Size(
        screenWidth *.8, screenHeight*.2
    ),
  )
);

//Creates a default button text style for easy button text styling
final defaultButtonTextStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

//Creates a light button style for lighter colored buttons
final lightButtonStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.all<Color>(
    Color(0xFFDDB892)
  ),
  shape: WidgetStateProperty.all<BeveledRectangleBorder>(
      BeveledRectangleBorder(
      borderRadius: BorderRadiusGeometry.zero,
    ),
  )
);

//Creates a light button text style for lighter colored buttons
final lightButtonTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

//Creates a user variable to test out the
//TODO: change this to only include the user gotten from an API call to the local database.
User user = User("Bob");

//Initializes an empty temp books list that will be used until we set up API calls.
//TODO: change this to only include books gotten from an API call to the local database.
List<Book> tempBooks = [
  ];

//generates a temporary list of books for testing
//Book("Super long title that probably won't fit on the thingamabob", "", "", "", "Unavailable", "", "Jo"),
//   Book("Harry Potter and the Sorcerer's Stone", "Fantasy", "J. K. Rowling", "This is a harry potter book.", "Available", "", "Jim"),
//   Book("Harry Potter and the Prisoner of Azkaban", "Fantasy", "J. K. Rowling", "", "", "", "Bob"),
//   Book("Title3", "", "a", "", "", "", "Jo"),
//   Book("Title4", "", "b", "", "", "", "Jim"),
//   Book("Title5", "Horror", "c", "", "", "", "Bob"),
//   Book("Title6", "", "d", "", "", "", "Jo"),
//   Book("Title7", "", "e", "", "", "", "Jim"),
//   Book("Title8", "Thriller", "f", "", "", "", "Bob"),
//   Book("Title9", "", "", "g", "", "", "Jo"),
//   Book("Title10", "", "h", "", "", "", "Jim"),
//   Book("Title11", "", "i", "", "", "", "Bob"),
//   Book("Title12", "", "j", "", "", "", "Bob")

//This is the main function that starts the app.
void main() {
  runApp(const MyApp());
}

//This is a my app class that creates a stateless widget with a title.
class MyApp extends StatelessWidget {
  static const title = "Book DB";
  const MyApp({super.key});


  // root of the application
  @override
  Widget build(BuildContext context) {
    List<Book> b = [];
    return MaterialApp(
      //Sets the title and theme data of the page
      title: 'Book DB',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF7F5539)),
      ),
      //sets the home page by calling MyHomePage widget with the title.
      home: MyHomePage(title: title, books: b,),
      routes: {
        '/AddBook': (context) => const AddBook(title: title),
        '/ScanBarcode': (context) => const ScanBarcode(title: title,),
      },
    );
  }
}

//MyHomePage widget that displays my home page.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.books});

  //sets the title.
  final String title;

  //Sets the list of books to show
  final List<Book> books;

  //Creates a homepage state.
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<Book> getCurrentBooks(){
  return tempBooks;
}

void addBook(Book b){
  b.setOwner(user.getUser());
  tempBooks.add(b);
}

//The actual homepage stuff
class _MyHomePageState extends State<MyHomePage> {
  //This list of colors keeps track of the different color of books on the main page. Allows for alternating between these three books.
  List<Color> bookColors = [Color(0xFF9C6644), Color(0xFF7F5539), Color(0xFFB08968)];

  //Some text editing controllers that allow me to get the text entered from the filter menu.
  static final TextEditingController _authorTextController = TextEditingController();
  static final TextEditingController _titleTextController = TextEditingController();
  static final TextEditingController _genreTextController = TextEditingController();

  static final TextEditingController _apiUrlTextController = TextEditingController();
  static final TextEditingController _usernameTextController = TextEditingController();
  static final TextEditingController _passwordTextController = TextEditingController();

  //Some helper variables to determine certain filtering. 
  //The personal library bool keeps track of whether only the user's books
  //show, or if all books show.
  //The show clear filter button determines whether the button to clear
  //the filter is shown.
  //The search list variable determines whether the add book button will show in the book info
  bool _personalLibrary = false;
  bool _showClearFilterButton = false;
  bool _searchList = false;

  //Some more helper variables to keep track of which way to sort the books
  //given a specific part of the book i.e. author, title, genre, review
  int authorSort = 0;
  int titleSort = 0;
  int genreSort = 0;
  int reviewSort = 0;

  //Initializes a books variable to the current books and initializes a filtered books variable for later
  List<Book> books = getCurrentBooks();
  List<Book> filteredBooks = [];

  //simple helper class to invert a color. Mainly used for text on the page.
  Color _invertColor(Color color){
    //Gets the rgb and subtracts those from 255.
    final r = 255 - (color.r * 255).round();
    final g = 255 - (color.g * 255).round();
    final b = 255 - (color.g * 255).round();

    //Converts the rgb to color and returns the color
    return Color.fromARGB((color.a * 255).round(), r, g, b);
  }

  //searches through the list of value maps given to find the target given.
  //O(N) time complexity
  List<ValueMap> _search(List<ValueMap> values, String target){
    //initializes the low and high values
    //These are necessary for binary search.
    int low = 0;
    int high = values.length - 1;

    //initializes the found values variable to hold the values that match the target.
    List<ValueMap> foundValues = [];

    //iterates through until low is greater than high.
    while (low <= high){
      //Splits the list in half to try and find the value.
      int mid = ((high + low) ~/ 2);

      //initializes a boolean to see if the value and target match, and 
      //initializes a comparison result to see if the target is on the left or right side of the split.
      bool contains = values[mid].getValue().contains(target);
      int comparisonResult = values[mid].getValue().compareTo(target);

      //Checks if the comparison result is zero (or it matches) or checks if the value contains the target (which is also a match).
      if (comparisonResult == 0 || contains){
        //Adds the value to the found values list.
        foundValues.add(values[mid]);

        //Loops from one after the mid variable until the end of the list is met to find any more matches.
        for (int i = mid + 1; i < values.length; i++){
          //checks it the value contains the target
          bool comparisonResult = values[i].getValue().contains(target);

          //If so, add the value to the found values target and continue on, otherwise stop iterating.
          if (comparisonResult){
            foundValues.add(values[i]);
          }else{
            i = values.length;
          }
        }

        //Loops from one before the mid variable until reaching the start of the list.
        for (int i = mid - 1; i >= 0; i--){
          //Checks if the value contains the target.
          bool comparisonResult = values[i].getValue().contains(target);

          //If it does contain the target, add the value to found values,
          //otherwise, exit the loop.
          if (comparisonResult){
            foundValues.add(values[i]);
          }else{
            i = 0;
          }
        }

        //Return the values that were found.
        return foundValues;
      }
      //if the compared result is negative, then we want to go to the right side of the list
      else if (comparisonResult < 0){
        low = mid + 1;
      }
      //This is the last check, which means the comparison result must be larger than 0
      //So we want to go to the left of the list. 
      else{
        high = mid - 1;
      }
      //Iterates again, so it splits it in half until we find a match.
    }

    //Returns foundValues (Which should be nothing since we got out of the while loop.
    return foundValues;
  }

  //filter out function to start the filtering process. Takes in a filter object 
  //O(N) time complexity
  void _filterOut(Filter controller){
    //Initializes a filter object
    Filter filter = Filter();

    //gets the text from the filter object passed and stores it as text
    String text = controller.text();

    //Gets the type from the text from the first space.
    String type = text.split(" ")[0];

    //Gets the rest of the text into a list of string and stores the first part in target.
    List<String> t = text.split(" ");

    String target = t[1];

    //iterates through the length of t and adds the value of t to target
    for (int i = 2; i < t.length; i++){
      target += " ${t[i]}";
    }

    //Creates a list of values to keep track of.
    List<ValueMap> values = [];

    type += " ";

    //Checks if the type is an author, title, genre, or user type and adds all of the corresponding values to the values variable above.
    if (type.contains(filter.getAuthorText())){
      for (int i = 0; i < filteredBooks.length; i++){
        values.add(ValueMap(i, filteredBooks[i].getAuthor()));
      }
    }
    else if (type.contains(filter.getTitleText())){
      for (int i = 0; i < filteredBooks.length; i++){
        values.add(ValueMap(i, filteredBooks[i].getTitle()));
      }
    }
    else if (type.contains(filter.getGenreText())){
      for (int i = 0; i < filteredBooks.length; i++){
        values.add(ValueMap(i, filteredBooks[i].getGenre()));
      }
    }
    else if (type.contains(filter.getUserText())){
      for (int i = 0; i < filteredBooks.length; i++){
        values.add(ValueMap(i, filteredBooks[i].getOwner()));
      }
    }
    //Will work with later.
    else{

    }

    //sorts the values by comparing the values to each other.
    values.sort((a, b) => a.getValue().compareTo(b.getValue()));

    //Searches for the target and stores the values returned in the values object
    values = _search(values, target);

    //Creates a temporary list of books
    List<Book> temp = [];

    //Adds the books to the temporary list of books that matched the target value.
    for (int i = 0; i < values.length; i++){
      temp.add(filteredBooks[values[i].getIndex()]);
    }

    //Runs the set state command to refresh the page and set the filtered books to the temporary variable.
    setState(() {
      filteredBooks = temp;
    });
  }

  //This is called to start the filtering from the submit button.
  void _filter(){
    //Creates a filter object.
    Filter filter = Filter();

    //Shows the clear filter button on the main page.
    setState(() {
      _showClearFilterButton = true;
    });

    //Checks if the personal library button was checked. If so, it filters out books that are not included in that filter.
    if (_personalLibrary){
      filter.addUserText(user.getUser());
      _filterOut(filter);
    }
    //If the personal library button is not checked, restore filtered books to its original list.
    else{
      filteredBooks = books;
    }

    //Checks if the user left any input in the author filter text button and filters by that text.
    if (_authorTextController.text.trim().isNotEmpty){
       filter.addAuthorText(_authorTextController.text);
      _filterOut(filter);
    }

    //Checks if the author sort arrows are changed to sort upward or downward.
    if (authorSort < 0){
      filteredBooks.sort((a, b) => a.getAuthor().compareTo(b.getAuthor()));
    }else if (authorSort > 0){
      filteredBooks.sort((a, b) => b.getAuthor().compareTo(a.getAuthor()));
    }

    //Checks if the user left any input in the title filter text button and filters by that text.
    if (_titleTextController.text.trim().isNotEmpty){
      filter.addTitleText(_titleTextController.text);
      _filterOut(filter);
    }

    //Checks if the title sort arrows are changed to sort upward or downward.
    if (titleSort < 0){
      filteredBooks.sort((a, b) => a.getTitle().compareTo(b.getTitle()));
    }else if (titleSort > 0){
      filteredBooks.sort((a, b) => b.getTitle().compareTo(a.getTitle()));
    }

    //Checks if the user left any input in the genre filter text button and filters by that text.
    if (_genreTextController.text.trim().isNotEmpty){
      filter.addGenreText(_genreTextController.text);
      _filterOut(filter);
    }

    //Checks if the genre sort arrows are changed to sort upward or downward.
    if (genreSort < 0){
      filteredBooks.sort((a, b) => a.getGenre().compareTo(b.getGenre()));
    }else if (genreSort > 0){
      filteredBooks.sort((a, b) => b.getGenre().compareTo(a.getGenre()));
    }

    //Checks if the review sort arrows are changed to sort upward or downward.
    if (reviewSort < 0){
      filteredBooks.sort((a, b) => a.getReviewAverage().compareTo(b.getReviewAverage()));
    }else if (reviewSort > 0){
      filteredBooks.sort((a, b) => b.getReviewAverage().compareTo(a.getReviewAverage()));
    }

    //Checks to make sure nothing has been changed in the filter option.
    //If so, it will clear all filter inputs and restore the original list of books.
    if (_genreTextController.text.trim().isEmpty
    && _authorTextController.text.trim().isEmpty
    && _titleTextController.text.trim().isEmpty
    && !_personalLibrary
    && authorSort == 0
    && titleSort == 0
    && genreSort == 0
    && reviewSort == 0
    ){
      _clearFilterInputs();
    }
  }

  void _clearFilterInputs(){
    _authorTextController.text = "";
    _titleTextController.text = "";
    _genreTextController.text = "";
    _personalLibrary = false;

    if (_searchList){
      _searchList = false;
      Navigator.pushNamed(context, '/');
    }

    setState(() {
      filteredBooks = books;
      _showClearFilterButton = false;
      authorSort = 0;
      genreSort = 0;
      titleSort = 0;
      reviewSort = 0;
    });
  }

  void _showURLForm(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add URL...'),
            //TODO: Create the form with the URL, username, and password for logging in to the server.
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Enter API URL Below:"),
                  TextField(
                    controller: _apiUrlTextController,
                    decoration: InputDecoration(
                      hintText: "Enter API URL",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      bool validUrl = await _verifyURL();

                      if (validUrl && context.mounted){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Valid URL!"),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          )
                        );
                      }else if (context.mounted){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Invalid URL."),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          )
                        );
                      }
                    },
                    child: Text("Validate URL"),
                  ),
                  Text("Enter Username Below:"),
                  TextField(
                    controller: _usernameTextController,
                    decoration: InputDecoration(
                      hintText: "Enter Username",
                    ),
                  ),
                  Text("Enter Password Below:"),
                  TextField(
                    controller: _passwordTextController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _verifyLogin();
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Submit"),
                  )
                ],
              ),
            )
          );
        }
    );
  }

  Future<bool> _verifyURL() async {
    String url = _apiUrlTextController.text;

    http.Response resp;

    try{
      resp = await http.get(
          Uri.parse("$url/api/version"),
          headers: userAgent
      ).timeout(const Duration(seconds: 5));
    }catch(e){
      return false;
    }


    if (resp.statusCode != 200){
      return false;
    }

    return true;
  }

  Future<void> _verifyLogin() async {
    if (!await _verifyURL()){
      return;
    }

    String apiUrl = _apiUrlTextController.text;
    String username = _usernameTextController.text;
    String password = _passwordTextController.text;

    //TODO: Verify username and password login with the valid URL.
    bool isValid = await login(apiUrl, username, password);

    if (!isValid){
      print("Invalid login");
      return;
    }

    Constants().setBookApiUrl(apiUrl);
  }

  //This is the main build widget that contains all the main page display.
  @override
  Widget build(BuildContext context) {
    //Creates the title with the current user's name.
    String title = widget.title;
    title += " - ${user.getUser()}";

    //Stores the width and height of the media device in the screenWidth and screenHeight variables initialized above respectively
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    Constants().initializeValues();

    //Some simple checks to see if we have any filter applied and if there are any books passed through the MainPage
    //If neither are true, this will clear all the filter inputs
    //The else if checks to make sure there is no filter and we have books being passed to the MainPage
    //If these are true, it will set the filteredBooks (AKA the ones that get listed on the main page) to be the books passed to the MainPage
    //Then it shows the clear filter button, and sets the search list variable to true
    if (filteredBooks.isEmpty && widget.books.isEmpty) {
      _clearFilterInputs();
    }else if(filteredBooks.isEmpty && widget.books.isNotEmpty){
      filteredBooks = widget.books;
      _showClearFilterButton = true;
      _searchList = true;
    }

    return Scaffold(
      //top-level menu for the main page.
        appBar: AppBar(
          //sets the background color of the appbar
            backgroundColor: Theme.of(context).colorScheme.primary,
            //Creates a builder object for the hamburger menu
            //button
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
                    onPressed: () async {
                      String apiUrl = await Constants().getBookApiUrl();
                      if (apiUrl.isEmpty && context.mounted){
                        _showURLForm(context);
                        return;
                      }
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                );
              },
            ),
            //Sets the title ("Book DB") to the center of navbar
            title: Center(
              //Gets the title set from the first method.
                child: Text(title,
                    style:TextStyle(
                        color: Color(0xFFE6CCB2),
                        fontSize: 24
                    ))
            ),

            //Loads the buttons/actions after the title.
            actions: <Widget>[
              if (_showClearFilterButton)
                ElevatedButton(
                  onPressed: (){
                    _clearFilterInputs();
                  },
                  child: Text("Clear Filter"),
                ),
              //Creates the filter button for filtering the list.
              if (!_searchList)
                Builder(
                  builder: (context){
                    return Container(
                      //Sets the color and roundedness of the button
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      //Sets the filter icon
                      child: IconButton(
                        icon: Icon(Icons.filter_alt),
                        //Makes it open the drawer on the right-hand
                        //side if pressed.
                        onPressed: () async {
                          String apiUrl = await Constants().getBookApiUrl();
                          if (apiUrl.isEmpty && context.mounted){
                            _showURLForm(context);
                            return;
                          }
                          Scaffold.of(context).openEndDrawer();
                        },
                      ),
                    );
                  },
                ),
            ]
        ),

        //left-hand side drawer or the hamburger menu drawer
        drawer: Drawer(
          //Utilizes the hamburger menu widget created below to display the hamburger menu
          child: HamburgerMenu(title: title),
        ),

        //right-hand side drawer or the filter drawer
        endDrawer: Drawer(

          //lists all items in the drawer
            child: Scaffold(
                appBar: AppBar(
                  //Sets the color of the title and color of the appbar
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  //Hamburger menu button
                  leading:Container(
                    //Sets the color and corner radius of the
                    //hamburger menu button
                    decoration: BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    //Sets the on pressed behavior to close the pull-out
                    //menu and sets the icon to be the hamburger menu
                    //icon
                    child: IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.filter_alt),
                    ),
                  ),

                  //The pull-out menu title
                  title: Center(
                    //Gets the title set from the first method.
                      child: Text(
                          title,
                          //Sets the color and font size of the title.
                          style:TextStyle(
                              color: Color(0xFFE6CCB2),
                              fontSize: 24
                          )
                      )
                  ),
                ),

                //Sets the background color of the main filter elements
                backgroundColor: defaultPageColor,

                body: SizedBox(
                  //Ensures the width is taking up the entire area
                  //This is done to ensure proper centering of the
                  //elements on the screen
                    width: double.infinity,

                    //All filter elements
                    child: Column(
                      children: <Widget>[
                        //Filter By: text
                        Text(
                          //sets the filter by text, the font weight, size, and color
                          "Filter By:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: headingFontSize,
                            color: _invertColor(defaultPageColor),
                          ),
                        ),

                        //My Library Filtering
                        Row(
                          //Makes sure the size of the row is small enough to still center properly
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            //Personal library text with font size and color
                            Text(
                              "Personal Library",
                              style: TextStyle(
                                fontSize: subHeadingFontSize,
                                color: _invertColor(defaultPageColor),
                              ),
                            ),
                            //Checkbox for the personal library
                            Checkbox(
                              //If the value changes, then make sure the value is not null then assign personal library to the value.
                              value: _personalLibrary,
                              onChanged: (bool? value){
                                setState(() {
                                  if (value != null){
                                    _personalLibrary = value;
                                  }
                                });
                              },
                            )
                          ],
                        ),

                        //Author text and filtering
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              //Author text
                              Text(
                                //Sets the text, font size, font weight, and color of the text.
                                "Author",
                                style: TextStyle(
                                  fontSize: subHeadingFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: _invertColor(defaultPageColor),
                                ),
                              ),

                              //Author arrow buttons
                              IconButton(
                                //Resets the other filtering arrows
                                  onPressed: (){
                                    titleSort = 0;
                                    genreSort = 0;
                                    reviewSort = 0;

                                    //Checks if the author sort is currently zero, if so it alternates from -1 to 1, to 0 again and again.
                                    if (authorSort == 0){
                                      setState(() {
                                        authorSort = -1;
                                      });
                                    }else if (authorSort == -1){
                                      setState(() {
                                        authorSort = 1;
                                      });
                                    }else{
                                      setState(() {
                                        authorSort = 0;
                                      });
                                    }
                                  },
                                  icon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        //Displays two arrows if the sort is 0, shows one arrow if the sort is greater than 0, and shows the opposite arrow when sort is less than 0
                                        if (authorSort == 0)
                                          Row(
                                            children: [
                                              Icon(Icons.arrow_upward),
                                              Icon(Icons.arrow_downward),
                                            ],
                                          ),
                                        if (authorSort > 0)
                                          Icon(Icons.arrow_upward),
                                        if (authorSort < 0)
                                          Icon(Icons.arrow_downward),
                                      ]
                                  )
                              )
                            ]
                        ),
                        SizedBox(
                          width: filterBoxSize,
                          child: TextField(
                            controller: _authorTextController,
                            decoration: InputDecoration(
                              hint: Text(
                                //Sets the text and font size.
                                "Enter author...",
                                style: TextStyle(
                                  fontSize: subHeadingFontSize,
                                ),
                              ),
                              //fills the text field with the color white, sets the border to the specified color with the specified width.
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF9C6644),
                                  width: 5.0,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: subHeadingFontSize,
                            ),
                          ),
                        ),

                        //Book Title text and filtering
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              //Author text
                              Text(
                                //Sets the text, font size, font weight, and color of the text.
                                "Book Title",
                                style: TextStyle(
                                  fontSize: subHeadingFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: _invertColor(defaultPageColor),
                                ),
                              ),

                              //Author arrow buttons
                              IconButton(
                                  onPressed: (){
                                    //Resets the other filtering arrows
                                    authorSort = 0;
                                    genreSort = 0;
                                    reviewSort = 0;

                                    //Checks if the title sort is currently zero, if so it alternates from -1 to 1, to 0 again and again.
                                    if (titleSort == 0){
                                      setState(() {
                                        titleSort = -1;
                                      });
                                    }else if (titleSort == -1){
                                      setState(() {
                                        titleSort = 1;
                                      });
                                    }else{
                                      setState(() {
                                        titleSort = 0;
                                      });
                                    }
                                  },
                                  icon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        //Displays two arrows if the sort is 0, shows one arrow if the sort is greater than 0, and shows the opposite arrow when sort is less than 0
                                        if (titleSort == 0)
                                          Row(
                                            children: [
                                              Icon(Icons.arrow_upward),
                                              Icon(Icons.arrow_downward),
                                            ],
                                          ),
                                        if (titleSort > 0)
                                          Icon(Icons.arrow_upward),
                                        if (titleSort < 0)
                                          Icon(Icons.arrow_downward),
                                      ]
                                  )
                              )
                            ]
                        ),
                        SizedBox(
                          width: filterBoxSize,
                          child: TextField(
                            controller: _titleTextController,
                            decoration: InputDecoration(
                              hint: Text(
                                //Sets the text and font size.
                                "Enter book title...",
                                style: TextStyle(
                                  fontSize: subHeadingFontSize,
                                ),
                              ),
                              //fills the text field with the color white, sets the border to the specified color with the specified width.
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF9C6644),
                                  width: 5.0,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: subHeadingFontSize,
                            ),
                          ),
                        ),

                        //Genre text and filtering
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              //Author text
                              Text(
                                //Sets the text, font size, font weight, and color of the text.
                                "Genre",
                                style: TextStyle(
                                  fontSize: subHeadingFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: _invertColor(defaultPageColor),
                                ),
                              ),

                              //Author arrow buttons
                              IconButton(
                                  onPressed: (){
                                    //Resets the other filtering arrows
                                    titleSort = 0;
                                    authorSort = 0;
                                    reviewSort = 0;

                                    //Checks if the genre sort is currently zero, if so it alternates from -1 to 1, to 0 again and again.
                                    if(genreSort == 0){
                                      setState(() {
                                        genreSort = -1;
                                      });
                                    }else if (genreSort == -1){
                                      setState(() {
                                        genreSort = 1;
                                      });
                                    }else if (genreSort == 1){
                                      setState(() {
                                        genreSort = 0;
                                      });
                                    }
                                  },
                                  icon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        //Displays two arrows if the sort is 0, shows one arrow if the sort is greater than 0, and shows the opposite arrow when sort is less than 0
                                        if (genreSort == 0)
                                          Row(
                                            children: [
                                              Icon(Icons.arrow_upward),
                                              Icon(Icons.arrow_downward),
                                            ],
                                          ),
                                        if (genreSort < 0)
                                          Icon(Icons.arrow_downward),
                                        if (genreSort > 0)
                                          Icon(Icons.arrow_upward),
                                      ]
                                  )
                              )
                            ]
                        ),
                        SizedBox(
                          width: filterBoxSize,
                          child: TextField(
                            controller: _genreTextController,
                            decoration: InputDecoration(
                              //fills the text field with the color white, sets the border to the specified color with the specified width.
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF9C6644),
                                  width: 5.0,
                                ),
                              ),
                              hint: Text(
                                //Sets the text and font size.
                                "Enter genre...",
                                style: TextStyle(
                                  fontSize: subHeadingFontSize,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: subHeadingFontSize,
                            ),
                          ),
                        ),

                        //Review text and filtering
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              //Author text
                              Text(
                                //Sets the text, font size, font weight, and color of the text.
                                "Reviews",
                                style: TextStyle(
                                  fontSize: subHeadingFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: _invertColor(defaultPageColor),
                                ),
                              ),

                              //Author arrow buttons
                              IconButton(
                                  onPressed: (){
                                    //Resets the other filtering arrows
                                    titleSort = 0;
                                    genreSort = 0;
                                    authorSort = 0;

                                    //Checks if the review sort is currently zero, if so it alternates from -1 to 1, to 0 again and again.
                                    if (reviewSort == 0){
                                      setState(() {
                                        reviewSort = -1;
                                      });
                                    }else if (reviewSort == -1){
                                      setState(() {
                                        reviewSort = 1;
                                      });
                                    }else{
                                      setState(() {
                                        reviewSort = 0;
                                      });
                                    }
                                  },
                                  icon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        //Displays two arrows if the sort is 0, shows one arrow if the sort is greater than 0, and shows the opposite arrow when sort is less than 0
                                        if (reviewSort == 0)
                                          Row(
                                            children: [
                                              Icon(Icons.arrow_upward),
                                              Icon(Icons.arrow_downward),
                                            ],
                                          ),
                                        if (reviewSort > 0)
                                          Icon(Icons.arrow_upward),
                                        if (reviewSort < 0)
                                          Icon(Icons.arrow_downward),
                                      ]
                                  )
                              )
                            ]
                        ),

                        //Submit button to start filtering
                        ElevatedButton(
                          onPressed: (){
                            //Starts filtering and closes the filter menu.
                            _filter();
                            Navigator.pop(context);
                          },
                          //Sets the color of the button, the size of the button, and removes the rounding.
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFDDB892),
                            minimumSize: minButtonSize,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
                          child: Text(
                            //Sets the button's text, color, and font size.
                            "Submit",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: subHeadingFontSize,
                            ),
                          ),
                        )
                      ],
                    )
                )

            )
        ),

        //Sets the background color of the main part of the page.
          backgroundColor: defaultPageColor,

          //Checks if we have any books. If we do it will display all books on the page
          //Otherwise, it will display text saying there are no books, and an add book button
          body: filteredBooks.isNotEmpty?
          ListView.builder(
            itemCount: filteredBooks.length, // The total number of items
            //Gets the context and the index.
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                //Creates a list tile for each item as a button
                title: FloatingActionButton(
                  //Alternates the colors of each book.
                  backgroundColor: bookColors[index % 3],
                  heroTag: "${filteredBooks[index].getTitle()} $index",
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookInfo(
                            title: title,
                            book: filteredBooks[index],
                            addBook: _searchList,
                          )
                      ),
                    );
                  },
                  //Removes the rounded edges on each book.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  //Sets the text to be the title of each book.
                  child: Text(
                    filteredBooks[index].getTitle(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      //Sets the color, size, weight, and truncates
                      //the title if it is too long to an ellipses.
                      color: Colors.white,
                      fontSize: bookFontSize,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            },
          ):
          //This shows the add book button in case we have none
          Center(
              child: Column(
                children: [
                  //No books available text
                  Text(
                      "No books available...",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  //Add book button
                  ElevatedButton(
                    //Sets the style to the default button style and navigates to the add book page on click
                      style: defaultButtonStyle,
                      onPressed: () async {
                        String apiUrl = await Constants().getBookApiUrl();
                        if (apiUrl.isEmpty && context.mounted){
                          _showURLForm(context);
                          return;
                        }

                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/AddBook',
                              (Route<dynamic> route) => false,
                        );
                      },
                      child: Text(
                        "Add Book",
                        style: defaultButtonTextStyle,
                      )
                  ),
                ],
              )
          ),


        //For future code. Can add this if there are no
        //books to show.
        //floatingActionButton: FloatingActionButton.large(
        //  backgroundColor: Color(0xFFD9D9D9),
//
        //  onPressed: (){
//
        //  },
        //  child:Text(
        //    "Add Books",
        //    style:TextStyle(
        //      fontSize:15,
        //      fontWeight: FontWeight.bold,
        //    ),
        //  ),
        //),
      );
  }
}

//Separation of hamburger menu to allow code reusability
class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({super.key, required this.title});

  //This hamburger menu only requires a title
  final String title;

  //Main hamburger menu stuff below
  @override
  Widget build(BuildContext context) {
    //Sets our global box spacing variable to the screenheight * .05
    boxSpacing = MediaQuery.of(context).size.height * .05;

    return Scaffold(
      backgroundColor: defaultPageColor,
      //Top-level menu for the pull-out menu
      appBar: AppBar(
        //Sets the color of the title and color of the appbar
        backgroundColor: Theme.of(context).colorScheme.primary,
        //Hamburger menu button
        leading: Container(
          //Sets the color and corner radius of the
          //hamburger menu button
          decoration: BoxDecoration(
            color: Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(10.0),
          ),
          //Sets the on pressed behavior to close the pull-out
          //menu and sets the icon to be the hamburger menu
          //icon
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.menu),
          ),
        ),

        //The pull-out menu title
        title: Center(
          //Gets the title set from the first method.
          child: Text(
            title,
            //Sets the color and font size of the title.
            style: TextStyle(
              color: Color(0xFFE6CCB2),
              fontSize: 24,
            ),
          ),
        ),
      ),
      //Everything else
      body: SizedBox(
        //Ensures the width is taking up the entire area
        //This is done to ensure proper centering of the
        //elements on the screen
        width: double.infinity,

        //Column element to add the buttons on top of each
        //other
        //This contains the view books, scan barcode,
        // and add book buttons.
        child: Column(
          //Children element to hold multiple widgets
          children: <Widget>[
            //Spacer element for aesthetics
            SizedBox(height: boxSpacing),

            //View Books button
            TextButton(
              //Sets the background color, makes the
              //buttons not round, and ensures they are
              //all the same size.
              style: defaultButtonStyle,

              //Button logic when it's pressed
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (Route<dynamic> route) => false,
                );
              },

              //The text on the button
              child: Text(
                "View Books",

                //This sets the font size, weight, and color
                //of the text on the button.
                style: defaultButtonTextStyle,
              ),
            ),

            //Spacer element for aesthetics
            SizedBox(height: boxSpacing),

            //Scan Barcode button
            TextButton(
              //Sets the background color, makes the
              //buttons not round, and ensures they are
              //all the same size.
              style: defaultButtonStyle,
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/ScanBarcode',
                      (Route<dynamic> route) => false,
                );
              },
              child: Text(
                "Scan Barcode",

                //This sets the font size, weight, and color
                //of the text on the button.
                style: defaultButtonTextStyle,
              ),
            ),

            //Spacer element for aesthetics
            SizedBox(height: boxSpacing),

            //Add Book button
            TextButton(
              //Sets the background color, makes the
              //buttons not round, and ensures they are
              //all the same size.
              style: defaultButtonStyle,
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/AddBook',
                  (Route<dynamic> route) => false,
                );
              },
              child: Text(
                "Add Book",

                //This sets the font size, weight, and color
                //of the text on the button.
                style: defaultButtonTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
