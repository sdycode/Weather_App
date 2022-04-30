import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/providers/provider_file.dart';

class bars extends StatefulWidget {
  List<dynamic> xaxislist;
  List<double> yaxislist;
  Color barColor;
  double h;
  double w;
  bars(this.xaxislist, this.yaxislist, this.barColor, this.h, this.w);

  @override
  State<bars> createState() => _barsState();
}

class _barsState extends State<bars> {
  List yl = [];
  @override
  Widget build(BuildContext context) {
    ProviderClass providerClass = Provider.of<ProviderClass>(context);
    int l = min(widget.xaxislist.length, widget.yaxislist.length);
    // yl = widget.yaxislist.toList();
    // // List.copyRange(yl, widget.yaxislist);
    widget.yaxislist.forEach((element) {
      print("eell" + element.toString());
      yl.add(element.toInt());
    });
    // yl = [50, 60, 10, 80, 30];
    // yl.sort();
    int span = 0;
     span = getSpan(yl);

    return Container(
      height: widget.h,
      width: widget.w,
      // color: Colors.red,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: l,
          itemBuilder: (c, i) => Container(
                margin: EdgeInsets.only(
                    left: widget.w * 0.03, right: widget.w * 0.03),
                width: widget.w * 0.2 * 0.5,
                height: widget.h,
                child: Stack(children: [
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: TweenAnimationBuilder<double>(
                        builder: (BuildContext context, double? value,
                            Widget? child) {
                          return Container(
                            width: widget.w * 0.2 * 0.5,
                            height: providerClass.animateBar
                                ? value
                                : (widget.yaxislist[i] / span) * (widget.h),
                            color: Colors.blue,
                          );
                        },
                        duration: Duration(seconds: 2),
                        // Duration(seconds: ( (widget.yaxislist[i] / span)).toInt()*5),
                        tween: Tween<double>(
                            begin: 0,
                            end: (widget.yaxislist[i] / span) * (widget.h)),
                      ))
                ]),
                //  (widget.yaxislist[i] / span) * (widget.h),
              )),
    );
  }

  int getSpan(List yll) {
    int min = 0, max = yll[0];
    for (int i in List.generate(60, (index) => index)) {
      print(
          "====================================== = ${Random().nextInt(500000)}");
    }

    yl.forEach((e) {
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
