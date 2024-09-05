import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestion_stock/services/api_service.dart';
import 'package:gestion_stock/widgets/logoPainter.dart';
import 'package:gestion_stock/widgets/password_field.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminLog extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<AdminLog> {
  final ApiService apiService = ApiService(baseUrl: 'http://localhost:5009');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _admin() async {
    String name = _nameController.text;
    String password = _passwordController.text;

    bool success = await apiService.admin(name, password);

    if (success) {
      Navigator.pushNamed(context, '/acceuil');
    } else {
      // Navigator.pushNamed(context, '/acceuil');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Admin failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: ClipRRect(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFF84b6e0),
                    Color(0xFF343aa2),
                  ]),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomPaint(
                        painter: LogoPainter(),
                        size: const Size(400, 200),
                      ),
                      Icon(
                        Icons.storefront,
                        size: 100,
                        color: Color.fromARGB(255, 30, 28, 185),
                      ),
                      Text(
                        'GESTION DE STOCK',
                        style: GoogleFonts.montserrat(
                          color: Colors.pink,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    child: Text(
                      'Connexion',
                      style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Connectez-vous pour démarrer une nouvelle session.',
                    style: GoogleFonts.montserrat(fontSize: 16),
                  ),
                  SizedBox(height: 32),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Votre nom',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  PasswordField(controller: _passwordController),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 23, 71, 203),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    ),
                    onPressed: _admin,
                    child: Text(
                      'Connexion',
                      style: GoogleFonts.montserrat(
                          fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
