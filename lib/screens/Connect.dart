import 'package:flutter/material.dart';
import 'package:gestion_stock/screens/Acceuil.dart';
import 'package:gestion_stock/widgets/backgroundPaint.dart';
import 'package:gestion_stock/widgets/design.dart';

class Connect extends StatefulWidget {
  const Connect({super.key});

  @override
  State<Connect> createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0072ff),
                Color(0xFF32325d),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CustomPaint(
            painter: CirclePainter(),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Centre les cards horizontalement
                  children: [
                    SizedBox(
                      width: 150, // Réduit la largeur des cards
                      child: Card(
                        color: Colors.white,
                        elevation: 12,
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Minimise la hauteur
                          children: [
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "Admin",
                                style: TextStyle(
                                    fontSize: 18, // Réduit la taille du texte
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/admin');
                                },
                                child: Text('connexion'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16), // Ajoute un espacement entre les cards
                    SizedBox(
                      width: 160, // Réduit la largeur des cards
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 12,
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min, // Minimise la hauteur
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  "User",
                                  style: TextStyle(
                                      fontSize: 18, // Réduit la taille du texte
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  child: Text('connexion'),
                                ),
                              ),
                            ],
                          ),
                        ),
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
