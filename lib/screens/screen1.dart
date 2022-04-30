import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:weather/models/citymodel.dart';
import 'package:weather/screens/main_screen.dart';
import 'package:weather/widgets/bar_chart.dart';

import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../models/WeatherModel.dart';
import '../models/city_data_all_models.dart';
import '../providers/provider_file.dart';
import '../utils/checkinternet.dart';

class Screen1 extends StatefulWidget {
  double topbarh;
  ProviderClass providerClass;
  Screen1(
    this.topbarh,
    this.providerClass, {
    Key? key,
  }) : super(key: key);
  // Screen1( double topbarh, {Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

/*

Data to be shown
temp
dew point
pressure
humidiy
visibiliity 
wind sepped
descrp
icon


*/
class _Screen1State extends State<Screen1> with TickerProviderStateMixin {
  late StreamSubscription<bool> keyboardSubscription;
  late ProviderClass providerClass;

  bool isConnection = false;

  TextEditingController citynamecont = TextEditingController();
  PageController _pageController = PageController();
  String citynameresponse = '';
  String lat = "0.0";
  String long = "0.0";
  String oneapiresponsedata = '';
  List<String> parameternames = [
    'Temperature',
    'Dew Point',
    'Pressure',
    'Humidity',
    'Wind Speed'
  ];
  List<String> parametervalue = [
    '-',
    '-',
    '-',
    '-',
    '-',
  ];
  String imgurl = "http://openweathermap.org/img/wn/10d@2x.png";
  // List<Widget> weatherList = [];
  int weatherdayindex = 0;
  bool keyboardVisible = false;
  late Animation<double> myAnimation;

  late AnimationController myAnimationController = AnimationController(
    duration: Duration(seconds: 5),
    vsync: this,
  );

  @override
  void initState() {
    providerClass = widget.providerClass;

    myAnimationController = AnimationController(
        duration: Duration(milliseconds: 8000), vsync: this);

    myAnimation = Tween(begin: -1.0, end: 1.0).animate(myAnimationController)
      ..addListener(() {
        // setState(() {});
      });
    // TODO: implement initState
    super.initState();

    ;
  }

  List<List<double>> sampledata = [
    [10, 100],
    [20, 150],
    [30, 80],
    [40, 210],
    [50, 160]
  ];

  @override
  Widget build(BuildContext context) {
    print("visi top ${MediaQuery.of(context).viewPadding.top}");
    // providerClass = Provider.of<ProviderClass>(
    //   context,
    // );
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    // citynamecont.text = providerClass.cityName;
    providerClass.incrementBuildcounter();
    // weatherList.addAll([currentWeather(), hourlyWeather(), daysWeather()]);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          print("refresh");
          checknet();
        },
        child: Container(
            height: Sizes().sh * (1 - 0.12),
            width: Sizes().sw,
            // color: Colors.amber,
            child: Column(
              children: [
                weatherListWidget(providerClass.weathchipindex),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 182, 216, 241).withAlpha(120)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      weatherChip(h, " Current ", 0),
                      weatherChip(h, " Hourly ", 1),
                      weatherChip(h, " Daily ", 2)
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget weatherChip(double h, String weathername, int i) {
    return InkWell(
      onTap: () {
        providerClass.setWeathchipindex(i);
        myAnimationController.reset();
        myAnimationController.forward();
      },
      child: Container(
        height: h * 0.05,
        margin: EdgeInsets.all(h * 0.01),
        padding: EdgeInsets.all(h * 0.01),
        decoration: BoxDecoration(
            color: providerClass.weathchipindex == i
                ? Constants.chipColor
                : Constants.chipNoNColor,
            borderRadius: BorderRadius.circular(h * 0.025),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, blurRadius: 1.5, offset: Offset(1, 1))
            ]),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Text(
            weathername,
            style: TextStyle(
                color: providerClass.weathchipindex == i
                    ? Constants.chipTextColor
                    : Constants.chipTextNONColor),
          ),
        ),
      ),
    );
  }

  Container citynameTextField() {
    return Container(
      height: Sizes().sh * (0.2),
      width: Sizes().sw * (0.85 - 0.2),
      margin: EdgeInsets.only(left: Sizes().sw * 0.1, right: Sizes().sw * 0.1),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes().sh * 0.03),
          color: Colors.white),
      child: Center(
        child: TextField(
          controller: citynamecont,
          textAlign: TextAlign.center,
          onChanged: (d) {
            // providerClass.setTemptext(d);
          },
          onSubmitted: (d) {
            // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
          },
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes().sh * 0.05)),
            hintText: 'Enter city name',
          ),
        ),
      ),
    );
  }

  void getDetailsbyCityName() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    bool checked = await CheckInternet.instance.check();
    if (checked) {
      if (citynamecont.text.isNotEmpty) {
        String url =
            "http://api.openweathermap.org/geo/1.0/direct?q=${citynamecont.text}&appid=${Constants.apikey1}";
        // String url1 =
        //     "https://api.openweathermap.org/geo/1.0/direct?q=nashik&appid=2b16938a6e324e1cfe9a09b08fae6d53";
        final response = await http.get(Uri.parse(url));
        print("predata ${response}");
        List responseData = json.decode(response.body);
        if (responseData.isEmpty) {
          SnackBar nocitysnackbar = SnackBar(
              backgroundColor: Colors.red.withAlpha(220),
              content: Container(
                  child: Text(
                      "Sorry data is not available for ${citynamecont.text}")));
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(nocitysnackbar);
        } else {
          print("data ${responseData}");
          citynameresponse = responseData[0]['name'];
          lat = responseData[0]['lat'].toString();
          long = responseData[0]['lon'].toString();
          String oneapicallurl =
              "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$long&appid=${Constants.apikey2}";
          // https://api.openweathermap.org/data/2.5/onecall?lat=20.0112475&lon=73.7902364&appid=2b16938a6e324e1cfe9a09b08fae6d53
          print('url - $oneapicallurl');

          final oneapiresponse = await http.get(Uri.parse(oneapicallurl));

          var oneapiResponse = json.decode(oneapiresponse.body);
          print(oneapiResponse.toString());

          CityData2 cityData2 = CityData2.fromJson(oneapiResponse);
          // imgurl =   "http://openweathermap.org/img/wn/10d@2x.png";

          imgurl =
              "http://openweathermap.org/img/wn/${cityData2.current.weather[0].icon}@2x.png";

          WeatherModel currentweathermodel = WeatherModel(
              cityData2.current.weather[0].description,
              imgurl,
              double.parse(
                  (cityData2.current.temp - 273.15).toStringAsFixed(2)),
              double.parse(
                  (cityData2.current.dewPodouble - 273.15).toStringAsFixed(2)),
              cityData2.current.pressure,
              cityData2.current.humidity,
              cityData2.current.windSpeed,
              cityData2.current.dt);

          List<WeatherModel> hourlymodels = [];
          List<WeatherModel> dailymodels = [];

          for (int i = 0; i < cityData2.hourly.length; i++) {
            WeatherModel hourlytempmodel = WeatherModel(
                cityData2.hourly[i].weather[0].description,
                imgurl,
                double.parse(
                    (cityData2.hourly[i].temp - 273.15).toStringAsFixed(2)),
                double.parse((cityData2.current.dewPodouble - 273.15)
                    .toStringAsFixed(2)),
                cityData2.hourly[i].pressure,
                cityData2.hourly[i].humidity,
                cityData2.hourly[i].windSpeed,
                cityData2.hourly[i].dt);

            hourlymodels.add(hourlytempmodel);
          }

          for (int i = 0; i < cityData2.daily.length; i++) {
            WeatherModel dailyTempModel = WeatherModel(
                cityData2.daily[i].weather[0].description,
                imgurl,
                cityData2.daily[i].temp!.day - 273.15,
                cityData2.daily[i].dewPodouble - 273.15,
                cityData2.daily[i].pressure,
                cityData2.daily[i].humidity,
                cityData2.daily[i].windSpeed,
                cityData2.daily[i].dt);

            dailymodels.add(dailyTempModel);
          }

          // providerClass.addHourlyWeatherModel(weatherModel, cityNo)
          CityModel cityModel =
              CityModel(citynamecont.text ,currentweathermodel, hourlymodels, dailymodels);
          providerClass.addNewCityModel(cityModel);

          // setState(() {
          parametervalue.clear();
          parametervalue
              .add(((currentweathermodel.temp).toStringAsFixed(2)).toString());
          parametervalue
              .add(((currentweathermodel.dew).toStringAsFixed(2)).toString());
          parametervalue.add((currentweathermodel.pressure).toInt().toString());
          parametervalue.add((currentweathermodel.humidity).toInt().toString());

          parametervalue
              .add((currentweathermodel.windspeed).toInt().toString());
          // widget.providerClass.setParamValues(parametervalue);
          providerClass.setAnimateCurrent(true);
          Future.delayed(Duration(seconds: providerClass.animatecurrntTime))
              .then((value) {
            providerClass.setAnimateCurrent(false);
          });
          providerClass.setParamValues(parametervalue);

          print('***************88888888888**');
          print(parametervalue);
          print('*****************');
          // citynameresponse = responseData.toString();

          // oneapiresponsedata = oneapiResponse.toString();
          // });
        }
      } else {
        SnackBar snackbar =
            const SnackBar(content: Text("Please enter city name ..."));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } else {
      setState(() {
        showDialog(
            context: context,
            builder: (c) {
              return Dialog(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: Sizes().sh * 0.3,
                    width: Sizes().sw * 0.8,
                    child: const Center(
                        child:
                            Text("Please check your internet connection !!!")),
                  ),
                ),
              );
            });
      });
    }
  }

  samplecard(int i) {
    List l = [];
    // providerClass.getParams().forEach(((element) {
    //   print("element $element $i");
    //   l.add(element);
    // }));

    return Container(
      width: Sizes().sw * 0.4,
      height: Sizes().sw * 0.34,
      margin: EdgeInsets.only(top: Sizes().sh * 0.01),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Colors.black,
                blurRadius: 2,
                offset: Offset(
                  1,
                  1,
                ))
          ]),
      child: Column(
        children: [Text(providerClass.parmvalues[i])],
      ),
    );
  }

  description() {
    return Container(
      width: Sizes().sw * 0.5,
      height: Sizes().sw * 0.3,
      margin: EdgeInsets.all(Sizes().sh * 0.01),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Colors.black,
                blurRadius: 2,
                offset: Offset(
                  1,
                  1,
                ))
          ]),
      child: Column(
        children: [
          Text(providerClass.temporarytext),
          Container(
            height: 50,
            width: 60,
            color: Color.fromARGB(255, Random().nextInt(240), 120, 140),
          )
        ],
      ),
    );
  }

  iconcard() {
    return Container(
        width: Sizes().sw * 0.3,
        height: Sizes().sw * 0.3,
        margin: EdgeInsets.all(Sizes().sh * 0.01),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 2,
                  offset: Offset(
                    1,
                    1,
                  ))
            ]),
        child: isConnection ? Image.network(imgurl) : Text("??"));
  }

  Widget currentWeather() {
    double mainh = Sizes().sh * (1 - 0.08 - 0.06 - 0.05);
    return Container(
      height: mainh,
      color: Constants.currentMainColor,
      child: Column(
        children: [
          SizedBox(
            height: keyboardVisible ? 25 : 0,
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: Sizes().sw,
            height: Sizes().sh * 0.06,
            child: Row(
              children: [
                citynameTextField(),
                InkWell(
                  onTap: getDetailsbyCityName,
                  child: Icon(Icons.search),
                )
              ],
            ),
          ),

          Container(
            height: mainh - (Sizes().sh * 0.06 + 8),

            width: Sizes().sw,
            // margin: EdgeInsets.all(h * 0.01),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  animatedWidget(0),
                  animatedWidget(1),
                  animatedWidget(2),
                  animatedWidget(3),
                  animatedWidget(4),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [samplecard(0), samplecard(1)],
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [samplecard(2), samplecard(3)],
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [samplecard(4), samplecard(5)],
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [description(), iconcard()],
                  // ),
                ],
              ),
            ),
          ),
          // Text(citynamecont.text),
          // Text(citynameresponse),
          // Text(lat),
          // Text(long),
          // Expanded(
          //     child: SingleChildScrollView(child: Text(oneapiresponsedata))
          //     )
        ],
      ),
    );
  }

  Widget daysWeather() {
    double h = Sizes().sh * (1 - 0.08 - 0.06 - 0.05);
    double chiph = Sizes().sh * (1 - 0.08 - 0.06 - 0.05) * 0.06;
    return Container(
        height: h,
        color: Constants.currentMainColor,
        child: Column(
          children: [
            Container(
              height: chiph + h * 0.02,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: parameternames.length,
                  itemBuilder: (c, i) {
                    return InkWell(
                      onTap: () {
                        providerClass.setDaysChipIndex(i);
                        providerClass.setAnimateBar(true);
                        Future.delayed(Duration(seconds: 3)).then((value) {
                          providerClass.setAnimateBar(false);
                          return value;
                        });
                      },
                      child: Container(
                        height: chiph,
                        margin: EdgeInsets.all(h * 0.01),
                        padding: providerClass.hourlyChipIndex == i
                            ? EdgeInsets.all(h * 0.008)
                            : EdgeInsets.all(h * 0.012),
                        decoration: BoxDecoration(
                            border: providerClass.daysChipIndex == i
                                ? Border.all(width: 1, color: Colors.black45)
                                : null,
                            color: Constants.cardcolors[i],
                            borderRadius: BorderRadius.circular(h * 0.05),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withAlpha(150),
                                  blurRadius: 1.5,
                                  offset: Offset(1, 1))
                            ]),
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            parameternames[i],
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            providerClass.cityModels.isNotEmpty
                ? BarChart(
                    xaxislist: providerClass.cityModels[0].dailyWeatherModels
                        .map((e) => e.time)
                        .toList(),
                    yaxislist:
                        providerClass.cityModels[0].dailyWeatherModels.map((e) {
                      switch (providerClass.daysChipIndex) {
                        case 0:
                          return e.temp;

                        case 1:
                          return e.dew;

                        case 2:
                          return e.pressure;

                        case 3:
                          return e.humidity;

                        case 4:
                          return e.windspeed;

                        default:
                          return e.temp;
                      }
                    }).toList(),
                  )
                : BarChart()
            //   SfCartesianChart(
            //   primaryXAxis: CategoryAxis(),
            //   // Chart title
            //   title: ChartTitle(text: 'Half yearly sales analysis'),
            //   // Enable legend
            //   legend: Legend(isVisible: true),
            //   // Enable tooltip
            //   tooltipBehavior: TooltipBehavior(enable: true),
            //   // series: <ChartSeries<_SalesData, String>>[
            //   //   LineSeries<_SalesData, String>(
            //   //       dataSource: data,
            //   //       xValueMapper: (_SalesData sales, _) => sales.year,
            //   //       yValueMapper: (_SalesData sales, _) => sales.sales,
            //   //       name: 'Sales',
            //   //       // Enable data label
            //   //       dataLabelSettings: DataLabelSettings(isVisible: true))
            //   // ]
            //   ),
            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     //Initialize the spark charts widget
            //     child: SfSparkBarChart.custom(

            //       //Enable the trackball
            //       trackball: SparkChartTrackball(
            //           activationMode: SparkChartActivationMode.tap),
            //       //Enable marker
            //       // marker: SparkChartMarker(
            //       //     displayMode: SparkChartMarkerDisplayMode.all),
            //       //Enable data label
            //       labelDisplayMode: SparkChartLabelDisplayMode.all,
            //       xValueMapper: (int index) =>
            //       providerClass.cityModels.isEmpty? sampledata[index][0] :
            //        providerClass
            //           .cityModels[0].hourlyWeatherModels[index].time,
            //       yValueMapper: (int index) =>
            //       providerClass.cityModels.isEmpty? sampledata[index][1] :
            //       providerClass
            //           .cityModels[0].hourlyWeatherModels[index].temp,
            //       dataCount:
            //         providerClass.cityModels.isEmpty? sampledata.length :  providerClass.cityModels[0].hourlyWeatherModels.length,
            //     ),
            //   ),
            // )
          ],
        )

        // ListView.builder(
        //     itemCount: providerClass.cityModels[0].hourlyWeatherModels.length,
        //     itemBuilder: (c, i) {
        //       return Container(
        //           height: mainhourH * 0.5,
        //           child: Text(
        //               ''' ${providerClass.cityModels[0].hourlyWeatherModels[i].descrp}
        //               ${providerClass.cityModels[0].hourlyWeatherModels[i].dew}
        //               ${providerClass.cityModels[0].hourlyWeatherModels[i].temp}
        //                ${providerClass.cityModels[0].hourlyWeatherModels[i].humidity}
        //                 ${providerClass.cityModels[0].hourlyWeatherModels[i].pressure}

        //               '''));
        //     }));
        );
  }

  Widget hourlyWeather() {
    double h = Sizes().sh * (1 - 0.08 - 0.06 - 0.05);
    double chiph = Sizes().sh * (1 - 0.08 - 0.06 - 0.05) * 0.06;
    return Container(
        height: h,
        color: Constants.currentMainColor,
        child: Column(
          children: [
            Container(
              height: chiph + h * 0.02,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: parameternames.length,
                  itemBuilder: (c, i) {
                    return InkWell(
                      onTap: () {
                        providerClass.sethourlyChipIndex(i);
                        providerClass.setAnimateBar(true);
                        Future.delayed(Duration(seconds: 3)).then((value) {
                          providerClass.setAnimateBar(false);
                          return value;
                        });
                      },
                      child: Container(
                        height: chiph,
                        margin: EdgeInsets.all(h * 0.01),
                        padding: providerClass.hourlyChipIndex == i
                            ? EdgeInsets.all(h * 0.008)
                            : EdgeInsets.all(h * 0.012),
                        decoration: BoxDecoration(
                            border: providerClass.hourlyChipIndex == i
                                ? Border.all(width: 1, color: Colors.black45)
                                : null,
                            color: Constants.cardcolors[i],
                            borderRadius: BorderRadius.circular(h * 0.05),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withAlpha(150),
                                  blurRadius: 1.5,
                                  offset: Offset(1, 1))
                            ]),
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            parameternames[i],
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            providerClass.cityModels.isNotEmpty
                ? BarChart(
                    xaxislist: providerClass.cityModels[0].hourlyWeatherModels
                        .map((e) => e.time)
                        .toList(),
                    yaxislist: providerClass.cityModels[0].hourlyWeatherModels
                        .map((e) {
                      switch (providerClass.hourlyChipIndex) {
                        case 0:
                          return e.temp;

                        case 1:
                          return e.dew;

                        case 2:
                          return e.pressure;

                        case 3:
                          return e.humidity;

                        case 4:
                          return e.windspeed;

                        default:
                          return e.temp;
                      }
                    }).toList(),
                  )
                : BarChart()
            //   SfCartesianChart(
            //   primaryXAxis: CategoryAxis(),
            //   // Chart title
            //   title: ChartTitle(text: 'Half yearly sales analysis'),
            //   // Enable legend
            //   legend: Legend(isVisible: true),
            //   // Enable tooltip
            //   tooltipBehavior: TooltipBehavior(enable: true),
            //   // series: <ChartSeries<_SalesData, String>>[
            //   //   LineSeries<_SalesData, String>(
            //   //       dataSource: data,
            //   //       xValueMapper: (_SalesData sales, _) => sales.year,
            //   //       yValueMapper: (_SalesData sales, _) => sales.sales,
            //   //       name: 'Sales',
            //   //       // Enable data label
            //   //       dataLabelSettings: DataLabelSettings(isVisible: true))
            //   // ]
            //   ),
            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     //Initialize the spark charts widget
            //     child: SfSparkBarChart.custom(

            //       //Enable the trackball
            //       trackball: SparkChartTrackball(
            //           activationMode: SparkChartActivationMode.tap),
            //       //Enable marker
            //       // marker: SparkChartMarker(
            //       //     displayMode: SparkChartMarkerDisplayMode.all),
            //       //Enable data label
            //       labelDisplayMode: SparkChartLabelDisplayMode.all,
            //       xValueMapper: (int index) =>
            //       providerClass.cityModels.isEmpty? sampledata[index][0] :
            //        providerClass
            //           .cityModels[0].hourlyWeatherModels[index].time,
            //       yValueMapper: (int index) =>
            //       providerClass.cityModels.isEmpty? sampledata[index][1] :
            //       providerClass
            //           .cityModels[0].hourlyWeatherModels[index].temp,
            //       dataCount:
            //         providerClass.cityModels.isEmpty? sampledata.length :  providerClass.cityModels[0].hourlyWeatherModels.length,
            //     ),
            //   ),
            // )
          ],
        )

        // ListView.builder(
        //     itemCount: providerClass.cityModels[0].hourlyWeatherModels.length,
        //     itemBuilder: (c, i) {
        //       return Container(
        //           height: mainhourH * 0.5,
        //           child: Text(
        //               ''' ${providerClass.cityModels[0].hourlyWeatherModels[i].descrp}
        //               ${providerClass.cityModels[0].hourlyWeatherModels[i].dew}
        //               ${providerClass.cityModels[0].hourlyWeatherModels[i].temp}
        //                ${providerClass.cityModels[0].hourlyWeatherModels[i].humidity}
        //                 ${providerClass.cityModels[0].hourlyWeatherModels[i].pressure}

        //               '''));
        //     }));
        );
  }

  void checknet() async {
    await CheckInternet.instance.check().then((conn) {
      print("net before $conn && $isConnection");
      isConnection = conn;
      print("net $conn && $isConnection");
      providerClass.updateUI();
    });
  }

  void changeUI(bool visible) {
    setState(() {
      if (!visible) {
        // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
        MainScreenState().updateMainUI();
      }

      keyboardVisible = visible;

      print("rd visibility $keyboardVisible");
    });
  }

  weatherListWidget(int weathchipindex) {
    switch (weathchipindex) {
      case 0:
        return currentWeather();
      case 1:
        return hourlyWeather();
      case 2:
        return daysWeather();
      default:
        return currentWeather();
    }
  }

  animatedWidget(int i) {
    bool isOdd = i % 2 != 0;
    return TweenAnimationBuilder(
      key: UniqueKey(),
      builder: (BuildContext context, Offset value, Widget? child) {
        return Transform.translate(
          offset: providerClass.animateCurrent ? value : Offset(0, 0),
          child: Container(
            height: Sizes().sh * 0.1,
            width: Sizes().sw * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes().sh * 0.04),
              color: Constants.cardcolors[i],
            ),
            margin: EdgeInsets.only(
                top: Sizes().sh * 0.01,
                bottom: Sizes().sh * 0.01,
                left: isOdd ? Sizes().sw * 0.1 : 0,
                right: !isOdd ? Sizes().sw * 0.1 : 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Sizes().sh * 0.04),
              child: Container(
                child: Row(
                  children: isOdd
                      ? [
                          ClipRRect(
                            //  borderRadius: BorderRadius.circular( Sizes().sh * 0.04) ,
                            child: Container(
                              height: Sizes().sh * 0.1,
                              // width:Sizes().sw * 0.2,

                              color: Colors.black.withAlpha(50),
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: Sizes().sw * 0.2,
                                  ),
                                  child: Container(
                                    child: Text(
                                      providerClass.parmvalues[i],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: Sizes().sh * 0.1 * 0.34),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.all(Sizes().sh * 0.03),
                            child: FittedBox(
                                child: Text(parameternames[i]),
                                fit: BoxFit.fitHeight),
                          )),
                        ]
                      : [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.all(Sizes().sh * 0.03),
                            child: FittedBox(
                                child: Text(parameternames[i]),
                                fit: BoxFit.fitHeight),
                          )),
                          ClipRRect(
                            //  borderRadius: BorderRadius.circular( Sizes().sh * 0.04) ,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: Sizes().sw * 0.2,
                              ),
                              child: Container(
                                height: Sizes().sh * 0.1,
                                // width:Sizes().sw * 0.2,

                                color: Colors.black.withAlpha(50),
                                child: Center(
                                  child: Container(
                                    child: Text(
                                      providerClass.parmvalues[i],
                                      style: TextStyle(
                                          fontSize: Sizes().sh * 0.1 * 0.4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                ),
              ),
            ),
          ),
        );
      },
      duration: Duration(seconds: 1),
      tween: isOdd
          ? Tween<Offset>(
              begin: Offset(Sizes().sw * (-1), 0), end: Offset(0, 0))
          : Tween<Offset>(
              begin: Offset(Sizes().sw * (1), 0), end: Offset(0, 0)),
    );
  }
}

/*

    // var keyboardVisibilityController = KeyboardVisibilityController();
    // // Query
    // print(
    //     'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // // Subscribe
    // keyboardSubscription =
    //     keyboardVisibilityController.onChange.listen((bool visible) {
    //   print('Keyboard visibility update. Is visible: $visible');

    //   changeUI(visible);
    // })

*/
