import 'package:flutter/material.dart';
import 'package:gestion_stock/widgets/BackgroundPainter.dart';
import 'package:gestion_stock/widgets/logoPainter.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 10), () {
      Navigator.pushReplacementNamed(context, '/connect');
    });
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
                      Icon(
                        Icons.storefront,
                        size: 100,
                        color: Color.fromARGB(255, 30, 28, 185),
                      ),
                      Text(
                        "LEADER DE L'INTERMEDIATION",
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
        ],
      ),
    );
  }
}
