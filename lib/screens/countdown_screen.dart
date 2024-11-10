import 'package:flutter/material.dart';

// New: import the updateHeadline function
import 'home_screen.dart';
import '../data/countdown_data.dart';

class CountdownScreen extends StatefulWidget {
  final CountdownData countdown;

  const CountdownScreen({
    super.key,
    required this.countdown,
  });

  @override
  State<CountdownScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<CountdownScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("CountDown"),
          titleTextStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Updating home screen widget...'),
          ));
          // New: call updateHeadline
          updateHeadline(widget.countdown);
        },
        label: const Text('Update Homescreen'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            "T1",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20.0),
          Text("T2"),
          const SizedBox(height: 20.0),
          const Center(child: LineChart()),
          const SizedBox(height: 20.0),
          Text("T3"),
        ],
      ),
    );
  }
}

class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LineChartPainter(),
      child: const SizedBox(
        height: 200,
        width: 200,
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dataPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final markingLinePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final mockDataPoints = [
      const Offset(15, 155),
      const Offset(20, 133),
      const Offset(34, 125),
      const Offset(40, 105),
      const Offset(70, 85),
      const Offset(80, 95),
      const Offset(90, 60),
      const Offset(120, 54),
      const Offset(160, 60),
      const Offset(200, -10),
    ];

    final axis = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height);

    final markingLine = Path()
      ..moveTo(-10, 50)
      ..lineTo(size.width + 10, 50);

    final data = Path()..moveTo(1, 180);

    for (var dataPoint in mockDataPoints) {
      data.lineTo(dataPoint.dx, dataPoint.dy);
    }

    canvas.drawPath(axis, axisPaint);
    canvas.drawPath(data, dataPaint);
    canvas.drawPath(markingLine, markingLinePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
