import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/models/WeatherModel.dart';
import 'package:weather/models/city_data_all_models.dart';
import 'package:weather/models/citymodel.dart';
import 'package:weather/models/date_time_epoch.dart';
import 'package:weather/providers/provider_file.dart';

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
      height: Sizes().sh - (56 + providerClass.topbarh) + 6,
      width: Sizes().sw,
      color: Constants.currentMainColor.withGreen(220),
      child: Column(
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
              print(" timeee  " +
                  DateTime.fromMillisecondsSinceEpoch(1651314777).toString());
              EpochDateTime e = EpochDateTime(1651314777);
              print("epoch is ${e.day}   ${e.year}");
            },
            child: Text("Compare All"),
            style: ButtonStyle(
                backgroundColor: providerClass.cityModels.length < 2
                    ? MaterialStateProperty.all(Colors.blueGrey.shade300)
                    : MaterialStateProperty.all(
                        Color.fromARGB(255, 146, 50, 50))),
          )
        ],
      ),
    );
  }

  addCityField() {
    return Container(
      height: Sizes().sh * 0.06,
      width: Sizes().sw * 0.7,
      margin: EdgeInsets.all(Sizes().sw * 0.05),
      child: TextField(
        controller: citynameCont,
        decoration: InputDecoration(
            hintText: "Enter city name...", contentPadding: EdgeInsets.zero),
        keyboardType: TextInputType.name,
      ),
    );
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
                citynameCont.text = getCamelCase(citynameCont.text);
                getCityData(citynameCont.text);
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

    bool checked = await CheckInternet.instance.check();
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
              EpochDateTime(  cityData2.current.dt.toInt()
              
              )
              
        
              );

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
                
                 EpochDateTime(  cityData2.hourly[i].dt.toInt())
             
                );

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
                
                                 EpochDateTime(  cityData2.daily[i].dt.toInt())

                );

            dailymodels.add(dailyTempModel);
          }

          // providerClass.addHourlyWeatherModel(weatherModel, cityNo)
          CityModel cityModel = CityModel(citynameCont.text,
              currentweathermodel, hourlymodels, dailymodels);
          providerClass.setShowCityDataLoading(false);
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
                  child: Container(
                    height: Sizes().sh * 0.08,
                    width: Sizes().sw,
                    margin: EdgeInsets.only(
                      right: Sizes().sw * 0.04,
                      left: Sizes().sw * 0.04,
                      top: Sizes().sw * 0.04,
                    ),
                    decoration: BoxDecoration(
                        color: Constants
                            .citycolors[i % (Constants.citycolors.length)],
                        borderRadius: BorderRadius.circular(Sizes().sh * 0.05),
                        boxShadow: [BoxShadow()]),
                    child: Row(
                      children: [
                        Container(
                          height: Sizes().sh * 0.08,
                          width: Sizes().sw * 0.7,
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(providerClass.cityModels[i].cityname),
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
                );
              },
              duration: Duration(seconds: 1),
              tween: Tween<Offset>(
                  begin: Offset(0, -(50 * i).toDouble()), end: Offset.zero),
            );
          })),
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
}
