import 'package:flutter/material.dart';

const pi = 3.14159265359;

class PortionCircle extends StatelessWidget {
  const PortionCircle({
    super.key,
    required this.percent,
    Color? color,
    Size? size,
  }):
    size = size ?? const Size(200, 200),
    color = color ?? Colors.blue;

  final Size size;
  final Color color;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: PortionPainter(
        percent: percent,
        color: color,
      ),
    );
  }
}

class PortionPainter extends CustomPainter {
  const PortionPainter({
    required this.percent,
    required this.color,
  });

  final double percent;
  final Color color;
  double get _portion => percent / 100;

  Color get mainColor => color;
  Color get secondColor => Colors.grey;
  Color get outerColor => Colors.white38;
  Color get innerColor => Colors.white;
  Color get textColor => Colors.black87; 

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

  // Draw Outer background
    final double outerRadius = radius * 1.05;
    paint.color = outerColor;
    canvas.drawCircle(
      center,
      outerRadius,
      paint
    );

    // Draw the blue 60% section
    paint.color = mainColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * pi / 180, // Start at the top
      360 * _portion * pi / 180, // 60% arc
      true,
      paint,
    );

    // Draw the grey 40% section
    paint.color = secondColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      (360 * _portion - 90) * pi / 180, // Start where blue ends
      360 * (1 - _portion) * pi / 180, // 40% arc
      true,
      paint,
    );

    // Draw the inner circle
    final double innerRadius = radius / 1.5;
    paint.color = innerColor;
    canvas.drawCircle(
      center,
      innerRadius,
      paint
    );

    // Draw the text
    paint.color = Colors.black;
    final textPainter = TextPainter(
      text: TextSpan(
        text: "${percent.toStringAsFixed(2)}%",
        style: TextStyle(
          color: textColor,
          fontSize: 32,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width
    );

    final Offset textCenter = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, textCenter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}