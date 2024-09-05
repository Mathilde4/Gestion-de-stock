import 'package:flutter/material.dart';
import 'package:gestion_stock/widgets/design.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Future<List<Map<String, dynamic>>> futureCategories;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureCategories = _getCategories(); // Initialize it in initState
  }

  Future<void> _addCategory() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir le champ'),
        ),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://localhost:5009/api/categories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'catName': _nameController.text,
      }),
    );

    if (response.statusCode == 201) {
      _nameController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Catégorie ajoutée avec succès.'),
        ),
      );
      setState(() {});
      _clearFields;
    } else {
      print('Failed to add category: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> _getCategories() async {
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

  Future<void> _editCategory(Map<String, dynamic> category) async {
    _nameController.text = category['catName'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Modifier la catégorie"),
          content: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Nom",
              iconColor: Color.fromARGB(255, 231, 18, 146),
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Sauvegarder"),
              onPressed: () async {
                final response = await http.put(
                  Uri.parse(
                      'http://localhost:5009/api/categories/${category['categoryId']}'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String>{
                    'categoryId': category['categoryId'].toString(),
                    'catName': _nameController.text,
                  }),
                );

                if (response.statusCode == 204) {
                  Navigator.of(context).pop();
                  _nameController.clear();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Catégorie modifiée avec succès.')),
                  );
                } else {
                  print('Failed to update category: ${response.body}');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCategory(int categoryId) async {
    final response = await http.put(
      Uri.parse(
          'http://localhost:5009/api/Categories/SoftDeleteCategory/$categoryId'),
    );

    if (response.statusCode == 204) {
      setState(() {
        futureCategories = _getCategories().then((categories) =>
            categories.where((c) => c['CategoryId'] != categoryId).toList());
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catégorie supprimée avec succès.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: Impossible de supprimer la catégorie.'),
        ),
      );
    }
  }

  Widget _buildCategoriesTable(List<Map<String, dynamic>> categories) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Card(
          elevation: 12,
          color: Colors.white,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Categorie')),
              DataColumn(label: Text('Actions')), // Colonne pour les actions
            ],
            rows: categories.map((category) {
              return DataRow(cells: [
                DataCell(Text(category['catName'])),
                DataCell(Row(
                  children: [
                    IconButton(
                      color: Color.fromARGB(255, 12, 26, 156),
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editCategory(
                            category); // Appel de la méthode pour modifier
                      },
                    ),
                    IconButton(
                      color: Color.fromARGB(255, 156, 12, 12),
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteCategory(category[
                            'categoryId']); // Appel de la méthode pour supprimer
                      },
                    ),
                  ],
                )),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _clearFields() {
    _nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(color: Colors.blueAccent, child: Text("Categorie")),
        backgroundColor: Color.fromARGB(255, 30, 28, 185),
      ),
      body: Column(
        children: [
          SafeArea(
            child: Container(
              child: CustomPaint(
                painter: CirclePainter(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  child: Text("Gestion des Catégories",
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
                                      "Ici vous pouvez ajouter, modifier et supprimer une catégorie",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 127, 126, 188),
                                        fontSize: 16,
                                      )),
                                ),
                              )),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 300,
                            child: Card(
                              color: Colors.white,
                              elevation: 12,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Nom de la catégorie",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    TextFormField(
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        labelText: "Nom",
                                        iconColor:
                                            Color.fromARGB(255, 18, 25, 231),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: _addCategory,
                                      child: Text(
                                        "Ajouter une Catégorie",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 26, 6, 247)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FutureBuilder<List<Map<String, dynamic>>>(
                                future: _getCategories(),
                                builder: ((context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Erreur: ${snapshot.error}'));
                                  } else {
                                    return _buildCategoriesTable(
                                        snapshot.data ?? []);
                                  }
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
