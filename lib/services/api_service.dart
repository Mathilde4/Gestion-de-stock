import 'dart:convert';
import 'package:gestion_stock/models/admin.dart';
import 'package:gestion_stock/models/supplier.dart';
import 'package:http/http.dart' as http;
import 'package:gestion_stock/models/user.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<User?> getUser(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/Users/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      print('Failed to load user');
      return null;
    }
  }

  Future<bool> login(String UserName, String PasswordHash) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'UserName': UserName,
        'PasswordHash': PasswordHash,
      }),
    );

    if (response.statusCode == 200) {
      // Assuming a successful login returns a token or a user object
      return true;
    } else {
      print('Login failed: ${response.body}');
      return false;
    }
  }

  Future<Admin?> getAdmin(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/Admins/$id'));

    if (response.statusCode == 200) {
      return Admin.fromJson(json.decode(response.body));
    } else {
      print('Failed to load admin');
      return null;
    }
  }

  Future<bool> admin(String AdminName, String PasswordHash) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Admins/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'AdminName': AdminName,
        'PasswordHash': PasswordHash,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Login failed: ${response.body}');
      return false;
    }
  }

  Future<bool> registerAd(String AdminName, String PasswordHash) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Admins/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'AdminName': AdminName,
        'PasswordHash': PasswordHash,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Registration failed: ${response.body}');
      return false;
    }
  }

  Future<bool> register(String UserName, String PasswordHash) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Users/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'UserName': UserName,
        'PasswordHash': PasswordHash,
      }),
    );

    if (response.statusCode == 201) {
      // Assuming a successful registration returns a 201 Created status
      return true;
    } else {
      print('Registration failed: ${response.body}');
      return false;
    }
  }

  Future<bool> addSupplier(Map<String, String> supplierData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/suppliers'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(supplierData),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to add supplier: ${response.body}');
      return false;
    }
  }

  Future<List<Supplier>> getSuppliers() async {
    final response = await http.get(Uri.parse('$baseUrl/api/suppliers'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((supplier) {
        return Supplier.fromJson({
          'supplierId': supplier['supplierId'] ?? 0, // Utiliser 0 si null
          'supplierName': supplier['supplierName'] ?? 'Inconnu',
          'supplierFirstName': supplier['supplierFirstName'] ?? 'Inconnu',
          'supplierAddress': supplier['supplierAddress'] ?? 'Inconnu',
          'phone': int.parse(supplier['phone'].toString()) ?? 'Inconnu',
          'price': double.tryParse(supplier['price'].toString()) ?? 0.0,
        });
      }).toList();
    } else {
      print('Failed to load suppliers: ${response.body}');
      return [];
    }
  }

  Future<bool> deleteSupplier(int supplierId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/suppliers/$supplierId'),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateSupplier(
      int supplierId, Map<String, dynamic> supplierData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/suppliers/$supplierId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(supplierData),
    );

    return response.statusCode == 200;
  }

  Future<bool> softDeleteSupplier(int supplierId) async {
    final response = await http.put(
      Uri.parse(
          'http://localhost:5009/api/Suppliers/SoftDeleteSupplier/$supplierId'),
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> softDeleteCategory(int categoryId) async {
    final response = await http.put(
      Uri.parse(
          'http://localhost:5009/api/Categories/SoftDeleteCategory/$categoryId'),
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}
