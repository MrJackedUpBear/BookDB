import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//Some constant variables to ensure easy and proper sizing and colors.
const filterBoxSize = 250.0;
var boxSpacing = 40.0;
const defaultPageColor = Color(0xFFEDE0D4);
const minButtonSize = Size(50, 50);
const headingFontSize = 40.0;
const subHeadingFontSize = 25.0;
const bookFontSize = 20.0;
const menuButtonSize = Size(246, 53);

//For internal server api access
String _bookApiUrl = "";
String _accessToken = "";

final _storage = const FlutterSecureStorage();

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

  Future<String> getBookApiUrl() async {
    final prefs = await SharedPreferences.getInstance();

    String? temp = prefs.getString("Book API Url");

    if (temp == null){
      _bookApiUrl = "";
    }else{
      _bookApiUrl = temp;
    }

    return _bookApiUrl;
  }

  Future<void> setAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("Access Token", accessToken);

    _accessToken = accessToken;
  }

  Future<void> setRefreshToken(String refreshToken) async{
    await _storage.write(key: "Refresh Token", value:refreshToken);
  }

  Future<String> getRefreshToken() async{
    String? token = await _storage.read(key: "Refresh Token");

    if(token == null){
      return "";
    }

    return token;
  }

  Future<String> getAccessToken() async{
    final prefs = await SharedPreferences.getInstance();

    String? accessToken = prefs.getString("Access Token");

    if (accessToken == null){
      _accessToken = "";
    }else{
      _accessToken = accessToken;
    }

    return _accessToken;
  }
}