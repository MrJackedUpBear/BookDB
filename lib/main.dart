import 'package:flutter/material.dart';
import 'BookInfo.dart';
import 'AddBook.dart';

//Some constant variables to ensure easy and proper sizing and colors.
const filterBoxSize = 250.0;
late var boxSpacing = 40.0;
const defaultPageColor = Color(0xFFEDE0D4);
const minButtonSize = Size(50, 50);
const headingFontSize = 40.0;
const subHeadingFontSize = 25.0;
const bookFontSize = 20.0;
const menuButtonSize = Size(246, 53);
List<Book> filteredBooks = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const title = "Book DB";
  const MyApp({super.key});

  // root of the application
  @override
  Widget build(BuildContext context) {
    //generates a temporary list of books for testing
    //TODO: change this to only include books gotten from an API call to the local database.
    List<Book> books = [
      Book("Super long title that probably won't fit on the thingamabob", "", "", "", "Unavailable", "", "Jo"),
      Book("Harry Potter and the Sorcerer's Stone", "Fantasy", "J. K. Rowling", "This is a harry potter book.", "Available", "", "Jim"),
      Book("Harry Potter and the Prisoner of Azkaban", "Fantasy", "J. K. Rowling", "", "", "", "Bob"),
      Book("Title3", "", "a", "", "", "", "Jo"),
      Book("Title4", "", "b", "", "", "", "Jim"),
      Book("Title5", "Horror", "c", "", "", "", "Bob"),
      Book("Title6", "", "d", "", "", "", "Jo"),
      Book("Title7", "", "e", "", "", "", "Jim"),
      Book("Title8", "Thriller", "f", "", "", "", "Bob"),
      Book("Title9", "", "", "g", "", "", "Jo"),
      Book("Title10", "", "h", "", "", "", "Jim"),
      Book("Title11", "", "i", "", "", "", "Bob"),
      Book("Title12", "", "j", "", "", "", "Bob")];

    return MaterialApp(
      //Sets the title and themdata of the page
      title: 'Book DB',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF7F5539)),
      ),
      //sets the home page by calling MyHomePage widget with the title.
      home: MyHomePage(title: title, books: books,),
      routes: {
        '/AddBook': (context) => const AddBook(title: title),
      },
    );
  }
}

//MyHomePage widget that displays my home page.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.books});

  //sets the title.
  final String title;

  final List<Book> books;

  //Creates a homepage state.
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//Review class to hold different review information for a book.
class Review{
  //Initialized the title, description, and rating for the review
  var title = "";
  var description = "";
  var rating = 0.0;

  //constructor class to initialize some values for the review.
  Review(this.title, this.description, this.rating);

  //Normal setters and getters for the title, description, and rating
  void setTitle(String title){this.title = title;}

  void setDescription(String description){this.description = description;}

  void setRating(double rating){this.rating = rating;}

  String getTitle(){return title;}
  String getDescription(){return description;}
  double getRating(){return rating;}
}

//Book class to hold all necessary information about a given book
class Book{
  //initializes the book title, genre, author, reviews, description, availability, isbn, and owner.
  var _title = "";
  var _genre = "";
  var _author = "";
  final List<Review> _reviews = [];
  var _description = "";
  var _availability = "";
  var _isbn = "";
  var _owner = "";
  var _image = "";

  //Constructor class for Book
  Book(this._title, this._genre, this._author,
      this._description, this._availability,
      this._isbn, this._owner);

  static List<Book> getBooksFromJson(List<dynamic> json){
    List<Book> books = [];

    int length = json.length;

    if (length > 10){
      length = 10;
    }

    for (int i = 0; i < length; i++){
      String title, author = "";

      try{
        author = json[i]['author_name'][0];
      }catch(_){
        author = "";
      }

      try{
        title = json[i]['title'];
      }catch(_){
        title = "";
      }

      Book b = Book(
        title, //title
        '', //genre
        author, //author
        '', //Description
        '', //Availability
        '', //ISBN
        '' //Owner
      );
      books.add(b);
    }

    return books;
  }

  //Normal setters to set the title, genre, author, description, availability, isbn, and owner.
  void setTitle(String title){_title = title;}

  void setGenre(String genre){_genre = genre;}

  void setAuthor(String author){_author = author;}

  void setImage(String image){_image = image;}

  //This is a setter to add a review to the list of reviews
  void addReview(Review review) {_reviews.add(review);}

  void setDescription(String description){_description = description;}

  void setAvailability(String availability){_availability = availability;}

  void setIsbn(String isbn){_isbn = isbn;}

  void setOwner(String owner){_owner = owner;}

  //Normal getters to get the title, genre, author, description, availability, isbn, and owner.
  String getTitle(){return _title;}

  String getGenre(){return _genre;}

  String getAuthor(){return _author;}

  //This gets a specific review given an index.
  Review getReview(int index){
    //Checks if the index is a valid index. If not, returns an empty review.
    if (index < 0 || index > _reviews.length){
      return Review("", "", 0);
    }

    //Returns the element at the index given.
    return _reviews.elementAt(index);
  }

  //Returns the list of reviews
  List<Review> getReviews(){return _reviews;}

  //Calculates and returns the review mean or average
  double getReviewAverage(){
    //Keeps track of the total reviews in the list.
    var totalReviews = _reviews.length;

    //if there are no reviews, then the average is 0.0.
    if (totalReviews == 0){
      return 0.0;
    }

    //Initializes a totalScore variable to keep track of the total score. 
    //Then it iterates through the list of reviews and adds all the ratings together.
    var totalScore = 0.0;
    for (var r in _reviews){
      totalScore += r.getRating();
    }

    //Returns the total score divided by the total reviews.
    return totalScore / totalReviews;
  }

  String getDescription(){return _description;}

  String getAvailability(){return _availability;}

  String getIsbn(){return _isbn;}

  String getOwner(){return _owner;}
  String getImage(){return _image;}
}

//User class to handle ownership and other user things
class User{
  //initializes the user's name
  var _user = "";

  //constructor for User
  User(this._user);

  //Normal setters and getters for User class
  void _setUser(String user){
    _user = user;
  }

  String _getUser(){
    return _user;
  }
}

//Filter class to help with filtering books on the main page.
class Filter{
  //Initializes the author, title, genre, and user text to aid in filtering.
  String _authorText = "Author: ";
  String _titleText = "Title: ";
  String _genreText = "Genre: ";
  String _userText = "User: ";

  //Constructor that resets the author, title, genre, and user text
  Filter(){
    _reset();
  }

  //Normal getters for the author, title, genre, and user text.
  String _getAuthorText(){return _authorText;}
  String _getTitleText(){return _titleText;}
  String _getGenreText(){return _genreText;}
  String _getUserText(){return _userText;}

  //This gets the only text variable that contains a value and returns it.
  String _text(){
    if (_authorText.isNotEmpty){
      return _authorText;
    }else if (_titleText.isNotEmpty){
      return _titleText;
    }else if (_genreText.isNotEmpty){
      return _genreText;
    }else if (_userText.isNotEmpty){
      return _userText;
    }else{
      return "";
    }
  }

  //These functions add text to the variables initialized above.
  //It first resets the variables, then appends the text to the appropriate variable
  //then finally it clears all of the variables but the one appended to.
  void _addAuthorText(String text){
    _reset();
    _authorText += text;
    _clearAllBut(_authorText);
  }

  void _addTitleText(String text){
    _reset();
    _titleText += text;
    _clearAllBut(_titleText);
  }

  void _addGenreText(String text){
    _reset();
    _genreText += text;
    _clearAllBut(_genreText);
  }

  void _addUserText(String text){
    _reset();
    _userText += text;
    _clearAllBut(_userText);
  }

  //This clears all of the variables intialized at the top except
  //for the one that starts the same as the text passed into this.
  void _clearAllBut(String text){
    if (!text.contains(_authorText)){
      _authorText = "";
    }

    if (!text.contains(_genreText)){
      _genreText = "";
    }

    if (!text.contains(_titleText)){
      _titleText = "";
    }

    if (!text.contains(_userText)){
      _userText = "";
    }
  }

  //resets all of the variables to their initial values.
  void _reset(){
    _authorText = "Author: ";
    _titleText = "Title: ";
    _genreText = "Genre: ";
    _userText = "User: ";
  }
}

//This is a map type structure to keep track of an index and a value corresponding to that index.
class ValueMap{
  //Initializes the index and value
  int _index = 0;
  String _value = "";

  //Constructor class
  ValueMap(int index, String value){
    _index = index;
    _value = value;
  }

  //Normal getters since these values should not be changed, so there is no need for setters.
  int _getIndex(){return _index;}
  String _getValue(){return _value;}
}

//The actual homepage stuff
class _MyHomePageState extends State<MyHomePage> {
  //This list of colors keeps track of the different color of books on the main page. Allows for alternating between these three books.
  List<Color> bookColors = [Color(0xFF9C6644), Color(0xFF7F5539), Color(0xFFB08968)];

  //Some text editing controllers that allow me to get the text entered from the filter menu.
  static final TextEditingController _authorTextController = TextEditingController();
  static final TextEditingController _titleTextController = TextEditingController();
  static final TextEditingController _genreTextController = TextEditingController();

  //Some helper variables to determine certain filtering. 
  //The personal library bool keeps track of whether only the user's books
  //show, or if all books show.
  //The show clear filter button determines whether the button to clear
  //the filter is shown.
  bool _personalLibrary = false;
  bool _showClearFilterButton = false;

  //Some more helper variables to keep track of which way to sort the books
  //given a specific part of the book i.e. author, title, genre, review
  int authorSort = 0;
  int titleSort = 0;
  int genreSort = 0;
  int reviewSort = 0;

  //generates a temporary list of books for testing
  //TODO: change this to only include books gotten from an API call to the local database.
  List<Book> books = [
    Book("Super long title that probably won't fit on the thingamabob", "", "", "", "Unavailable", "", "Jo"),
    Book("Harry Potter and the Sorcerer's Stone", "Fantasy", "J. K. Rowling", "This is a harry potter book.", "Available", "", "Jim"),
    Book("Harry Potter and the Prisoner of Azkaban", "Fantasy", "J. K. Rowling", "", "", "", "Bob"),
    Book("Title3", "", "a", "", "", "", "Jo"),
    Book("Title4", "", "b", "", "", "", "Jim"),
    Book("Title5", "Horror", "c", "", "", "", "Bob"),
    Book("Title6", "", "d", "", "", "", "Jo"),
    Book("Title7", "", "e", "", "", "", "Jim"),
    Book("Title8", "Thriller", "f", "", "", "", "Bob"),
    Book("Title9", "", "", "g", "", "", "Jo"),
    Book("Title10", "", "h", "", "", "", "Jim"),
    Book("Title11", "", "i", "", "", "", "Bob"),
    Book("Title12", "", "j", "", "", "", "Bob")];

  //Creates a user variable to test out the 
  //TODO: change this to only include the user gotten from an API call to the local database.
  User user = User("Bob");

  //simple helper class to invert a color. Mainly used for text on the page.
  Color _invertColor(Color color){
    //Gets the rgb and subtracts those from 255.
    final r = 255 - (color.r * 255).round();
    final g = 255 - (color.g * 255).round();
    final b = 255 - (color.g * 255).round();

    //Converts the rgb to color and returns the color
    return Color.fromARGB((color.a * 255).round(), r, g, b);
  }

  //searches through the list of valuemaps given to find the target given.
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
      bool contains = values[mid]._getValue().contains(target);
      int comparisonResult = values[mid]._getValue().compareTo(target);

      //Checks if the comparison result is zero (or it matches) or checks if the value contains the target (which is also a match).
      if (comparisonResult == 0 || contains){
        //Adds the value to the found values list.
        foundValues.add(values[mid]);

        //Loops from one after the mid variable until the end of the list is met to find any more matches.
        for (int i = mid + 1; i < values.length; i++){
          //checks it the value contains the target
          bool comparisonResult = values[i]._getValue().contains(target);

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
          bool comparisonResult = values[i]._getValue().contains(target);

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
    String text = controller._text();

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
    if (type.contains(filter._getAuthorText())){
      for (int i = 0; i < filteredBooks.length; i++){
        values.add(ValueMap(i, filteredBooks[i].getAuthor()));
      }
    }
    else if (type.contains(filter._getTitleText())){
      for (int i = 0; i < filteredBooks.length; i++){
        values.add(ValueMap(i, filteredBooks[i].getTitle()));
      }
    }
    else if (type.contains(filter._getGenreText())){
      for (int i = 0; i < filteredBooks.length; i++){
        values.add(ValueMap(i, filteredBooks[i].getGenre()));
      }
    }
    else if (type.contains(filter._getUserText())){
      for (int i = 0; i < filteredBooks.length; i++){
        values.add(ValueMap(i, filteredBooks[i].getOwner()));
      }
    }
    //Will work with later.
    else{

    }

    //sorts the values by comparing the values to each other.
    values.sort((a, b) => a._getValue().compareTo(b._getValue()));

    //Searches for the target and stores the values returned in the values object
    values = _search(values, target);

    //Creates a temporary list of books
    List<Book> temp = [];

    //Adds the books to the temporary list of books that matched the target value.
    for (int i = 0; i < values.length; i++){
      temp.add(filteredBooks[values[i]._getIndex()]);
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
      filter._addUserText(user._getUser());
      _filterOut(filter);
    }
    //If the personal library button is not checked, restore filtered books to its original list.
    else{
      filteredBooks = books;
    }

    //Checks if the user left any input in the author filter text button and filters by that text.
    if (_authorTextController.text.trim().isNotEmpty){
       filter._addAuthorText(_authorTextController.text);
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
      filter._addTitleText(_titleTextController.text);
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
      filter._addGenreText(_genreTextController.text);
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

    setState(() {
      filteredBooks = books;
      _showClearFilterButton = false;
      authorSort = 0;
      genreSort = 0;
      titleSort = 0;
      reviewSort = 0;
    });
  }

  //This is the main build widget that contains all the main page display.
  @override
  Widget build(BuildContext context) {
    //Creates the title with the current user's name.
    String title = widget.title;
    title += " - ${user._getUser()}";

    List<Book> books = widget.books;

    //This creates a list of filteredbooks for the use of filtering later on.
    late List<Book> filteredBooks = books;

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
                onPressed: (){
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
                  onPressed: (){
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
        //Lists all items in the menu.
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
                      //If the value changes, then make sure the value is not null then assign personal livrary to the value.
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
                      //fills the text field with the color white, sets the borded to the specified color with the specified width.
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

      //Displays all books on the page.
      body: ListView.builder(
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

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
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
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF9C6644),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                minimumSize: menuButtonSize,
              ),

              //Button logic when it's pressed
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },

              //The text on the button
              child: Text(
                "View Books",

                //This sets the font size, weight, and color
                //of the text on the button.
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
            ),

            //Spacer element for aesthetics
            SizedBox(height: boxSpacing),

            //Scan Barcode button
            TextButton(
              //Sets the background color, makes the
              //buttons not round, and ensures they are
              //all the same size.
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF9C6644),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                minimumSize: menuButtonSize,
              ),
              onPressed: () {},
              child: Text(
                "Scan Barcode",

                //This sets the font size, weight, and color
                //of the text on the button.
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
            ),

            //Spacer element for aesthetics
            SizedBox(height: boxSpacing),

            //Add Book button
            TextButton(
              //Sets the background color, makes the
              //buttons not round, and ensures they are
              //all the same size.
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF9C6644),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                minimumSize: menuButtonSize,
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/AddBook");
              },
              child: Text(
                "Add Book",

                //This sets the font size, weight, and color
                //of the text on the button.
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
