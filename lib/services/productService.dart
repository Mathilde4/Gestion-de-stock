import 'package:http/http.dart' as http;
import 'dart:convert';


class ProductService {
  Future<List<Object>> fetchCategories() async {
     final response = await http.get(
      Uri.parse('http://localhost:5009/api/categories'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      print('Failed to load categories: ${response.body}');
      return [];
    }
  }

  Future<List<String>> fetchProducts(String category) async {
    // Implémentez la récupération des produits filtrés par catégorie
    // Ne renvoyez que les produits qui ne sont pas supprimés
    final response = await http.get(Uri.parse('http://localhost:5009/api/products'));
    if (response.statusCode == 200) {
      final List<dynamic> productData = json.decode(response.body);
      return productData
          .where((product) => !product['isDeleted']) // Filtrer les produits supprimés
          .map<String>((product) => product['productName'] as String)
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
