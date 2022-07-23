import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/widgets/multibar.dart';

import '../providers/provider_file.dart';

class MultiBarChart extends StatefulWidget {
  List<List<double>> yAxisValuesOfCities;
  double w;
  double h;
  MultiBarChart(this.yAxisValuesOfCities, this.w, this.h, {Key? key})
      : super(key: key);

  @override
  State<MultiBarChart> createState() => _MultiBarChartState(w, h);
}

class _MultiBarChartState extends State<MultiBarChart> {
  int _minNoofValues = 0;
  double _spanValue = 0;
  late double w;
  late double h;
  _MultiBarChartState(double w, double h) {
    this.w = w;
    this.h = h;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // List l =
    //     List.from(widget.yAxisValuesOfCities).map((e) => e.length).toList();
    // l.sort();
    // // print('tab1 called already ${ yvalueswrtWeatherTime[providerClass.weathchipindex][0].length}  ${Random().nextInt(500)}');
    // print('tab1 called  ll $l and ${widget.yAxisValuesOfCities}');
    // _minNoofValues = l.first;
    // getSpanValue();
  }

  late ProviderClass providerClass;

  @override
  Widget build(BuildContext context) {
    providerClass = Provider.of<ProviderClass>(context);
    List l =
        List.from(widget.yAxisValuesOfCities).map((e) => e.length).toList();
    l.sort();
    // print('tab1 called already ${ yvalueswrtWeatherTime[providerClass.weathchipindex][0].length}  ${Random().nextInt(500)}');
    print('tab1 called  ll $l and ${widget.yAxisValuesOfCities}');
    _minNoofValues = l.first;
    getSpanValue();
    return Container(
      height: h,
      width: w,
      child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(
              width: w * 0.05,
            );
          },
          itemCount: _minNoofValues,
          scrollDirection: Axis.horizontal,
          itemBuilder: (c, i) {
            List<double> citiesYvaluesAtParticularTime = [];
            widget.yAxisValuesOfCities.forEach((e) {
              citiesYvaluesAtParticularTime.add(e[i]);
            });

            if (_minNoofValues == 1) {
              return Center(
                  child: MultiBarWidget(i, citiesYvaluesAtParticularTime,
                      _spanValue, h, w, true));
            } else {
              return MultiBarWidget(
                  i, citiesYvaluesAtParticularTime, _spanValue, h, w, false);
            }
          }),
    );
  }

  void getSpanValue() {
    List allyvalues = [];
    widget.yAxisValuesOfCities.forEach((e) {
      allyvalues.addAll(e);
    });
    allyvalues.sort();
    _spanValue = allyvalues.last;
  }
}
