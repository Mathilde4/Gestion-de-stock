import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..style = PaintingStyle.fill;

    var shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2) // Couleur de l'ombre
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10); // Flou de l'ombre

    // Dessiner des ombres avant les cercles pour chaque cercle
    canvas.drawCircle(
        Offset(size.width * 0.1, size.height * 0.2),
        size.height * 0.15 + 5, // Légèrement plus grand pour l'ombre
        shadowPaint);

    canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.1),
        size.height * 0.1 + 5, // Légèrement plus grand pour l'ombre
        shadowPaint);

    canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.4),
        size.height * 0.4 + 5, // Légèrement plus grand pour l'ombre
        shadowPaint);

    canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.6),
        size.height * 0.2 + 5, // Légèrement plus grand pour l'ombre
        shadowPaint);

    // Dégradé linéaire pour le premier cercle
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF172BE8), // Bleu roi
        Color(0xFF0AE8F8), // Cyan
      ],
      stops: [0.5, 1.0], // Quantité égale des deux couleurs
    ).createShader(Rect.fromCircle(
      center: Offset(size.width * 0.1, size.height * 0.2),
      radius: size.height * 0.15,
    ));

    // Dessiner un grand cercle avec dégradé linéaire
    canvas.drawCircle(
        Offset(size.width * 0.1, size.height * 0.2), size.height * 0.15, paint);

    // Dégradé linéaire pour le deuxième cercle
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF172BE8),
        Color(0xFF0AE8F8),
      ],
      stops: [0.5, 1.0], // Quantité égale des deux couleurs
    ).createShader(Rect.fromCircle(
      center: Offset(size.width * 0.8, size.height * 0.1),
      radius: size.height * 0.1,
    ));

    // Dessiner un petit cercle avec dégradé linéaire
    canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.1), size.height * 0.1, paint);

    // Dégradé linéaire pour le troisième cercle
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF172BE8),
        Color(0xFF0AE8F8),
      ],
      stops: [0.5, 1.0], // Quantité égale des deux couleurs
    ).createShader(Rect.fromCircle(
      center: Offset(size.width * 0.8, size.height * 0.4),
      radius: size.height * 0.4,
    ));

    // Dessiner un grand cercle avec dégradé linéaire
    canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.4), size.height * 0.4, paint);

    // Dégradé linéaire pour le quatrième cercle
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF172BE8),
        Color(0xFF0AE8F8),
      ],
      stops: [0.5, 1.0], // Quantité égale des deux couleurs
    ).createShader(Rect.fromCircle(
      center: Offset(size.width * 0.5, size.height * 0.6),
      radius: size.height * 0.2,
    ));

    // Dessiner un autre cercle avec dégradé linéaire
    canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.6), size.height * 0.2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
