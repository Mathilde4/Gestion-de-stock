import 'package:flutter/material.dart';

class DesignPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF32325d),
        ),
        child: CustomPaint(
          painter: CirclePainter(),
          child: Container(),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    // Cercle 1
    Rect rect1 = Rect.fromCircle(center: Offset(1026.09, 37.64), radius: 30);
    paint.shader = LinearGradient(
      colors: [Color(0xFF32325d), Color(0xFF424488)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(rect1);
    canvas.drawCircle(Offset(1026.09, 37.64), 30, paint);

    // Cercle 2
    Rect rect2 = Rect.fromCircle(center: Offset(103.51, 75.41), radius: 40);
    paint.shader = LinearGradient(
      colors: [Color(0xFF84b6e0), Color(0xFF343aa2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(rect2);
    canvas.drawCircle(Offset(103.51, 75.41), 40, paint);

    // Cercle 3
    Rect rect3 = Rect.fromCircle(center: Offset(149.59, 95.68), radius: 44);
    paint.shader = LinearGradient(
      colors: [Color(0xFFe298de), Color(0xFF4a4890)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(rect3);
    canvas.drawCircle(Offset(149.59, 95.68), 44, paint);

    // Cercle 4
    Rect rect4 = Rect.fromCircle(center: Offset(1193.64, 240.81), radius: 30);
    paint.shader = LinearGradient(
      colors: [Color(0xFFf29b7c), Color(0xFF7e6286)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(rect4);
    canvas.drawCircle(Offset(1193.64, 240.81), 30, paint);

    // Cercle 5
    Rect rect5 = Rect.fromCircle(center: Offset(872.87, 229.26), radius: 15);
    paint.shader = LinearGradient(
      colors: [Color(0xFFab3c51), Color(0xFF4f4484)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(rect5);
    canvas.drawCircle(Offset(872.87, 229.26), 15, paint);

    // Cercle 6
    Rect rect6 = Rect.fromCircle(center: Offset(235.35, 532.97), radius: 55);
    paint.shader = LinearGradient(
      colors: [Color(0xFF84b6e0), Color(0xFF343aa2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(rect6);
    canvas.drawCircle(Offset(235.35, 532.97), 55, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
