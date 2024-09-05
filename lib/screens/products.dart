import 'package:flutter/material.dart';
import 'package:gestion_stock/widgets/design.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gestion_stock/models/productRequest.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  late Future<List<Map<String, dynamic>>> futureProducts;

  String? _selectedCategory;
  List<String> _categories = [];
  int? _editingProductId;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    futureProducts = _getProducts();
  }

  Future<void> _fetchCategories() async {
    final response = await http.get(
      Uri.parse('http://localhost:5009/api/categories'),
    );

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

  Future<void> _addProduct() async {
    if (_selectedCategory == null ||
        _nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        double.tryParse(_priceController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Veuillez remplir tous les champs obligatoires avec des valeurs valides'),
        ),
      );
      return;
    }

    final productData = jsonEncode(<String, dynamic>{
      'productName': _nameController.text,
      'productDescription': _descriptionController.text,
      'price': double.parse(_priceController.text),
      'catName': _selectedCategory!,
    });

    final response = await http.post(
      Uri.parse('http://localhost:5009/api/products'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: productData,
    );

    if (response.statusCode == 201) {
      _clearForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produit ajouté avec succès.')),
      );
      setState(() {
        futureProducts = _getProducts();
      });
    } else {
      print('Failed to add product: ${response.body}');
    }
  }

  Future<void> _updateProduct(ProductRequest productRequest) async {
    if (_selectedCategory == null ||
        _nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        double.tryParse(_priceController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Veuillez remplir tous les champs obligatoires avec des valeurs valides'),
        ),
      );
      return;
    }

    final productData = jsonEncode(<String, dynamic>{
      'productId': productRequest.productId,
      'productName': _nameController.text,
      'productDescription': _descriptionController.text,
      'price': double.parse(_priceController.text),
      'catName': _selectedCategory!,
    });

    final response = await http.put(
      Uri.parse('http://localhost:5009/api/Products/ModifyProduct'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: productData,
    );

    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Produit mis à jour avec succès.'),
        ),
      );
      setState(() {
        futureProducts =
            _getProducts(); // Recharger la liste des produits après mise à jour
      });
      Navigator.of(context).pop();
      _clearForm();
    } else {
      print('Failed to update product: ${response.body}');
    }
  }

  Future<void> _deleteProduct(int productId) async {
    final response = await http.put(
      Uri.parse(
          'http://localhost:5009/api/Products/SoftDeleteProduct/$productId'),
    );

    if (response.statusCode == 204) {
      setState(() {
        futureProducts = _getProducts().then((products) =>
            products.where((p) => p['ProductId'] != productId).toList());
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Produit supprimé avec succès.'),
        ),
      );
    } else {
      print('Failed to delete product: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la suppression du produit.'),
        ),
      );
    }
  }

  Future<List<Map<String, dynamic>>> _getProducts() async {
    final response = await http.get(
      Uri.parse('http://localhost:5009/api/products'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      print('Failed to load products: ${response.body}');
      return [];
    }
  }

  String? _validateFields() {
    if (_nameController.text.isEmpty) {
      return 'Le champ "Nom" est obligatoire.';
    } else if (_priceController.text.isEmpty ||
        double.tryParse(_priceController.text) == null) {
      return 'Veuillez entrer un prix valide.';
    } else if (_selectedCategory == null) {
      return 'Veuillez sélectionner une catégorie.';
    }
    return null;
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _editProduct(Map<String, dynamic> product) {
    setState(() {
      _nameController.text = product['productName'];
      _descriptionController.text = product['productDescription'];
      _priceController.text = product['price'].toString();
      _selectedCategory = product['catName'];
      _editingProductId = product['productId'];
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier le produit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Prix',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Catégorie',
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
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateProduct(ProductRequest(
                    productId: _editingProductId,
                    productName: _nameController.text,
                    productDescription: _descriptionController.text,
                    price: double.parse(_priceController.text),
                    catName: _selectedCategory!));
                setState(() {
                  futureProducts; // Recharger la liste des produits après mise à jour
                });
                Navigator.of(context).pop();
                _clearForm();
              },
              child: Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    _editingProductId = null;
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _selectedCategory = null;
  }

  String _formatPrice(dynamic price) {
    if (price is int || price is double) {
      return price.toStringAsFixed(2);
    } else if (price is String && double.tryParse(price) != null) {
      return double.parse(price).toStringAsFixed(2);
    } else {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produits'),
        backgroundColor: Color.fromARGB(255, 30, 28, 185),
      ),
      body: SafeArea(
        child: CustomPaint(
          painter: CirclePainter(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                              child: Text("Gestion des Produits",
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
                              child: Text(
                                  "Ici vous pouvez ajouter, modifier et supprimer un produit",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 118, 117, 183),
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
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Nom',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer le nom';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: _descriptionController,
                                  decoration: InputDecoration(
                                    labelText: 'Description',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: _priceController,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  decoration: InputDecoration(
                                    labelText: 'Prix',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer le prix que vous avez fixé';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: _selectedCategory,
                                  decoration: InputDecoration(
                                    labelText: 'Catégorie',
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
                                    });
                                  },
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _addProduct,
                                  child: Text('Enregistrer'),
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
                    future: _getProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Erreur : ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('Aucun produit disponible.');
                      } else {
                        return Container(
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Card(
                                elevation: 12,
                                color: Colors.white,
                                child: DataTable(
                                  columns: [
                                    DataColumn(label: Text('Produit')),
                                    DataColumn(label: Text('Description')),
                                    DataColumn(label: Text('Catégorie')),
                                    DataColumn(label: Text('Prix')),
                                    DataColumn(label: Text('Actions')),
                                  ],
                                  rows: snapshot.data!
                                      .map(
                                        (product) => DataRow(cells: [
                                          DataCell(
                                              Text(product['productName'])),
                                          DataCell(Text(
                                              product['productDescription'])),
                                          DataCell(Text(product['catName'])),
                                          DataCell(Text(
                                              _formatPrice(product['price']))),
                                          DataCell(Row(
                                            children: [
                                              IconButton(
                                                color: Color.fromARGB(
                                                    255, 12, 26, 156),
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  _editProduct(product);
                                                },
                                              ),
                                              IconButton(
                                                color: Color.fromARGB(
                                                    255, 156, 12, 12),
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  _deleteProduct(
                                                      product['productId']);
                                                },
                                              ),
                                            ],
                                          )),
                                        ]),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
