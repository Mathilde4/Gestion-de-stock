import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CustomPaint(
            size: const Size(400, 200),
            painter: LogoPainter(),
          ),
        ),
      ),
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Dessiner les petits bâtons pour la forme de l'Afrique
    final Paint stickPaint = Paint()
      ..color = Colors.pinkAccent
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // Position des bâtons pour créer une forme stylisée de l'Afrique
    final List<Offset> points = [
      Offset(width * 0.1, height * 0.3),
      Offset(width * 0.1, height * 0.4),
      Offset(width * 0.1, height * 0.5),
      Offset(width * 0.15, height * 0.3),
      Offset(width * 0.2, height * 0.35),
      Offset(width * 0.15, height * 0.4),
      Offset(width * 0.15, height * 0.5),
      Offset(width * 0.2, height * 0.5),
      Offset(width * 0.25, height * 0.3),
      Offset(width * 0.25, height * 0.4),
      Offset(width * 0.25, height * 0.5),
    ];

    // Dessiner les bâtons
    

    

    // Dessiner le texte "AFRIK"
    final TextPainter textPainterAfrik = TextPainter(
      text: TextSpan(
        text: 'AFRIK',
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainterAfrik.layout(minWidth: 0, maxWidth: size.width);
    textPainterAfrik.paint(canvas, Offset(width * 0.3, height * 0.2));

    // Dessiner le texte "CRÉANCES"
    final TextPainter textPainterCreances = TextPainter(
      text: TextSpan(
        text: 'CRÉANCES',
        style: TextStyle(
          color: Colors.pinkAccent,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainterCreances.layout(minWidth: 0, maxWidth: size.width);
    textPainterCreances.paint(canvas, Offset(width * 0.3, height * 0.4));

    // Dessiner le texte "HOLDING"
    final TextPainter textPainterHolding = TextPainter(
      text: TextSpan(
        text: 'HOLDING',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 20,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainterHolding.layout(minWidth: 0, maxWidth: size.width);
    textPainterHolding.paint(canvas, Offset(width * 0.4, height * 0.6));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
