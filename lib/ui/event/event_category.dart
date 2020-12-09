import 'package:flutter/material.dart';
import 'package:comat_apps/ui/constant.dart';
import 'dart:ui' as ui;

class EventCategory extends StatelessWidget {
  final Color colorStart;
  final Color colorEnd;
  final String title;
  const EventCategory({
    Key key, this.colorStart, this.colorEnd, this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15, right: 15, left: 15),
      child: Stack(
        children: [
          Stack(
            children: [
              Container(
                height: 50,
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                    colors: [
                      colorStart, colorEnd
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorStart,
                      blurRadius: 12,
                      offset: Offset(0,1)
                    )
                  ]
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: InkWell(
                    onTap: () {
                      print(title);
                    },
                    highlightColor: colorStart,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: CustomPaint(
                  painter: CustomCardShapePainter(radius: 15, startColor: colorStart, endColor: colorEnd),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 10),
                    child: Text(
                      title, 
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;
  CustomCardShapePainter({this.radius, this.startColor, this.endColor});

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 20.0;
    var paint = Paint();

    paint.shader = ui.Gradient.linear(
      Offset(0,0), 
      Offset(size.width, size.height), 
      [HSLColor.fromColor(startColor).withLightness(0.8).toColor(),endColor]
    );
    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2*radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}