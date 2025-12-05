import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Some constant variables to ensure easy and proper sizing and colors.
const filterBoxSize = 250.0;
var boxSpacing = 40.0;
const defaultPageColor = Color(0xFFEDE0D4);
const minButtonSize = Size(50, 50);
const headingFontSize = 40.0;
const subHeadingFontSize = 25.0;
const bookFontSize = 20.0;
const menuButtonSize = Size(246, 53);
String _bookApiUrl = "Temp";

//Needed for future use. Will allow the change and getting of the API url.
class Constants{
  void initializeValues() async{
    final prefs = await SharedPreferences.getInstance();

    _bookApiUrl = prefs.getString("Book API Url") ?? "";
  }

  void setBookApiUrl(String apiUrl) async{
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("Book API Url", apiUrl);
    _bookApiUrl = apiUrl;
  }

  String getBookApiUrl(){
    return _bookApiUrl;
  }
}