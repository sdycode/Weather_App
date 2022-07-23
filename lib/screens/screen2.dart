import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weather/models/WeatherModel.dart';
import 'package:weather/models/city_data_all_models.dart';
import 'package:weather/models/citymodel.dart';
import 'package:weather/models/date_time_epoch.dart';
import 'package:weather/providers/provider_file.dart';
import 'package:weather/widgets/lineChart.dart';
import 'package:weather/widgets/multi_bar_chart.dart';

import '../constants/constants.dart';
import '../constants/sizes.dart';

import '../models/WeatherModel.dart';
import '../utils/checkinternet.dart';
import 'package:http/http.dart' as http;

import '../widgets/pouring_glass_animatiom.dart';

class Screen2 extends StatefulWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  TextEditingController citynameCont = TextEditingController();
  double h = Sizes().sh;
  double w = Sizes().sw;
  late ProviderClass providerClass;

  bool isConnection = false;

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
  @override
  Widget build(BuildContext context) {
    providerClass = Provider.of<ProviderClass>(context);

    return Container(
      height: Sizes().sh - (56 + providerClass.topbarh) + 6 - 15,
      width: Sizes().sw,
      color: Constants.currentMainColor.withGreen(220),
      child: tabs(providerClass.compareCitiesTabIndex),
    );
  }

  Widget tabs(int compareCitiesTabIndex) {
    switch (compareCitiesTabIndex) {
      case 0:
        return tab0();
      case 1:
        return tab1();

      default:
        return tab0();
    }
  }

  addCityField() {
    return Container(
        height: Sizes().sh * 0.06,
        width: Sizes().sw * 0.7,
        margin: EdgeInsets.all(Sizes().sw * 0.05),
        child: Stack(
          children: [
            Container(
              child: TextField(
                controller: citynameCont,
                decoration: InputDecoration(
                    hintText: "Enter city name...",
                    contentPadding: EdgeInsets.zero),
                keyboardType: TextInputType.name,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                child: IconButton(
                    onPressed: () {
                      if (!providerClass.showCityDataLoading) {
                        setState(() {
                          citynameCont.clear();
                        });
                      }
                    },
                    icon: Icon(Icons.close)),
              ),
            )
          ],
        ));
  }

  addcityButton() {
    return Container(
      height: Sizes().sh * 0.06,
      width: Sizes().sw * 0.16,
      // color: Colors.red,
      child: FittedBox(
          fit: BoxFit.contain,
          child: InkWell(
              onTap: () {
                if (!providerClass.showCityDataLoading) {
                  citynameCont.text = getCamelCase(citynameCont.text);
                  getCityData(citynameCont.text);
                }
              },
              child: Padding(
                padding: EdgeInsets.all(Sizes().sw * 0.021),
                child: Icon(Icons.add_box),
              ))),
    );
  }

  void getCityData(String cityname) async {
    FocusManager.instance.primaryFocus?.unfocus();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    bool checked = await checkConnectivityStatus();
    if (checked) {
      if (citynameCont.text.isNotEmpty) {
        providerClass.setShowCityDataLoading(true);
        String url =
            "http://api.openweathermap.org/geo/1.0/direct?q=${citynameCont.text}&appid=${Constants.apikey1}";
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
                      "Sorry data is not available for ${citynameCont.text}")));
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(nocitysnackbar);
          providerClass.setShowCityDataLoading(false);
          return;
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
              cityData2.current.temp - 273.15,
              cityData2.current.dewPodouble - 273.15,
              cityData2.current.pressure,
              cityData2.current.humidity,
              cityData2.current.windSpeed,
              cityData2.current.dt,
              EpochDateTime(cityData2.current.dt.toInt()));

          List<WeatherModel> hourlymodels = [];
          List<WeatherModel> dailymodels = [];

          for (int i = 0; i < cityData2.hourly.length; i++) {
            WeatherModel hourlytempmodel = WeatherModel(
                cityData2.hourly[i].weather[0].description,
                imgurl,
                cityData2.hourly[i].temp - 273.15,
                cityData2.hourly[i].dewPodouble - 273.15,
                cityData2.hourly[i].pressure,
                cityData2.hourly[i].humidity,
                cityData2.hourly[i].windSpeed,
                cityData2.hourly[i].dt,
                EpochDateTime(cityData2.hourly[i].dt.toInt()));

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
                cityData2.daily[i].dt,
                EpochDateTime(cityData2.daily[i].dt.toInt()));

            dailymodels.add(dailyTempModel);
          }

          // providerClass.addHourlyWeatherModel(weatherModel, cityNo)
          CityModel cityModel = CityModel(citynameCont.text,
              currentweathermodel, hourlymodels, dailymodels);
          providerClass.setShowCityDataLoading(false);

          bool isNewCityAdded = providerClass.addNewCityModel(cityModel);
             providerClass.currentCityIndex = providerClass.cityModels.length - 1;
          if (!isNewCityAdded) {
            snack('This city is already added');
          }
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
          // providerClass.setAnimateCurrent(true);
          // Future.delayed(Duration(seconds: providerClass.animatecurrntTime))
          //     .then((value) {
          //   providerClass.setAnimateCurrent(false);
          // });
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
        providerClass.setShowCityDataLoading(false);
        return;
      }
    } else {
      setState(() {
        showDialog(
            context: context,
            builder: (c) {
              return Dialog(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(Sizes().sh * 0.15))),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: Sizes().sh * 0.15,
                    width: Sizes().sw * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade300.withAlpha(180),
                    ),
                    child: FittedBox(
                        child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        "Please check your\ninternet connection !!!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    )),
                  ),
                ),
              );
            });
      });
      return;
    }
  }

  Widget citiesList() {
    return Container(
      child: ListView.builder(
          itemCount: providerClass.cityModels.length,
          itemBuilder: ((c, i) {
            return TweenAnimationBuilder<Offset>(
              builder: (BuildContext context, Offset value, Widget? child) {
                return Transform.translate(
                  offset: value,
                  child: InkWell(
                    onTap: () {
                      providerClass.setCurrentCityIndex(i);

                      providerClass.setWeathchipindex(0);
                      List<String> currentCityParametervalue =
                          providerClass.setParameterValuesForCity(
                              providerClass.cityModels[i].currentWeatherModel);

                      providerClass.setParamValues(currentCityParametervalue);
                      providerClass.setSelectedMainTabIndex(0);
                    },
                    child: Container(
                      height: Sizes().sh * 0.06,
                      width: Sizes().sw,
                      margin: EdgeInsets.only(
                        right: Sizes().sw * 0.04,
                        left: Sizes().sw * 0.04,
                        top: Sizes().sw * 0.04,
                      ),
                      decoration: BoxDecoration(
                          color: Constants
                              .citycolors[i % (Constants.citycolors.length)],
                          borderRadius:
                              BorderRadius.circular(Sizes().sh * 0.05),
                          boxShadow: [BoxShadow()]),
                      child: Row(
                        children: [
                          Container(
                            height: Sizes().sh * 0.06,
                            width: Sizes().sw * 0.7,
                            child: FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child:
                                    Text(providerClass.cityModels[i].cityname),
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: Sizes().sh * 0.08,
                            width: Sizes().sw * 0.16,
                            child: FittedBox(
                              child: IconButton(
                                  onPressed: () {
                                    providerClass.removeCity(i);
                                  },
                                  icon: Icon(Icons.close)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              duration: Duration(milliseconds: 300),
              tween: Tween<Offset>(
                  begin: Offset(0, -(50 * i).toDouble()), end: Offset.zero),
            );
          })),
    );
  }

  paramterChipsRow() {
    double chiph = h * 0.05;
    return Container(
      height: chiph + h * 0.02,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: parameternames.length,
          itemBuilder: (c, i) {
            return InkWell(
              onTap: () {
                providerClass.setChipIndexForComparingCities(i);
              },
              child: Container(
                height: chiph,
                margin: EdgeInsets.all(h * 0.01),
                padding: providerClass.chipIndexForComparingCities == i
                    ? EdgeInsets.all(h * 0.008)
                    : EdgeInsets.all(h * 0.012),
                decoration: BoxDecoration(
                    border: providerClass.chipIndexForComparingCities == i
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
    );
  }

  String getCamelCase(String text) {
    if (text.isNotEmpty) {
      return text.characters.length > 1
          ? (text.characters.first.toUpperCase() +
              text.substring(1).toLowerCase())
          : text.toUpperCase();
    } else {
      return text;
    }
  }

  Widget tab0() {
    return Column(
      children: [
        Row(
          children: [addCityField(), addcityButton()],
        ),
        providerClass.showCityDataLoading
            ? SpinKitPouringHourGlassRefined(
                color: Color.fromARGB(255, 9, 16, 67), size: Sizes().sh * 0.2)
            : Container(),
        Expanded(
          child: Container(width: Sizes().sw, child: citiesList()),
        ),
        ElevatedButton(
          onPressed: () {
            // print(" timeee  " +
            //     DateTime.fromMillisecondsSinceEpoch(1651314777).toString());
            // EpochDateTime e = EpochDateTime(1651314777);
            // print("epoch is ${e.day}   ${e.year}");
            if (providerClass.cityModels.length > 1 &&
                !providerClass.showCityDataLoading) {
              providerClass.setcompareCitiesTabIndex(1);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Please add atleast 2 cities'),
                action: SnackBarAction(
                    label: 'CLOSE',
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    }),
              ));
            }
          },
          child: Text("Compare All"),
          style: ButtonStyle(
              backgroundColor: providerClass.cityModels.length < 2
                  ? MaterialStateProperty.all(Constants.chipNoNColor)
                  : MaterialStateProperty.all(Constants.chipColor)),
        )
      ],
    );
  }

  void snack(String s) {
    SnackBar snackBar = SnackBar(content: Text(s));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget tab1() {
    // return Container(
    //   height: 300,
    //   width: 300,
    //   color: Colors.purple,
    //   child: Column(
    //     children: [Text("dsd"),
    //     Text("jdk"),
    //     Spacer(),

    //     Container(
    //       height:10,
    //       color: Colors.red,
    //     )],
    //   ),
    // );
    print('tab1 called ${Random().nextInt(500)}');
    print(
        'lengg daily ${providerClass.cityModels[0].dailyWeatherModels.length} /  hour ${providerClass.cityModels[0].hourlyWeatherModels.length}');

    List<List<List<List<double>>>> allParamtersYvalueswrtWeatherTime = [];
    // List<String> parameternames = [
    //   'Temperature',
    //   'Dew Point',
    //   'Pressure',
    //   'Humidity',
    //   'Wind Speed'
    // ];
    for (var i = 0; i < parameternames.length; i++) {
      allParamtersYvalueswrtWeatherTime =
          addValues(allParamtersYvalueswrtWeatherTime, i);
      print('addle ${allParamtersYvalueswrtWeatherTime.length}');
      // switch (parameternames[i]) {
      //   case 'Temperature':

      //     break;
      //   default:
      // }
    }

    // print(
    //     'tab1 called already ${yvalueswrtWeatherTime[providerClass.weathchipindex][0].length}  ${Random().nextInt(500)}');
    return Container(
      height: Sizes().sh * 0.8,
      color: Color.fromARGB(255, 244, 239, 241),
      child: Column(
        children: [
          paramterChipsRow(),
          citiesColorIndex(),
          Spacer(),
          MultiBarChart(
              allParamtersYvalueswrtWeatherTime[providerClass
                  .chipIndexForComparingCities][providerClass.weathchipindex],
              w,
              h * 0.55),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              weatherChip(h, " Current ", 0),
              weatherChip(h, " Hourly ", 1),
              weatherChip(h, " Daily ", 2),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    onPressed: () {
                      providerClass.setcompareCitiesTabIndex(0);
                    },
                    icon: Icon(Icons.close)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget weatherChip(double h, String weathername, int i) {
    return InkWell(
      onTap: () {
        providerClass.setWeathchipindex(i);
        providerClass.setShrinkFactor(1.0);
        // myAnimationController.reset();
        // myAnimationController.forward();
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

  getLineChart() {
    return LineChart(
        xaxislist: providerClass.cityModels[0].hourlyWeatherModels
            .map((e) => Text(e.epTime.hour.toString()))
            .toList(),
        yaxislist: providerClass.cityModels[0].hourlyWeatherModels.map((e) {
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
        h: Sizes().sh * 0.7,
        w: Sizes().sw * 0.95,
        xh: 0.10,
        xaxisname: "Time",
        yaxisname: parameternames[providerClass.hourlyChipIndex] +
            "( ${providerClass.units[providerClass.hourlyChipIndex]} )");
  }

  List<List<List<List<double>>>> addValues(
      List<List<List<List<double>>>> allParamtersYvalueswrtWeatherTime, int i) {
    List<List<List<List<double>>>> l =
        List.from(allParamtersYvalueswrtWeatherTime);
    List<List<List<double>>> yvalueswrtWeatherTime = [];
    List<List<double>> yAxisValuesOfCitiesCurrent = [];
    providerClass.cityModels.forEach((e) {
      switch (i) {
        case 0:
          yAxisValuesOfCitiesCurrent.add([e.currentWeatherModel.temp]);
          break;
        case 1:
          yAxisValuesOfCitiesCurrent.add([e.currentWeatherModel.dew]);
          break;
        case 2:
          yAxisValuesOfCitiesCurrent.add([e.currentWeatherModel.pressure]);
          break;

        case 3:
          yAxisValuesOfCitiesCurrent.add([e.currentWeatherModel.humidity]);
          break;
        case 4:
          yAxisValuesOfCitiesCurrent.add([e.currentWeatherModel.windspeed]);
          break;
        default:
      }
    });
    List<List<double>> yAxisValuesOfCitiesHourly = [];
    providerClass.cityModels.forEach((e) {
      print('eee city in hourly ${i}------------ ${e.cityname}');
      // yAxisValuesOfCitiesHourly
      //     .add(e.hourlyWeatherModels.map((e) => e.temp).toList());

      switch (i) {
        case 0:
          yAxisValuesOfCitiesHourly
              .add(e.hourlyWeatherModels.map((e) => e.temp).toList());
          break;
        case 1:
          yAxisValuesOfCitiesHourly
              .add(e.hourlyWeatherModels.map((e) => e.dew).toList());
          break;
        case 2:
          yAxisValuesOfCitiesHourly
              .add(e.hourlyWeatherModels.map((e) => e.pressure).toList());
          break;

        case 3:
          yAxisValuesOfCitiesHourly
              .add(e.hourlyWeatherModels.map((e) => e.humidity).toList());
          break;
        case 4:
          yAxisValuesOfCitiesHourly
              .add(e.hourlyWeatherModels.map((e) => e.windspeed).toList());
          break;
        default:
      }
    });

    List<List<double>> yAxisValuesOfCitiesDaily = [];
    providerClass.cityModels.forEach((e) {
      print('eee city in daily------------ ${e.cityname}');
      // yAxisValuesOfCitiesDaily.add(e.dailyWeatherModels.map((ee) {
      //   print('eee ${ee.temp}');
      //   return ee.temp;
      // }).toList());

      switch (i) {
        case 0:
          yAxisValuesOfCitiesDaily
              .add(e.dailyWeatherModels.map((e) => e.temp).toList());
          break;
        case 1:
          yAxisValuesOfCitiesDaily
              .add(e.dailyWeatherModels.map((e) => e.dew).toList());
          break;
        case 2:
          yAxisValuesOfCitiesDaily
              .add(e.hourlyWeatherModels.map((e) => e.pressure).toList());
          break;

        case 3:
          yAxisValuesOfCitiesDaily
              .add(e.dailyWeatherModels.map((e) => e.humidity).toList());
          break;
        case 4:
          yAxisValuesOfCitiesDaily
              .add(e.dailyWeatherModels.map((e) => e.windspeed).toList());
          break;
        default:
      }
    });
    yvalueswrtWeatherTime.addAll([
      yAxisValuesOfCitiesCurrent,
      yAxisValuesOfCitiesHourly,
      yAxisValuesOfCitiesDaily
    ]);
    l.add(yvalueswrtWeatherTime);
    return l;
  }

  citiesColorIndex() {
    return Container(
      height: h * 0.18,
      width: w,
      // color: Colors.purple.shade100,
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            // ...(List.generate(50, (i) => cityBox((i*100).toString() ,i))),
            ...(providerClass.cityModels.map((e) {
              int i = providerClass.cityModels.indexOf(e);
              return cityBox(e.cityname, i);
            }))
          ],
        ),
      ),
    );
  }

  cityBox(String cityname, int i) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(w * 0.01),
            height: w * 0.05,
            width: w * 0.05,
            color: Constants.citycolors[i % Constants.citycolors.length],
          ),
          Text(
            cityname,
            style: TextStyle(fontSize: w * 0.04, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double? y;
}

class Data {
  Data(this.x, this.y);
  final Widget? x;
  final double? y;
}
