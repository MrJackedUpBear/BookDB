//Review class to hold different review information for a book.
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'add_book.dart';

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

  //Time complexity is about O(nlog(n))
  //Gets a list of books from a JSON object
  static Future<List<Book>> getBooksFromJson(List<dynamic> json) async {
    //Initializes the book list that we will return
    List<Book> books = [];

    //Assigns the length of the json to length
    int length = json.length;

    //Iterates through the JSON. Time complexity of O(N) where N is the length of the JSON
    for (int i = 0; i < length; i++){
      //Initializes our title, author, isbn, and description
      String title = "";
      String author = "";
      String isbn = "";
      String description = "";

      //Does a try catch for author and title in case the json does not contain these
      //It tries to assign author and title to the values in the JSON, if it fails it just makes them empty strings
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

      //This is a try catch to get the isbn for the book
      try{
        //Creates a dynamic list of ids from the json['ia'] map
        List<dynamic> id = json[i]['ia'];

        //This sorts the ids to allow for binary search of the isbn
        id.sort((a, b) => a.toString().compareTo(b.toString()));

        //Stores the number of identifiers in an int identifiers
        int identifiers = id.length;

        //Initializes a found value boolean so we can iterate until we find the value
        bool foundVal = false;

        int start = 0;
        int end = identifiers;

        //binary search to find the isbn in each book. O(log(n))
        //Loops until we find the value we want\
        //TODO: This code is kinda useless right now. We already do another API call to get an ISBN, so we don't need this...
        while (!foundVal){
          //If our start value is less than the end value, exit the while loop.
          //This means we reached the end of our list
          if (start > end){
            break;
          }

          //Creates a mid point from the start and end by adding them together and integer dividing by 2
          int mid = (start + end) ~/ 2;

          //Compares 'isbn_' to the current id from the start of the string to the length of 'isbn_'
          int comparison = 'isbn_'.compareTo(id[mid].toString().substring(0, 'isbn_'.length));

          //Checks the comparison value. If it is 0, we found it! If it is greater than zero, we need to search the right side. Otherwise, we need to search the left side.
          if (comparison == 0){
            isbn = id[mid].toString().substring('isbn_'.length);
            foundVal = true;
          }else if (comparison > 0){
            start = mid + 1;
          }else{
            end = mid - 1;
          }
        }
        //If any of this fails, set isbn to an empty string
      }catch(_){
        isbn = "";
      }

      //Initializes a cover edition variable to try and get the cover edition
      String coverEdition = "";

      try{
        coverEdition = json[i]['cover_edition_key'];
      }catch(_){
        //Error getting cover edition...
        coverEdition = "";
      }

      //Currently this does an api call to get more book info with the cover edition found.
      //TODO: Change this to check if coverEdition is not empty before doing an API call
      http.Response resp = await getExtraBookInfo(coverEdition);

      //If the reponse indicates success, start finding the info
      if (resp.statusCode == 200 && coverEdition.isNotEmpty){
        //Gets a map with a string and dynamic variable
        Map<String, dynamic> extraBookInfo = jsonDecode(resp.body);

        //Tries to set the isbn and description, if it fails it will set them to empty strings
        try{
          isbn = extraBookInfo['isbn13'].toString();
        }catch(_){
          isbn = "";
        }

        if (isbn.isEmpty){
          try{
            isbn = extraBookInfo['isbn10'].toString();
          }catch(_){
            //Error...
            isbn = "";
          }
        }

        try {
          description = extraBookInfo['description']['value'];
        }catch (_){
          description = "";
        }
      }

      //Makes sure that we have an ISBN before adding the book to the final list
      if (isbn.isNotEmpty){
        Book b = Book();
        b.setTitle(title);
        b.setAuthor(author);
        b.setIsbn(isbn);
        b.setDescription(description);
        books.add(b);
      }
    }

    return books;
  }

  //Gets a book from a json object
  static Future<Book> getBookFromJson(Map<String, dynamic> bookInfo) async{
    //Initializes our book and response variables
    Book b = Book();
    http.Response resp;

    //Initializes our title, description, and author variables
    String title = "";
    String description = "";
    String author = "";

    //Initializes our works and workInfo variables
    String works = "";
    Map<String, dynamic> workInfo = {};

    //This try-catch block tries to get the work info and then storing that in the work info variable above
    try {
      //This gets the works id by finding works in the json, getting the first element, and then substringing it to get only the id
      works = bookInfo['works'][0]['key'].toString().substring('/works/'.length);

      //Make an API call to get the work info
      resp = await getWorkInfo(works);

      //If it is a bad response, just return
      if (resp.statusCode != 200){
        return b;
      }

      //Set the work info to the decodes JSON response
      workInfo = jsonDecode(resp.body);
    }catch(_){
      return b;
    }

    //Tries to set the title and description. If it fails, set them to empty strings
    try{
      title = workInfo['title'];
    }catch(_){
      title = "";
    }

    try {
      description = workInfo['description']['value'];
    }catch(_){
      description = "";
    }

    //TODO: Get author information and store it in the author variable

    //Sets the title, description and author for the book and returns it
    b.setTitle(title);
    b.setDescription(description);
    b.setAuthor(author);

    return b;
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
  var _accessToken = "";

  //constructor for User
  User(this._user);

  //Normal setters and getters for User class
  void setUser(String user){
    _user = user;
  }

  void setAccessToken(String accessToken){
    _accessToken = accessToken;
  }

  String getUser(){
    return _user;
  }

  String getAccessToken(){
    return _accessToken;
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
  String getAuthorText(){return _authorText;}
  String getTitleText(){return _titleText;}
  String getGenreText(){return _genreText;}
  String getUserText(){return _userText;}

  //This gets the only text variable that contains a value and returns it.
  String text(){
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
  void addAuthorText(String text){
    _reset();
    _authorText += text;
    _clearAllBut(_authorText);
  }

  void addTitleText(String text){
    _reset();
    _titleText += text;
    _clearAllBut(_titleText);
  }

  void addGenreText(String text){
    _reset();
    _genreText += text;
    _clearAllBut(_genreText);
  }

  void addUserText(String text){
    _reset();
    _userText += text;
    _clearAllBut(_userText);
  }

  //This clears all of the variables initialized at the top except
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
  int getIndex(){return _index;}
  String getValue(){return _value;}
}

