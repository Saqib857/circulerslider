import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Time Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CircularTimePickerDemo(),
    );
  }
}

class CircularTimePickerDemo extends StatefulWidget {
  @override
  _CircularTimePickerDemoState createState() => _CircularTimePickerDemoState();
}

class _CircularTimePickerDemoState extends State<CircularTimePickerDemo> {
  double _hourAngle = 0.0;
  double _minuteAngle = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Background color for the page
      appBar: AppBar(
        title: Text('Circular Time Picker'),
        backgroundColor: Colors.blue, // Background color for the app bar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow, // Set background color of circular area
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      for (int i = 1; i <= 12; i++)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Transform.rotate(
                            angle: i * pi / 6,
                            child: Text(
                              i.toString(),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            _hourAngle = atan2(details.localPosition.dy - 150, details.localPosition.dx - 150);
                            _minuteAngle = atan2(details.localPosition.dx - 150, details.localPosition.dy - 150);
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              painter: CircularPointerPainter(
                                angle: _hourAngle,
                                isHour: true,
                              ),
                            ),
                            CustomPaint(
                              painter: CircularPointerPainter(
                                angle: _minuteAngle,
                                isHour: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // Background color for the time circle
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(_hourAngle / (2 * pi) * 12).round()}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        '${(_minuteAngle / (2 * pi) * 60).round()}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                int selectedHour = (_hourAngle / (2 * pi) * 12).round();
                int selectedMinute = (_minuteAngle / (2 * pi) * 60).round();
                String formattedTime = '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}';
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Selected Time'),
                      content: Text('You selected: $formattedTime'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Button color
              ),
              child: Text('Select Time'),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularPointerPainter extends CustomPainter {
  final double angle;
  final bool isHour;

  CircularPointerPainter({required this.angle, required this.isHour});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final double pointerLength = radius * 0.8;
    final double pointerWidth = 2.0;

    Paint pointerPaint = Paint()
      ..color = isHour ? Colors.blue : Colors.red // Hour pointer is blue, minute pointer is red
      ..strokeWidth = pointerWidth
      ..strokeCap = StrokeCap.round;

    Offset startPoint = Offset(radius, radius);
    Offset endPoint = Offset(
      radius + pointerLength * cos(angle),
      radius + pointerLength * sin(angle),
    );

    canvas.drawLine(startPoint, endPoint, pointerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
