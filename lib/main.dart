import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book DB',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF7F5539)),
      ),
      home: const MyHomePage(title: 'Book DB'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Review{
  var title = "";
  var description = "";
  var rating = 0.0;

  Review(this.title, this.description, this.rating);

  void setTitle(String title){this.title = title;}

  void setDescription(String description){this.description = description;}

  void setRating(double rating){this.rating = rating;}

  String getTitle(){return title;}
  String getDescription(){return description;}
  double getRating(){return rating;}
}

class Book{
  var _title = "";
  var _genre = "";
  var _author = "";
  final List<Review> _reviews = [];
  var _description = "";
  var _availability = "";
  var _isbn = "";
  var _owner = "";

  Book(this._title, this._genre, this._author,
      this._description, this._availability,
      this._isbn, this._owner);

  void setTitle(String title){_title = title;}

  void setGenre(String genre){_genre = genre;}

  void setAuthor(String author){_author = author;}

  void addReview(Review review) {_reviews.add(review);}

  void setDescription(String description){_description = description;}

  void setAvailability(String availability){_availability = availability;}

  void setIsbn(String isbn){_isbn = isbn;}

  void setOwner(String owner){_owner = owner;}

  String getTitle(){return _title;}

  String getGenre(){return _genre;}

  String getAuthor(){return _author;}

  Review getReview(int index){
    if (index < 0 || index > _reviews.length){
      return Review("", "", 0);
    }

    return _reviews.elementAt(index);
  }

  List<Review> getReviews(){return _reviews;}

  double getReviewAverage(){
    var totalReviews = _reviews.length;

    if (totalReviews == 0){
      return 0.0;
    }

    var totalScore = 0.0;
    for (var r in _reviews){
      totalScore += r.getRating();
    }

    return totalScore / totalReviews;
  }

  String getDescription(){return _description;}

  String getAvailability(){return _availability;}

  String getIsbn(){return _isbn;}

  String getOwner(){return _owner;}
}

class User{
  var _user = "";

  User(this._user);

  void _setUser(String user){
    _user = user;
  }

  String _getUser(){
    return _user;
  }
}

class Filter{
  String _authorText = "Author: ";
  String _titleText = "Title: ";
  String _genreText = "Genre: ";
  String _userText = "User: ";

  Filter(){
    _reset();
  }

  String _getAuthorText(){return _authorText;}
  String _getTitleText(){return _titleText;}
  String _getGenreText(){return _genreText;}
  String _getUserText(){return _userText;}
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

  void _reset(){
    _authorText = "Author: ";
    _titleText = "Title: ";
    _genreText = "Genre: ";
    _userText = "User: ";
  }
}

class ValueMap{
  int _index = 0;
  String _value = "";

  ValueMap(int index, String value){
    _index = index;
    _value = value;
  }

  int _getIndex(){return _index;}
  String _getValue(){return _value;}
}

class _MyHomePageState extends State<MyHomePage> {
  List<Color> bookColors = [Color(0xFF9C6644), Color(0xFF7F5539), Color(0xFFB08968)];

  static const _filterBoxSize = 250.0;
  static const _boxSpacing = 40.0;
  static const _defaultPageColor = Color(0xFFEDE0D4);
  static const _minButtonSize = Size(50, 50);
  static const _headingFontSize = 40.0;
  static const _subHeadingFontSize = 25.0;
  static const _bookFontSize = 20.0;

  static final TextEditingController _authorTextController = TextEditingController();
  static final TextEditingController _titleTextController = TextEditingController();
  static final TextEditingController _genreTextController = TextEditingController();

  List<Review> r = [Review("","", 0.0)];

  bool _personalLibrary = false;
  bool _showClearFilterButton = false;

  int authorSort = 0;
  int titleSort = 0;
  int genreSort = 0;
  int reviewSort = 0;

  late List<Book> books = [
    Book("Super long title that probably won't fit on the thingamabob", "", "", "", "", "", "Jo"),
    Book("Harry Potter and the Sorcerer's Stone", "Fantasy", "J. K. Rowling", "", "", "", "Jim"),
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

  User user = User("Bob");

  late List<Book> filteredBooks = books;

  Color _invertColor(Color color){
    final r = 255 - (color.r * 255).round();
    final g = 255 - (color.g * 255).round();
    final b = 255 - (color.g * 255).round();

    return Color.fromARGB((color.a * 255).round(), r, g, b);
  }

  List<ValueMap> _search(List<ValueMap> values, String target){
    int low = 0;
    int high = values.length - 1;

    List<ValueMap> foundValues = [];

    while (low <= high){
      int mid = ((high + low) ~/ 2);

      bool contains = values[mid]._getValue().contains(target);
      int comparisonResult = values[mid]._getValue().compareTo(target);

      if (comparisonResult == 0 || contains){
        foundValues.add(values[mid]);
        for (int i = mid + 1; i < values.length; i++){
          bool comparisonResult = values[i]._getValue().contains(target);

          if (comparisonResult){
            foundValues.add(values[i]);
          }else{
            i = values.length;
          }
        }

        for (int i = mid - 1; i >= 0; i--){
          bool comparisonResult = values[i]._getValue().contains(target);

          if (comparisonResult){
            foundValues.add(values[i]);
          }else{
            i = 0;
          }
        }

        return foundValues;
      }
      else if (comparisonResult < 0){
        low = mid + 1;
      }
      else{
        high = mid - 1;
      }
    }

    return foundValues;
  }

  void _filterOut(Filter controller){
    Filter filter = Filter();

    String text = controller._text();

    String type = text.split(" ")[0];

    List<String> t = text.split(" ");

    String target = t[1];

    for (int i = 2; i < t.length; i++){
      target += " ${t[i]}";
    }

    List<ValueMap> values = [];

    type += " ";

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
    else{

    }

    values.sort((a, b) => a._getValue().compareTo(b._getValue()));

    values = _search(values, target);

    List<int> finalIndices = [];

    //Need to optimize this. No reason to create a
    //log(n) search method just to do an n^2 method...
    for (int i = 0; i < filteredBooks.length; i++){
      for (int j = 0; j < values.length; j++){
        if (values[j]._getIndex() == i){
          finalIndices.add(i);
        }
      }
    }

    List<Book> temp = [];
    for (int i = 0; i < finalIndices.length; i++){
      temp.add(filteredBooks[finalIndices[i]]);
    }

    setState(() {
      filteredBooks = temp;
    });
  }
  
  void _filter(){
    Filter filter = Filter();

    setState(() {
      _showClearFilterButton = true;
    });

    if (_personalLibrary){
      filter._addUserText(user._getUser());
      _filterOut(filter);
    }else{
      filteredBooks = books;
    }

    if (_authorTextController.text.trim().isNotEmpty){
       filter._addAuthorText(_authorTextController.text);
      _filterOut(filter);
    }

    if (authorSort < 0){
      filteredBooks.sort((a, b) => a.getAuthor().compareTo(b.getAuthor()));
    }else if (authorSort > 0){
      filteredBooks.sort((a, b) => b.getAuthor().compareTo(a.getAuthor()));
    }

    if (_titleTextController.text.trim().isNotEmpty){
      filter._addTitleText(_titleTextController.text);
      _filterOut(filter);
    }

    if (titleSort < 0){
      filteredBooks.sort((a, b) => a.getTitle().compareTo(b.getTitle()));
    }else if (titleSort > 0){
      filteredBooks.sort((a, b) => b.getTitle().compareTo(a.getTitle()));
    }

    if (_genreTextController.text.trim().isNotEmpty){
      filter._addGenreText(_genreTextController.text);
      _filterOut(filter);
    }

    if (genreSort < 0){
      filteredBooks.sort((a, b) => a.getGenre().compareTo(b.getGenre()));
    }else if (genreSort > 0){
      filteredBooks.sort((a, b) => b.getGenre().compareTo(a.getGenre()));
    }

    if (reviewSort < 0){
      filteredBooks.sort((a, b) => a.getReviewAverage().compareTo(b.getReviewAverage()));
    }else if (reviewSort > 0){
      filteredBooks.sort((a, b) => b.getReviewAverage().compareTo(a.getReviewAverage()));
    }

    //Possibly will run this at the end to clear all inputs from
    //the filter pull-out menu
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

  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    title += " - ${user._getUser()}";

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
        child: Scaffold(
          backgroundColor: _defaultPageColor,
          //Top-level menu for the pull-out menu
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
                icon: Icon(Icons.menu),
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
                const SizedBox(height: _boxSpacing),

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
                    minimumSize: Size(246, 53),
                  ),

                  //Button logic when it's pressed
                  onPressed: (){

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
                const SizedBox(height: _boxSpacing),

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
                    minimumSize: Size(246, 53),
                  ),
                  onPressed: (){

                  },
                  child: Text(
                    "Scan Barcode",

                    //This sets the font size, weight, and color
                    //of the text on the button.
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  )
                ),

                //Spacer element for aesthetics
                const SizedBox(height: _boxSpacing),

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
                    minimumSize: Size(246, 53),
                  ),
                  onPressed: (){

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
                  )
                ),
              ],
            ),
          )
        ),
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
          backgroundColor: _defaultPageColor,

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
                  "Filter By:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _headingFontSize,
                    color: _invertColor(_defaultPageColor),
                  ),
                ),

                //My Library Filtering
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Personal Library",
                      style: TextStyle(
                        fontSize: _subHeadingFontSize,
                        color: _invertColor(_defaultPageColor),
                      ),
                    ),
                    Checkbox(
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
                      "Author",
                      style: TextStyle(
                        fontSize: _subHeadingFontSize,
                        fontWeight: FontWeight.bold,
                        color: _invertColor(_defaultPageColor),
                      ),
                    ),

                    //Author arrow buttons
                    IconButton(
                      onPressed: (){
                        titleSort = 0;
                        genreSort = 0;
                        reviewSort = 0;
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
                  width: _filterBoxSize,
                  child: TextField(
                    controller: _authorTextController,
                    decoration: InputDecoration(
                      hint: Text(
                        "Enter author...",
                        style: TextStyle(
                          fontSize: _subHeadingFontSize,
                        ),
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
                    style: TextStyle(
                      fontSize: _subHeadingFontSize,
                    ),
                  ),
                ),

                //Book Title text and filtering
                Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //Author text
                      Text(
                        "Book Title",
                        style: TextStyle(
                          fontSize: _subHeadingFontSize,
                          fontWeight: FontWeight.bold,
                          color: _invertColor(_defaultPageColor),
                        ),
                      ),

                      //Author arrow buttons
                      IconButton(
                          onPressed: (){
                            authorSort = 0;
                            genreSort = 0;
                            reviewSort = 0;
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
                  width: _filterBoxSize,
                  child: TextField(
                    controller: _titleTextController,
                    decoration: InputDecoration(
                      hint: Text(
                        "Enter book title...",
                        style: TextStyle(
                          fontSize: _subHeadingFontSize,
                        ),
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
                    style: TextStyle(
                      fontSize: _subHeadingFontSize,
                    ),
                  ),
                ),

                //Genre text and filtering
                Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //Author text
                      Text(
                        "Genre",
                        style: TextStyle(
                          fontSize: _subHeadingFontSize,
                          fontWeight: FontWeight.bold,
                          color: _invertColor(_defaultPageColor),
                        ),
                      ),

                      //Author arrow buttons
                      IconButton(
                          onPressed: (){
                            titleSort = 0;
                            authorSort = 0;
                            reviewSort = 0;
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
                  width: _filterBoxSize,
                  child: TextField(
                    controller: _genreTextController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF9C6644),
                          width: 5.0,
                        ),
                      ),
                      hint: Text(
                        "Enter genre...",
                        style: TextStyle(
                          fontSize: _subHeadingFontSize,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: _subHeadingFontSize,
                    ),
                  ),
                ),

                //Review text and filtering
                Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //Author text
                      Text(
                        "Reviews",
                        style: TextStyle(
                          fontSize: _subHeadingFontSize,
                          fontWeight: FontWeight.bold,
                          color: _invertColor(_defaultPageColor),
                        ),
                      ),

                      //Author arrow buttons
                      IconButton(
                          onPressed: (){
                            titleSort = 0;
                            genreSort = 0;
                            authorSort = 0;
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
                    _filter();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDDB892),
                    minimumSize: _minButtonSize,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: _subHeadingFontSize,
                    ),
                  ),
                )
              ],
            )
          )

        )
      ),

      //Sets the background color of the main part of the page.
      backgroundColor: _defaultPageColor,

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
              onPressed: (){

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
                  fontSize: _bookFontSize,
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
