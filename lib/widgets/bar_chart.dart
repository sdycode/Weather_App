import 'package:flutter/material.dart';
import 'dart:math';

import 'bars.dart';

class BarChart extends StatefulWidget {
  List<dynamic> xaxislist;
  List<double> yaxislist;
  Color barColor;
  double h;
  double w;

  BarChart(
      {this.xaxislist = const ["First", "Second", "Third"],
      this.yaxislist = const [10, 50, 30],
      this.barColor = Colors.blue,
      this.h = 200,
      this.w = 300});

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber.withAlpha(50),
      height: widget.h,
      width: widget.w,
      child: Stack(children: [
        Positioned(top: 0, left: 0, child: yaxixLine()),
        Positioned(left: 0, bottom: 0, child: xaxixLine()),
        Positioned(left: 26, bottom: 26, child: 
        
        bars(widget.xaxislist, 
        
        widget.yaxislist,
        widget.barColor,
        widget.h*0.7,
        widget.w
        ))
      ]),
    );
  }

  yaxixLine() {
    return RotatedBox(
      quarterTurns: 3,
      child: Container(
        // width: widget.h,
        height: 26,

        child: Column(
          children: [
            Container(
              height: 20,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  "y axis name",
                  textAlign: TextAlign.center,
                  style: TextStyle(),
                ),
              ),
            ),
            Container(
              height: 2,
              width: widget.h,
              margin: EdgeInsets.all(1),
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }

  xaxixLine() {
    return Container(
      height: 26,
      // width:widget.w,
      child: Column(
        children: [
          Container(
            height: 2,
            width: widget.w,
            margin: EdgeInsets.all(1),
            color: Colors.black,
          ),
          Container(
            height: 20,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                "x axis name",
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


