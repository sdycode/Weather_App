import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/providers/provider_file.dart';
import 'dart:math';

import 'bars.dart';

class BarChart extends StatefulWidget {
  List<Widget> xaxislist;
  List<double> yaxislist;
  Color barColor;
  double h;
  double w;
  double xw;
  double xh;
  double yw;
  double yh;
  String xaxisname;
  String yaxisname;

  BarChart({
    this.xaxislist = const [Text("First"), Text("Second"), Text("Third")],
    this.yaxislist = const [10, 50, 30],
    this.barColor = Colors.blue,
    this.h = 200,
    this.w = 300,
    this.xw = 0.1,
    this.xh = 0.2,
    this.yw = 0.1,
    this.yh = 0.05,
    this.xaxisname = "X axis",
    this.yaxisname = "Y axis",
  });

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  @override
  void initState() {
    // TODO: implement initState
    print("init  in barchart");

    super.initState();
  }
 late ProviderClass providerClass;
  @override
  Widget build(BuildContext context) {
    print("init uild in barchart ${widget.xaxisname}  // ${widget.yaxisname}");
      providerClass = Provider.of<ProviderClass>(context);
    return Container(
      color: Colors.amber.withAlpha(50),
      height: widget.h,
      width: widget.w,
      child: Stack(children: [
        Positioned(top: 0, left: widget.w * widget.yw + 8, child: yaxixLine()),
        Positioned(
            left: 0, bottom: 6 + widget.h * widget.xh, child: yaxisText()),
        Positioned(
            left: widget.w * widget.yw + 10,
            bottom: 20,
            child: bars(
              widget.xaxislist,
              widget.yaxislist,
              widget.barColor,
              widget.h,
              widget.w,
              widget.xw,
              widget.xh,
              widget.yw,
              widget.yh,
            )),
        Positioned(left: widget.w * widget.yw, bottom: 0, child: xaxisText()),
        Positioned(
            left: 0, bottom: 6 + widget.h * widget.xh, child: xaxixLine()),
      ]),
    );
  }

  yaxisText() {
    return RotatedBox(
      quarterTurns: 3,
      child: Container(
        width: widget.h - widget.h * widget.xh - 20 + 6,
        // color: Colors.orange,

        height: 20,
        child: Column(
          children: [
            // Container(
            //   height: 20,
            //   child: FittedBox(
            //     fit: BoxFit.fitHeight,
            //     child: Text(
            //       "y axis name",
            //       textAlign: TextAlign.center,
            //       style: TextStyle(),
            //     ),
            //   ),
            // ),
            Container(
              height: 18,
              width: widget.h - widget.h * widget.xh - 20 + 6,
              margin: EdgeInsets.all(1),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  // prov
                  widget.yaxisname,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  yaxixLine() {
    return RotatedBox(
      quarterTurns: 3,
      child: Container(
        // width: widget.h,
        height: 6,

        child: Column(
          children: [
            // Container(
            //   height: 20,
            //   child: FittedBox(
            //     fit: BoxFit.fitHeight,
            //     child: Text(
            //       "y axis name",
            //       textAlign: TextAlign.center,
            //       style: TextStyle(),
            //     ),
            //   ),
            // ),
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
      height: 4,
      // width:widget.w,
      child: Column(
        children: [
          Container(
            height: 2,
            width: widget.w,
            margin: EdgeInsets.all(1),
            color: Colors.black,
          ),
          // Container(
          //   height: 20,
          //   child: FittedBox(
          //     fit: BoxFit.fitHeight,
          //     child: Text(
          //       "x axis name",
          //       textAlign: TextAlign.center,
          //       style: TextStyle(),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  xaxisText() {
    return Container(
      height: 20,
      width: widget.w - 26,
      child: FittedBox(
        child: Text(
          widget.xaxisname,
          style: TextStyle( 
                fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
