import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_stock/screens/Connect.dart';
import 'package:gestion_stock/screens/categories.dart';
import 'package:gestion_stock/screens/products.dart';
import 'package:gestion_stock/screens/stats.dart';
import 'package:gestion_stock/screens/suppliers.dart';
import 'package:gestion_stock/widgets/TotalComparisonChart.dart';
import 'package:http/http.dart' as http;
import 'package:gestion_stock/widgets/design.dart';

class AcceuilPage extends StatefulWidget {
  @override
  _AcceuilPageState createState() => _AcceuilPageState();
}

class _AcceuilPageState extends State<AcceuilPage> {
  late Future<double> totalPurchase;
  late Future<double> totalSales;
  final TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _editAdmin(Map<String, dynamic> admin) async {
    _nameController.text = admin['adminName'];
    _passwordController = admin['passwordHash'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Modifier l'administrateur"),
          content: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Nom",
                  iconColor: Color.fromARGB(255, 231, 18, 146),
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  iconColor: Color.fromARGB(255, 231, 18, 146),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
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
                      'http://localhost:5009/api/admins/${admin['adminId']}'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String>{
                    'adminId': admin['adminId'].toString(),
                    'adminName': _nameController.text,
                  }),
                );

                if (response.statusCode == 204) {
                  Navigator.of(context).pop();
                  _nameController.clear();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('administrateur modifiée avec succès.')),
                  );
                } else {
                  print('Failed to update admin: ${response.body}');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _editUser(Map<String, dynamic> user) async {
    _nameController.text = user['userName'];
    _passwordController = user['passwordHash'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Modifier l'utilisateur"),
          content: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Nom",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
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
                      'http://localhost:5009/api/users/${user['userId']}'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String>{
                    'userId': user['userId'].toString(),
                    'userName': _nameController.text,
                  }),
                );

                if (response.statusCode == 204) {
                  Navigator.of(context).pop();
                  _nameController.clear();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('utilisateur modifiée avec succès.')),
                  );
                } else {
                  print('Failed to update user: ${response.body}');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAdmin(int adminId) async {
    final response = await http.delete(
      Uri.parse('http://localhost:5009/api/admins/$adminId'),
    );

    if (response.statusCode == 204) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Admin supprimé avec succès.')),
      );
    } else {
      print('Failed to delete admin: ${response.body}');
    }
  }

  Future<void> _deleteUser(int userId) async {
    final response = await http.delete(
      Uri.parse('http://localhost:5009/api/users/$userId'),
    );

    if (response.statusCode == 204) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('user supprimé avec succès.')),
      );
    } else {
      print('Failed to delete user: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> _getAdmins() async {
    final response = await http.get(
      Uri.parse('http://localhost:5009/api/admins'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      print('Failed to load admins: ${response.body}');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getUsers() async {
    final response = await http.get(
      Uri.parse('http://localhost:5009/api/users'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      print('Failed to load users: ${response.body}');
      return [];
    }
  }

  Widget _buildAdminsTable(List<Map<String, dynamic>> admins) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Center(
          child: Card(
            elevation: 12,
            color: Colors.white,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Administrateurs')),
                DataColumn(label: Text('Actions')),
              ],
              rows: admins.map((admin) {
                return DataRow(cells: [
                  DataCell(Text(admin['adminName'])),
                  DataCell(Row(
                    children: [
                      IconButton(
                        color: Color.fromARGB(255, 156, 12, 12),
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteAdmin(admin[
                              'adminId']); // Appel de la méthode pour supprimer
                        },
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsersTable(List<Map<String, dynamic>> users) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Center(
          child: Card(
            elevation: 12,
            color: Colors.white,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Utilisateurs')),
                DataColumn(label: Text('Actions')), 
              ],
              rows: users.map((user) {
                return DataRow(cells: [
                  DataCell(Text(user['userName'])),
                  DataCell(Row(
                    children: [
                      IconButton(
                        color: Color.fromARGB(255, 156, 12, 12),
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteUser(user[
                              'userId']); 
                        },
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    totalPurchase = fetchTotalPurchase();
    totalSales = fetchTotalSales();
  }

  Future<double> fetchTotalPurchase() async {
    final response = await http.get(
        Uri.parse('http://localhost:5009/api/purchases/GetTotalPurchasePrice'));
    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception('Failed to load total purchase');
    }
  }

  Future<double> fetchTotalSales() async {
    final response = await http
        .get(Uri.parse('http://localhost:5009/api/sales/GetTotalSales'));
    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception('Failed to load total sales');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acceuil'),
        backgroundColor: Color.fromARGB(255, 30, 28, 185),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: SafeArea(
          child: CustomPaint(
            painter: CirclePainter(),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
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
                              child: Text(
                                  "Gestion des utilisateurs et administrateur de l'application",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 30, 28, 185),
                                    fontSize: 25,
                                  )),
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
                                color: Colors.white,
                                child: Text(
                                  "Vous pouvez créer des utilisateurs at d'autres administrateurs ou en supprimer. ",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 125, 125, 160),
                                    fontSize: 16,
                                  ),
                                ),
                              )),
                        ]),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: Card(
                                color: Colors.white,
                                elevation: 12,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        "créer un compte utilisateur",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/signup');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(
                                                255, 30, 28, 185),
                                          ),
                                          child: Text(
                                            "Créer",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: Card(
                                color: Colors.white,
                                elevation: 12,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        "créer un compte d'admin",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/register');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(
                                                255, 156, 12, 12),
                                          ),
                                          child: Text(
                                            "Créer",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 185, 103, 103),
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: FutureBuilder<List<Map<String, dynamic>>>(
                              future: _getAdmins(),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Erreur: ${snapshot.error}'));
                                } else {
                                  return _buildAdminsTable(snapshot.data ?? []);
                                }
                              }),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: FutureBuilder<List<Map<String, dynamic>>>(
                              future: _getUsers(),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Erreur: ${snapshot.error}'));
                                } else {
                                  return _buildUsersTable(snapshot.data ?? []);
                                }
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 47, 33, 243),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
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
                MaterialPageRoute(builder: (context) => AcceuilPage()),
              );
            },
          ),
          ListTile(
            iconColor: Color.fromARGB(255, 30, 28, 185),
            textColor: Color.fromARGB(255, 30, 28, 185),
            leading: Icon(Icons.people),
            title: Text('Fournisseur'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SuppliersPage()),
              );
            },
          ),
          ListTile(
            iconColor: Color.fromARGB(255, 30, 28, 185),
            textColor: Color.fromARGB(255, 30, 28, 185),
            leading: Icon(Icons.add_box),
            title: Text('Produits'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductsPage()),
              );
            },
          ),
          ListTile(
            iconColor: Color.fromARGB(255, 30, 28, 185),
            textColor: Color.fromARGB(255, 30, 28, 185),
            leading: Icon(Icons.category),
            title: Text('Categories'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoriesPage()),
              );
            },
          ),
          ListTile(
            iconColor: Color.fromARGB(255, 30, 28, 185),
            textColor: Color.fromARGB(255, 30, 28, 185),
            leading: Icon(Icons.bar_chart),
            title: Text('Stats'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatsPage()),
              );
            },
          ),
          ListTile(
            iconColor: Color.fromARGB(255, 30, 28, 185),
            textColor: Color.fromARGB(255, 30, 28, 185),
            leading: Icon(Icons.logout),
            title: Text('deconexion'),
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
