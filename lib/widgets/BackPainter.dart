import 'package:flutter/material.dart';
class BackPainter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Custom Shape')),
        body: Center(
          child: CustomPaint(
            size: Size(200, 200),
            painter: SquareWithTrianglePainter(),
          ),
        ),
      ),
    );
  }
}

class SquareWithTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blue, Colors.purple],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Path path = Path();
    // Draw the square
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.width));
    
    // Draw the triangle at the bottom
    path.moveTo(0, size.width);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.width);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}