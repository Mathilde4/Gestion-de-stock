import 'package:flutter/material.dart';
import 'package:gestion_stock/widgets/password_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gestion_stock/services/api_service.dart';
import 'package:gestion_stock/widgets/logoPainter.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ApiService apiService = ApiService(baseUrl: 'http://localhost:5009');

  void _registerAd() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      // Show error if passwords don't match
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }

    try {
      bool success = await apiService.registerAd(
        _nameController.text,
        _passwordController.text,
      );

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inscription réussie !')),
        );

        _nameController.clear();
         _passwordController.clear();
         _confirmPasswordController.clear();
        
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de l\'inscription')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
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
                        color: Color.fromARGB(255, 210, 50, 125),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                  Text(
                    'Inscription',
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Créer un nouveau compte.',
                    style: GoogleFonts.montserrat(fontSize: 16),
                  ),
                  SizedBox(height: 32),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  PasswordField(
                    controller: _passwordController,
                  ),
                  SizedBox(height: 16),
                  PasswordField(
                    labelText: 'Confirmez le mot de passe',
                    controller: _confirmPasswordController,
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 23, 71, 203),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    ),
                    onPressed: _registerAd, // Call the register method
                    child: Text(
                      'Inscription',
                      style: GoogleFonts.montserrat(
                          fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                         Navigator.pushNamed(context, '/admin');
                        },
                        child: Text(
                          'Retour',
                          style: GoogleFonts.montserrat(
                            color: Color.fromARGB(255, 56, 108, 250),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
