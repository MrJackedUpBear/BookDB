import 'dart:convert';
import 'dart:io';

import 'package:book_db/constants.dart';
import 'package:http/http.dart' as http;

Future<bool> login(String apiUrl, String username, String password) async {
  List<int> stringBytes = utf8.encode('$username:$password');

  String base64Auth = base64.encode(stringBytes);

  Map<String, String> authHeader = {
    HttpHeaders.authorizationHeader: 'Basic $base64Auth'
  };

  http.Response resp = await http.get(
    Uri.parse('$apiUrl/api/login'),
    headers: authHeader,
  );

  if (resp.statusCode != 200){
    print(resp.statusCode);
    return false;
  }

  print(resp.body);

  return true;
}