import 'package:flutter/material.dart';
import 'package:gestion_stock/widgets/design.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gestion_stock/services/productService.dart';

class PurchasesPage extends StatefulWidget {
  @override
  _PurchasesPageState createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage> {
  final ProductService _productService = ProductService(); 
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();

  String? _selectedCategory;
  String? _selectedProduct;
  String? _selectedSupplier;
  List<String> _categories = [];
  List<String> _products = [];
  List<String> _suppliers = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchSuppliers();
  }

  Future<void> _fetchCategories() async {
    final response =
        await http.get(Uri.parse('http://localhost:5009/api/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> categories = json.decode(response.body);
      setState(() {
        _categories = categories
            .map((category) => category['catName'].toString())
            .toList();
      });
    } else {
      print('Failed to load categories: ${response.body}');
    }
  }

  Future<void> _fetchProducts(String category) async {
    final response = await http.get(
        Uri.parse('http://localhost:5009/api/products?category=$category'));

    if (response.statusCode == 200) {
      final List<dynamic> products = json.decode(response.body);
      setState(() {
        _products = products
            .map((product) => product['productName'].toString())
            .toList();
      });
    } else {
      print('Failed to load products: ${response.body}');
    }
  }

  Future<void> _fetchSuppliers() async {
    final response =
        await http.get(Uri.parse('http://localhost:5009/api/suppliers'));

    if (response.statusCode == 200) {
      final List<dynamic> suppliers = json.decode(response.body);
      setState(() {
        _suppliers = suppliers
            .map((supplier) => supplier['supplierName'].toString())
            .toList();
      });
    } else {
      print('Failed to load suppliers: ${response.body}');
    }
  }

  Future<void> _fetchUnitPrice(String supplierName) async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:5009/api/purchases/GetPriceBySupplier/$supplierName'),
    );

    if (response.statusCode == 200) {
      final price = json.decode(response.body);
      setState(() {
        _unitPriceController.text = price.toString();
      });
    } else {
      setState(() {
        _unitPriceController.text = 'N/A';
      });
    }
  }

  Future<void> _addPurchase() async {
    if (_selectedCategory == null ||
        _selectedProduct == null ||
        _selectedSupplier == null ||
        _quantityController.text.isEmpty ||
        _unitPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Veuillez remplir tous les champs obligatoires')),
      );
      return;
    }

    final currentDate = DateTime.now();

    final response = await http.post(
      Uri.parse('http://localhost:5009/api/purchases'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'productName': _selectedProduct!,
        'catName': _selectedCategory!,
        'quantity': int.parse(_quantityController.text),
        'unitPrice': double.parse(_unitPriceController.text),
        'date': currentDate.toIso8601String(),
        'supplierName': _selectedSupplier!,
      }),
    );

    if (response.statusCode == 201) {
      _quantityController.clear();
      _unitPriceController.clear();
      setState(() {
        _selectedCategory = null;
        _selectedProduct = null;
        _selectedSupplier = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Achat ajouté avec succès.')),
      );
    } else {
      print('Failed to add purchase: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> _getPurchases() async {
    final response = await http.get(
      Uri.parse('http://localhost:5009/api/purchases'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      print('Failed to load purchases: ${response.body}');
      return [];
    }
  }

  Widget _buildPurchasesTable(List<Map<String, dynamic>> purchases) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Card(
          elevation: 12,
          color: Colors.white,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Produit')),
              DataColumn(label: Text('Catégorie')),
              DataColumn(label: Text('Quantité')),
              DataColumn(label: Text('Prix Unitaire')),
              DataColumn(label: Text('Total')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Nom du Fournisseur')),
            ],
            rows: purchases.map((purchase) {
              double quantity = double.parse(purchase['quantity'].toString());
              double unitPrice = double.parse(purchase['unitPrice'].toString());
              double total = quantity * unitPrice;
              return DataRow(cells: [
                DataCell(Text(purchase['productName'])),
                DataCell(Text(purchase['catName'])),
                DataCell(Text(purchase['quantity'].toString())),
                DataCell(Text(purchase['unitPrice'].toString())),
                DataCell(Text(total.toStringAsFixed(2))),
                DataCell(Text(purchase['date'])),
                DataCell(Text(purchase['supplierName'])),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchProduct(String category) async {
    final response = await http.get(Uri.parse(
        'http://localhost:5009/api/products/Getonly?categoryName=$category'));

    if (response.statusCode == 200) {
      final List<dynamic> products = json.decode(response.body);
      setState(() {
        _products = products
            .map((product) => product['productName'].toString())
            .toList();
      });
    } else {
      print('Failed to load products: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajout de stock'),
        backgroundColor: Color.fromARGB(255, 30, 28, 185),
      ),
      body: SafeArea(
        child: CustomPaint(
          painter: CirclePainter(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                 Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.white,
                            child: Center(
                              child: Text("Enregistrement d'un ajout de stock",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 30, 28, 185),
                                    fontSize: 25,
                                  )),
                            ),
                          )),
                    ],
                  ),
                   Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            
                            child: Center(
                              child: Text("Vous pouver enregistrer un ajout de stock",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 112, 111, 156),
                                    fontSize: 16,
                                  )),
                            ),
                          )),
                    ],
                  ),
                Row(
                  children: [
                    SizedBox(
                      width: 500,
                      child: Card(
                        elevation: 12,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                decoration: InputDecoration(
                                  labelText: 'Catégorie *',
                                  border: OutlineInputBorder(),
                                ),
                                items: _categories.map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCategory = newValue;
                                    _selectedProduct = null;
                                    _products.clear();
                                  });
                                  if (newValue != null) {
                                    _fetchProduct(newValue);
                                  }
                                },
                              ),
                              SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedProduct,
                                decoration: InputDecoration(
                                  labelText: 'Produit *',
                                  border: OutlineInputBorder(),
                                ),
                                items: _products.map((String product) {
                                  return DropdownMenuItem<String>(
                                    value: product,
                                    child: Text(product),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedProduct = newValue;
                                  });
                                },
                              ),
                              SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedSupplier,
                                decoration: InputDecoration(
                                  labelText: 'Fournisseur *',
                                  border: OutlineInputBorder(),
                                ),
                                items: _suppliers.map((String supplier) {
                                  return DropdownMenuItem<String>(
                                    value: supplier,
                                    child: Text(supplier),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedSupplier = newValue;
                                  });
                                  if (newValue != null) {
                                    _fetchUnitPrice(newValue);
                                  }
                                },
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: _quantityController,
                                decoration: InputDecoration(
                                  labelText: 'Quantité *',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer le prix fixé';
                                  }
                                  return null;
                                }, 
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: _unitPriceController,
                                decoration: InputDecoration(
                                  labelText: 'Prix unitaire *',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                readOnly: true,
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _addPurchase,
                                child: Text('Ajouter l\'achat'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _getPurchases(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erreur : ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Aucun achat trouvé.'));
                    } else {
                      return _buildPurchasesTable(snapshot.data!);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
