import 'package:flutter/material.dart';
import 'package:gestion_stock/models/InventoryResult.dart';
import 'package:gestion_stock/screens/Connect.dart';
import 'package:gestion_stock/screens/purchases.dart';
import 'package:gestion_stock/screens/sales.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gestion_stock/widgets/design.dart';

class AcceuilUsersPage extends StatefulWidget {
  @override
  _AcceuilUsersPageState createState() => _AcceuilUsersPageState();
}

class _AcceuilUsersPageState extends State<AcceuilUsersPage> {
  late Future<List<InventoryResult>> _inventory;
  final String baseUrl = "http://localhost:5009";

  @override
  void initState() {
    super.initState();
    _inventory = fetchInventory();
  }

  Future<List<InventoryResult>> fetchInventory() async {
    final response = await http.get(Uri.parse('$baseUrl/api/inventory'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => InventoryResult.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load inventory');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        backgroundColor: Color.fromARGB(255, 30, 28, 185),
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: CustomPaint(
          painter: CirclePainter(),
          child: SingleChildScrollView(
            child: Column(
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
                            child: Text("Consultation des produits en stock",
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
                                "Vous pouvez consulter les stock de chaque produits ici",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 87, 86, 115),
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
                    SafeArea(
                      child: CustomPaint(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: FutureBuilder<List<InventoryResult>>(
                              future: _inventory,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Erreur: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                      child: Text('Aucune donnée disponible'));
                                } else {
                                  return SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Card(
                                            elevation: 12,
                                            color: Colors.white,
                                            child: DataTable(
                                              columns: [
                                                DataColumn(
                                                    label: Text('Produit')),
                                                DataColumn(
                                                    label: Text('Catégorie')),
                                                DataColumn(
                                                    label: Text(
                                                        'Quantité en stock')),
                                              ],
                                              rows: snapshot.data!
                                                  .map((inventory) {
                                                return DataRow(cells: [
                                                  DataCell(Text(
                                                      inventory.productName)),
                                                  DataCell(Text(
                                                      inventory.categoryName)),
                                                  DataCell(Text(inventory
                                                      .remainingQuantity
                                                      .toString())),
                                                ]);
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFF84b6e0),
                Color(0xFF343aa2),
              ]),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            iconColor: Color.fromARGB(255, 30, 28, 185),
            textColor: Color.fromARGB(255, 30, 28, 185),
            leading: Icon(Icons.home),
            title: Text('Accueil'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AcceuilUsersPage()),
              );
            },
          ),
          ListTile(
            iconColor: Color.fromARGB(255, 30, 28, 185),
            textColor: Color.fromARGB(255, 30, 28, 185),
            leading: Icon(Icons.sell),
            title: Text('Ventes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SalesPage()),
              );
            },
          ),
          ListTile(
            iconColor: Color.fromARGB(255, 30, 28, 185),
            textColor: Color.fromARGB(255, 30, 28, 185),
            leading: Icon(Icons.shopping_cart),
            title: Text('Ajout de stock'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PurchasesPage()),
              );
            },
          ),
          ListTile(
            iconColor: Color.fromARGB(255, 30, 28, 185),
            textColor: Color.fromARGB(255, 30, 28, 185),
            leading: Icon(Icons.logout),
            title: Text('Déconnexion'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Connect()),
              );
            },
          ),
        ],
      ),
    );
  }
}
