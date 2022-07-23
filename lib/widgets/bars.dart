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
  double span = 0;
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
ScrollController _listController = ScrollController();
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _listController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print("Afer init  in build ${widget.yaxislist.length}");
    providerClass = Provider.of<ProviderClass>(context);
    l = math.min(widget.xaxislist.length, widget.yaxislist.length);
    print('yxx ${widget.yaxislist}');
    yl.clear();
    widget.yaxislist.forEach((element) {
      print("eell" + element.toString());
      yl.add(element.toDouble());
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
              child: GestureDetector(
                onTap: () {
                   print("pan tap  ");
                },
                onPanUpdate: (d) {
                  print("pan update ${d.localPosition} ");
                  if (providerClass.shrinkFactor != 1.0) {
                    Offset locd = d.localPosition;
                    providerClass.seHoverOffset(locd);

                    if (locd.dx > 0 &&
                            locd.dx < (widget.w * (1 - widget.yw) - 26)
                        //  &&
                        // locd.dy > (widget.h * (1 - widget.xh) * (1.0) * (0.9))*(widget.yaxislist[i] / span)

                        ) {
                      int xno = ((locd.dx) /
                              ((widget.w * (0.2 * 0.5 + 0.03)) *
                                  (providerClass.shrinkFactor)))
                          .toInt();
                      if (xno >= l) {
                        xno = l - 1;
                      }
                      providerClass.setbarOverlayIndex(xno);
                      providerClass.setShowOverlayPoint(true);
                    } else {
                      providerClass.setShowOverlayPoint(false);
                    }
                  } else {}
                },
                onPanEnd: (d) {
                  providerClass.setShowOverlayPoint(false);
                },
                child: ListView.builder(
                  controller: _listController,
                physics: providerClass.shrinkFactor != 1.0 ? NeverScrollableScrollPhysics(): ClampingScrollPhysics() ,
                  scrollDirection: Axis.horizontal,
                  itemCount: l,
                  itemBuilder: (c, i) => Container(
                      margin: EdgeInsets.only(
                          left: widget.w * 0.03 * providerClass.shrinkFactor,
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
                              print('bar color ${widget.barColor}');
                              print(
                                  "@ $i   ${(widget.yaxislist[i] / span)}  /  ${widget.yaxislist[i]} /  $span");
                              return Container(
                                height: widget.h * (1 - widget.xh),
                                // color: Colors.amber,
                                child: Column(
                                  children: [
                                    Spacer(),
                                    // FittedBox(
                                    //   child: Text(
                                    //       getTrimmedNo(widget.yaxislist[i], 4)),
                                    // ),
                                    Container(
                                      width: (widget.w * 0.2 * 0.5) *
                                          (providerClass.shrinkFactor),
                                      height: providerClass.animateBar
                                          ? math.max(value!, 0)
                                          : math.max(
                                              0,
                                              (widget.yaxislist[i] / span) *
                                                  (widget.h *
                                                      (1 - widget.xh) *
                                                      (0.7))),
                                      color:
                                          providerClass.barOverlayIndex == i &&
                                                  providerClass.shrinkFactor !=
                                                      1.0 &&
                                                  providerClass.showOverlayPoint
                                              ? Constants.chipColor
                                              : widget.barColor,
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
                              height:
                                  math.max(0, widget.h * widget.xh - 20 + 8),
                              width: (widget.w * 0.2 * 0.5) *
                                  (providerClass.shrinkFactor),
                              color: Color.fromARGB(0, i * 10, 107, 102),
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: FittedBox(
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    // child: (widget.xaxislist[i]),
                                  ),
                                ),
                              ))
                        ],
                      )),
                ),
              ),
            ),
            Positioned(
              left:0,
              bottom: widget.h * 0.01,
              child: Container(
                width: widget.w*(1-widget.xw)*0.98,
                // color: Colors.red,
                child: Center(

                  child: Text(
                    
                    providerClass
                        .cityModels[providerClass.currentCityIndex].cityname,
                        textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: widget.w * 0.06, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            providerClass.showOverlayPoint
                ? Positioned(
                    left: widget.w * 0.3,
                    top: 30,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.pink.shade200.withAlpha(100),
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(8),
                        height: widget.h * 0.1,
                        // width: widget.w * 0.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Text(
                            //   (widget.xaxislist[providerClass.barOverlayIndex]
                            //           as Text)
                            //       .data
                            //       .toString(),
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: widget.h * 0.05),
                            // ),
                            Center(
                              child: FittedBox(
                                child:
                                    // Text(
                                    //     "${providerClass.hoverPoint.dx.toStringAsFixed(1)} / ${providerClass.hoverPoint.dy.toStringAsFixed(1)} / ${widget.w * (1 - widget.yw)}  / ${providerClass.barOverlayIndex} "),

                                    Text(
                                  getTrimmedNo(
                                      widget.yaxislist[
                                          providerClass.barOverlayIndex],
                                      4),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: widget.h * 0.05),
                                ),
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
                        double d = ((widget.w * 0.85) /
                                ((widget.w * 0.2 * 0.5 + widget.w * 0.06))) /
                            (l);
                        print("shrink  $d");
                        providerClass.setShrinkFactor(d);
                      } else {
                        providerClass.setShrinkFactor(1.0);
                      }
                    },
                    icon: providerClass.shrinkFactor == 1.0
                        ? Icon(Icons.close_fullscreen)
                        : Icon(Icons.fullscreen)),
              ),
            ),
          ],
        ));
  }

  double getSpan(List yll) {
    double min = 0;
    double max = 0;
    print('yyyy ${yll} & $yl');
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

  String getTrimmedNo(double yaxislist, int n) {
    String ans = yaxislist
        .toStringAsFixed(4)
        .replaceAll('0', ' ')
        .trim()
        .replaceAll(' ', '0');
    if (ans.endsWith('.')) {
      ans = ans.substring(0, ans.characters.length - 1);
    }
    if (ans.startsWith('.')) {
      ans = '0' + ans;
      // ans = ans.substring(1, ans.characters.length);
    }
    return ans;
  }
}
