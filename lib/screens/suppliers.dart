// ignore_for_file: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_stock/models/supplier.dart';
import 'package:gestion_stock/services/api_service.dart';
import 'package:gestion_stock/widgets/design.dart';

class SuppliersPage extends StatefulWidget {
  @override
  _SuppliersPageState createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  late Future<List<Supplier>> futureSuppliers;

  final ApiService apiService = ApiService(baseUrl: 'http://localhost:5009');

  @override
  void initState() {
    super.initState();
    futureSuppliers = apiService.getSuppliers();
  }

  Future<void> _addSupplier() async {
    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs obligatoires'),
        ),
      );
      return;
    }

    bool success = await apiService.addSupplier({
      'SupplierName': _nameController.text,
      'SupplierFirstName': _firstNameController.text,
      'SupplierAddress': _addressController.text,
      'phone': _phoneController.text,
      'price': _priceController.text,
    });

    if (success) {
      _clearFields();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fournisseur ajouté avec succès.'),
        ),
      );
      setState(() {
        futureSuppliers =
            apiService.getSuppliers(); // Refresh the supplier list
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: Impossible d\'ajouter le fournisseur.'),
        ),
      );
    }
  }

  Future<void> _editSupplier(Supplier supplier) async {
    _nameController.text = supplier.SupplierName;
    _firstNameController.text = supplier.SupplierFirstName;
    _addressController.text = supplier.SupplierAddress;
    _phoneController.text = supplier.phone.toString();
    _priceController.text = supplier.price.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Modifier le fournisseur',
            selectionColor: Colors.blue,
          ),
          content: SingleChildScrollView(
            child: Column(
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
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Adresse',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Téléphone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Prix',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Sauvegarder'),
              onPressed: () async {
                // Update the supplier data
                bool success = await apiService.updateSupplier(
                  supplier
                      .SupplierId!, // Using the SupplierId for identification
                  {
                    'SupplierName': _nameController.text,
                    'SupplierFirstName': _firstNameController.text,
                    'SupplierAddress': _addressController.text,
                    'phone': _phoneController.text,
                    'price': _priceController.text,
                  },
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Fournisseur modifié avec succès.')),
                  );
                  setState(() {
                    futureSuppliers = apiService.getSuppliers();
                  });
                  Navigator.of(context).pop();
                  _clearFields();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Erreur: Impossible de modifier le fournisseur.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  List<Supplier> _suppliersList = [];

  Future<void> fetchSuppliers() async {
    final response =
        await http.get(Uri.parse('http://localhost:5009/api/suppliers'));

    if (response.statusCode == 200) {
      final List<dynamic> suppliersJson = jsonDecode(response.body);

      // Convertir en liste de fournisseurs
      List<Supplier> allSuppliers =
          suppliersJson.map((json) => Supplier.fromJson(json)).toList();

      // Filtrer les fournisseurs non supprimés
      setState(() {
        _suppliersList =
            allSuppliers.where((supplier) => !supplier.isDeleted).toList();
      });
    } else {
      throw Exception("Failed to load suppliers");
    }
  }

  Future<void> _deleteSupplier(int supplierId) async {
    bool success = await apiService.softDeleteSupplier(supplierId);

    if (success) {
      setState(() {
        futureSuppliers = futureSuppliers.then((suppliers) =>
            suppliers.where((s) => s.SupplierId != supplierId).toList());
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fournisseur supprimé avec succès.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: Impossible de supprimer le fournisseur.'),
        ),
      );
    }
  }

  void _clearFields() {
    _nameController.clear();
    _firstNameController.clear();
    _addressController.clear();
    _phoneController.clear();
    _priceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fournisseurs'),
        backgroundColor: Color.fromARGB(255, 30, 28, 185),
      ),
      body: SafeArea(
        child: CustomPaint(
          painter: CirclePainter(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
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
                            child: Text("Gestion des Fournisseurs",
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
                                "Ici vous pouvez ajoutez, modifier ou supprimer un fournisseur",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 105, 104, 149),
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
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 450,
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        labelText: 'Nom *',
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
                                      controller: _firstNameController,
                                      decoration: InputDecoration(
                                        labelText: 'Prénom',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Veuillez entrer le prénom';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    TextFormField(
                                      controller: _addressController,
                                      decoration: InputDecoration(
                                        labelText: 'Adresse *',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Veuillez entrer l'adresse";
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    TextFormField(
                                      controller: _phoneController,
                                      decoration: InputDecoration(
                                        labelText: 'Téléphone*',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Veuillez entrer le numéro de telephone';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    TextFormField(
                                      controller: _priceController,
                                      decoration: InputDecoration(
                                        labelText: 'Prix *',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Veuillez entrer le prix fixé';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: _addSupplier,
                                    child: Text('Ajouter le fournisseur'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                FutureBuilder<List<Supplier>>(
                  future: futureSuppliers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erreur: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Aucun fournisseur trouvé.'));
                    } else {
                      return Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Card(
                            elevation: 12,
                            color: Colors.white,
                            child: DataTable(
                              columns: const <DataColumn>[
                                DataColumn(label: Text('ID')),
                                DataColumn(label: Text('Nom')),
                                DataColumn(label: Text('Prénom')),
                                DataColumn(label: Text('Adresse')),
                                DataColumn(label: Text('Téléphone')),
                                DataColumn(label: Text('Prix')),
                                DataColumn(label: Text('Actions')),
                              ],
                              rows: snapshot.data!.map((supplier) {
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                        Text(supplier.SupplierId.toString())),
                                    DataCell(Text(supplier.SupplierName)),
                                    DataCell(Text(supplier.SupplierFirstName)),
                                    DataCell(Text(supplier.SupplierAddress)),
                                    DataCell(Text(supplier.phone.toString())),
                                    DataCell(Text(
                                        supplier.price.toStringAsFixed(2))),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            color: Color.fromARGB(
                                                255, 17, 12, 156),
                                            icon: Icon(Icons.edit),
                                            onPressed: () =>
                                                _editSupplier(supplier),
                                          ),
                                          IconButton(
                                            color: Color.fromARGB(
                                                255, 156, 12, 12),
                                            icon: Icon(Icons.delete),
                                            onPressed: () => _deleteSupplier(
                                                supplier.SupplierId!),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
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
    );
  }
}
