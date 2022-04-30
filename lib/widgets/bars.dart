import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/constants/constants.dart';
import 'package:weather/providers/provider_file.dart';

class bars extends StatefulWidget {
  List<Widget> xaxislist;
  List<double> yaxislist;
  Color barColor;
  double h;
  double w;
  double xw;
  double xh;
  double yw;
  double yh;
  bars(
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
  State<bars> createState() => _barsState();
}

// 1800 1111 01
//
// 1800 425 3800
// 1800 1122 11
// 08026599990
class _barsState extends State<bars> {
  List yl = [];
  int span = 0;
  int l = 0;
  int max = 0;
  int min = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init ${l}  ${widget.xaxislist.length}  ${widget.yaxislist.length}");
  }

  late ProviderClass providerClass;

  @override
  Widget build(BuildContext context) {
    print("Afer init  in build ${widget.yaxislist.length}");
    providerClass = Provider.of<ProviderClass>(context);
    l = math.min(widget.xaxislist.length, widget.yaxislist.length);

    yl.clear();
    widget.yaxislist.forEach((element) {
      print("eell" + element.toString());
      yl.add(element.toInt());
    });

    span = getSpan(yl);
    // yl = widget.yaxislist.toList();
    // // List.copyRange(yl, widget.yaxislist);

    // yl = [50, 60, 10, 80, 30];
    // yl.sort();

    return Container(
        height: widget.h,
        width: widget.w,
        // color: Colors.red,
        child: Stack(
          children: [
            Container(
              height: widget.h,
              width: widget.w,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: l,
                itemBuilder: (c, i) => Container(
                    margin: EdgeInsets.only(
                        left: widget.w * 0.02 * providerClass.shrinkFactor,
                        right: widget.w * 0.03 * providerClass.shrinkFactor),
                    width:
                        (widget.w * 0.2 * 0.5) * (providerClass.shrinkFactor),
                    height: widget.h,
                    // color: Colors.purple,
                    child: Column(
                      children: [
                        Spacer(),
                        TweenAnimationBuilder<double>(
                          builder: (BuildContext context, double? value,
                              Widget? child) {
                            return Container(
                              height: widget.h * (1 - widget.xh),
                              // color: Colors.amber,
                              child: Column(
                                children: [
                                  Spacer(),
                                  FittedBox(
                                    child: Text(widget.yaxislist[i].toString()),
                                  ),
                                  GestureDetector(
                                    onPanUpdate: (details) {
                                      providerClass.setbarOverlayIndex(i);
                                      providerClass.setShowOverlayPoint(true);
                                    },
                                    onPanEnd: (d) {
                                      Future.delayed(Duration(seconds: 2))
                                          .then((value) {
                                            providerClass.setShowOverlayPoint(false);
                                      providerClass.setbarOverlayIndex(-1);
                                          });
                                      
                                    },
                                    child: Container(
                                      width: (widget.w * 0.2 * 0.5) *
                                          (providerClass.shrinkFactor),
                                      height: providerClass.animateBar
                                          ? value
                                          : (widget.yaxislist[i] / span) *
                                              (widget.h *
                                                  (1 - widget.xh) *
                                                  (0.7)),
                                      color: providerClass.barOverlayIndex == i
                                          ? Constants.chipColor
                                          : widget.barColor,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          duration: Duration(seconds: 2),
                          // Duration(seconds: ( (widget.yaxislist[i] / span)).toInt()*5),
                          tween: Tween<double>(
                            begin: 0,
                            end: (widget.yaxislist[i] / span) *
                                (widget.h * (1 - widget.xh) * (0.7) * (0.9)),
                          ),
                        ),
                        Container(
                            height: widget.h * widget.xh - 20 + 8,
                            width: (widget.w * 0.2 * 0.5) *
                                (providerClass.shrinkFactor),
                            color: Color.fromARGB(0, i * 10, 107, 102),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: FittedBox(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: (widget.xaxislist[i]),
                                ),
                              ),
                            ))
                      ],
                    )

                    // Stack(children: [
                    //   Align(
                    //     alignment: Alignment.bottomCenter,
                    //     child: Container(
                    //       height: widget.h * widget.xh,
                    //       width: widget.w * 0.2 * 0.5,
                    //       color: Color.fromARGB(255, i * 10, 107, 102),
                    //     ),
                    //   ),
                    //   Padding(
                    //     padding: EdgeInsets.only(bottom: widget.h * widget.xh-6),
                    //     child: Align(
                    //         alignment: Alignment.bottomCenter,
                    //         child:

                    ),
                // )
                // ]),
                // //  (widget.yaxislist[i] / span) * (widget.h),

                // )
              ),
            ),
            providerClass.showOverlayPoint
                ? Positioned(
                    left: widget.w * 0.25,
                    top: 30,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.pink.shade200.withAlpha(100),
                            borderRadius: BorderRadius.circular(10)),
                        height: widget.h * 0.1,
                        width: widget.w * 0.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.xaxislist[providerClass.barOverlayIndex],
                            Center(
                              child: FittedBox(
                                child: Text(" -> " +
                                    widget.yaxislist[
                                            providerClass.barOverlayIndex]
                                        .toString()),
                              ),
                            ),
                          ],
                        )))
                : Container(),
            Positioned(
              right: 40,
              top: 20,
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      if (providerClass.shrinkFactor == 1.0) {
                        double d = ((widget.w * 0.95) /
                                ((widget.w * 0.2 * 0.5 + widget.w * 0.06))) /
                            (l);
                        print("shrink  $d");
                        providerClass.setShrinkFactor(d);
                      } else {
                        providerClass.setShrinkFactor(1.0);
                      }
                    },
                    icon: Icon(Icons.close_fullscreen)),
              ),
            ),
          ],
        ));
  }

  int getSpan(List yll) {
    int min = 0;
    int max = 0;
    for (int i in List.generate(60, (index) => index)) {
      print(
          "=====================================span= = ${math.Random().nextInt(500000)}");
    }

    yl.forEach((e) {
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
