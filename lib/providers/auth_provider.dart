import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier{
  final _storage = FlutterSecureStorage();

  Future<bool> login(String UserName, String PasswordHash) async {
    final response = await http.post(
      Uri.parse('http://localhost:5009/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'UserName': UserName, 'PasswordHash': PasswordHash}),
    );

    if (response.statusCode == 200) {
      await _storage.write(key: 'token', value: response.body);
      return true;
    } else {
      return false;
    }
  }
     


  Future<bool> signup(String UserName, String PasswordHash) async {
    final response = await http.post(
      Uri.parse('http://localhost:5009/signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'UserName': UserName, 'PasswordHash': PasswordHash}),
    );

    if (response.statusCode == 201) {
      await _storage.write(key: 'token', value: response.body);
      return true;
    } else {
      return false;
    }
  }
}
