import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:weather/widgets/lineChart.dart';

class Lines extends StatefulWidget {
  List<Widget> xaxislist;
  List<List<double>> yaxislist;
  Color barColor;
  double h;
  double w;
  double xw;
  double xh;
  double yw;
  double yh;
  Lines(
    this.xaxislist,
    this.yaxislist,
    this.barColor,
    this.h,
    this.w,
    this.xw,
    this.xh,
    this.yw,
    this.yh,
  );

  @override
  State<Lines> createState() => _LinesState();
}

class _LinesState extends State<Lines> {
  int span = 0;
  int min = 0, max = 0;
  @override
  Widget build(BuildContext context) {
    span = getSpan(widget.yaxislist[0]);

    return Container(
      height: widget.h,
      width: widget.w,
      child: Stack(children: [
        GestureDetector(
          onTap: () {
            print("point is -----------}");
          },
          onPanUpdate: (d) {
            providerClass.setLineHoverOffset(d.localPosition);
            providerClass.setTemptext((widget.h*(1-widget.xh)).toStringAsFixed(2));
            print(
                "point is ${d.localPosition} // ${providerClass.lineHoverPoint}");
          },
          child: CustomPaint(
            painter: linePainter(widget.yaxislist[0], widget, span),
            child: Container(
              height: widget.h,
              width: widget.w,
              color: Colors.transparent,
            ),
          ),
        )
      ]),
    );
  }

  int getSpan(List yll) {
    int min = 0;
    int max = 0;
    for (int i in List.generate(60, (index) => index)) {
      print(
          "=====================================span= = ${math.Random().nextInt(500000)}");
    }

    yll.forEach((e) {
      e = e.toInt();
      print("eee is $e");
      if (e < min) {
        min = e;
      } else if (e > max) {
        max = e;
      }

      print("max min $max   $min  $e  & span ${(max - min)}");
    });
    return max - min;
  }
}

class linePainter extends CustomPainter {
  List<double> yvalues;
  Lines widget;
  int span;
  linePainter(this.yvalues, this.widget, this.span);

  @override
  void paint(Canvas canvas, Size size) {
    double totalh = widget.h * (1 - widget.xh);
    print("yvalues----------------------------------} ");
    for (int i = 0; i < yvalues.length - 1; i++) {
      double barhprev = (yvalues[i] / span) * (totalh);
      double barhnext = (yvalues[i + 1] / span) * (totalh);
      print("yvalues ${yvalues[i]} //  ${yvalues.length} ");
      canvas.drawPoints(
          PointMode.points, [Offset(i * 10, totalh - 100)], Paint());
      canvas.drawLine(Offset(i * 10, totalh - barhprev),
          Offset((i + 1) * 10, totalh - barhnext), Paint());
    }
    final Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1.0;
    canvas.drawPoints(PointMode.points, [providerClass.lineHoverPoint], paint);
    // canvas.drawCircle(Offset(50, 50), 80, Paint());

    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
