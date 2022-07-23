import 'package:flutter/material.dart';

import '../constants/constants.dart';

class MultiBarWidget extends StatefulWidget {
  int i;
  List<double> list;
  double spanValue;
  double h;
  double w;
  bool isCurrent;
  MultiBarWidget(
      this.i, this.list, this.spanValue, this.h, this.w, this.isCurrent,
      {Key? key})
      : super(key: key);

  @override
  State<MultiBarWidget> createState() => _MultiBarWidgetState();
}

class _MultiBarWidgetState extends State<MultiBarWidget> {
  double h = 10;
  double w = 10;
  double barw = 5;
  @override
  void initState() {
    // TODO: implement initState
    h = widget.h;
    w = widget.w;
    barw = w * 0.02;
    if (widget.isCurrent) {
      barw = (w / widget.list.length) * 0.7;
    }

    print('vv ${widget.spanValue} and ${widget.list}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int count = 0;
    print(
        'init called on multibar widget ${widget.list} / ${widget.list.length}');
    return Container(
      height: h,
      width: widget.isCurrent ? w : barw * widget.list.length,
      child: Stack(children: [
        Container(
          height: h,
          width: widget.isCurrent ? w : barw * widget.list.length,
          color: Colors.transparent,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ...(widget.list.map((e) {
                // int index = widget.list.indexWhere((ee) => ee == e);
                int index = count;
                count++;
                return Container(
                  // margin: widget.isCurrent? EdgeInsets.fromLTRB(w*0.04, 0, w*0.04, 0) :EdgeInsets.all(0),
                  height: e / widget.spanValue * h,
                  width: barw,
                  color:
                      // Colors.blue
                      Constants.citycolors[index % Constants.citycolors.length],
                );
              }).toList())
            ],
          ),
        )
      ]),
    );
  }
}
