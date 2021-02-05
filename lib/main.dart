import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Drawing(),
    );
  }
}

class Drawing extends StatefulWidget {
  @override
  _DrawingState createState() => _DrawingState();
}

class _DrawingState extends State<Drawing> {
  List<Offset> points = <Offset>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawing App'),
      ),
      body: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          setState(() {
            RenderBox box = context.findRenderObject();
            Offset offset = box.globalToLocal(details.globalPosition);
            offset = offset.translate(
              0.0,
              -(AppBar().preferredSize.height),
            );
            points = List.from(points)..add(offset);
          });
        },
        onPanEnd: (DragEndDetails details) {
          points.add(null);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(5.0),
          child: CustomPaint(
            painter: CustomSketch(points),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            points.clear();
          });
        },
        child: Icon(Icons.refresh_sharp),
      ),
    );
  }
}

class CustomSketch extends CustomPainter {
  final List<Offset> points;

  CustomSketch(
    this.points,
  );

  @override
  bool shouldRepaint(CustomSketch oldDelegate) {
    return oldDelegate.points != points;
  }

  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.pinkAccent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (var i = 0; i < points.length; i++) {
      if (points[i] != null && points[i + 1] != null) {
        //  canvas.drawPoints(PointMode.points, points, paint);

        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }
}
