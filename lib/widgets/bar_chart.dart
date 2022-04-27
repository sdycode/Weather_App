import 'package:flutter/material.dart';

class BarChart extends StatefulWidget {
  List<dynamic> xaxislist;
  List<double> yaxislist;

  BarChart(
      {this.xaxislist = const ["First", "Second", "Third"],
      this.yaxislist = const [10, 50, 30]});

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
