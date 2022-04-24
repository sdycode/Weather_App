import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weather_app1/models/WeatherModel.dart';
import 'package:weather_app1/models/citymodel.dart';
import 'package:weather_app1/providers/provider_file.dart';
import 'package:weather_app1/screens/main_screen.dart';

import '../constants/sizes.dart';
import 'package:weather_app1/constants/sizes.dart';
import 'package:weather_app1/models/city_data_all_models.dart';
import 'package:weather_app1/utils/checkinternet.dart';

import '../constants/constants.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class Screen1 extends StatefulWidget {
  double topbarh;
  Screen1(this.topbarh, {Key? key}) : super(key: key);
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
class _Screen1State extends State<Screen1> {
  late StreamSubscription<bool> keyboardSubscription;

  bool isConnection = false;
  late ProviderClass providerClass;
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
    'Visibility',
    'Wind Speed'
  ];
  List<String> parametervalue = [
    '-',
    '-',
    '-',
    '-',
    '-',
    '-',
  ];
  String imgurl = "http://openweathermap.org/img/wn/10d@2x.png";
  List<Widget> weatherList = [];
  int weatherdayindex = 0;
  bool keyboardVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');

      changeUI(visible);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("visi top ${MediaQuery.of(context).viewPadding.top}");
    providerClass = Provider.of<ProviderClass>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    weatherList.addAll([currentWeather(), hourlyWeather(), daysWeather()]);

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
                weatherList[weatherdayindex],
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    weatherChip(h, " Current "),
                    weatherChip(h, " Hourly "),
                    weatherChip(h, " Daily ")
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Container weatherChip(double h, String weathername) {
    return Container(
      height: h * 0.05,
      margin: EdgeInsets.all(h * 0.01),
      padding: EdgeInsets.all(h * 0.01),
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(h * 0.025),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 1.5, offset: Offset(1, 1))
          ]),
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Text(weathername),
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
              cityData2.current.dewPodouble,
              cityData2.current.pressure,
              cityData2.current.humidity,
              cityData2.current.visibility,
              cityData2.current.windSpeed);

          List<WeatherModel> hourlymodels = [];
          List<WeatherModel> dailymodels = [];

          CityModel cityModel =
              CityModel(currentweathermodel, hourlymodels, dailymodels);
          providerClass.addNewCityModel(cityModel);

          setState(() {
            parametervalue.clear();
            parametervalue.add(
                ((currentweathermodel.temp - 273.15).toStringAsFixed(2))
                    .toString());
            parametervalue.add(
                ((currentweathermodel.dew - 273.15).toStringAsFixed(2))
                    .toString());
            parametervalue.add(
                (currentweathermodel.pressure).toStringAsFixed(2).toString());
            parametervalue.add(
                (currentweathermodel.humidity).toStringAsFixed(2).toString());
            parametervalue.add(
                (currentweathermodel.visibility).toStringAsFixed(2).toString());
            parametervalue.add(
                (currentweathermodel.windspeed).toStringAsFixed(2).toString());
            // providerClass.setParamValues(parametervalue);
            providerClass.setParamValues([
              (currentweathermodel.temp - 273.15).toString(),
              (currentweathermodel.dew - 273.15).toString(),
              currentweathermodel.pressure.toString(),
              currentweathermodel.humidity.toString(),
              currentweathermodel.visibility.toString(),
              currentweathermodel.windspeed.toString()
            ]);

            print('***************88888888888**');
            print(parametervalue);
            print('*****************');
            // citynameresponse = responseData.toString();

            // oneapiresponsedata = oneapiResponse.toString();
          });
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
    providerClass.getParams().forEach(((element) {
      print("element $element $i");
      l.add(element);
    }));

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
        children: [Text(l[i])],
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
        children: [],
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
      height:mainh ,
      color: Colors.blue.shade200.withAlpha(255),
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
          SizedBox(
            height: 0,
          ),
          Container(
            height:mainh-( Sizes().sh * 0.06 + 8), 
              

            width: Sizes().sw,
            // margin: EdgeInsets.all(h * 0.01),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [samplecard(0), samplecard(1)],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [samplecard(2), samplecard(3)],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [samplecard(4), samplecard(5)],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [description(), iconcard()],
                  ),
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
    ;
  }

  Widget daysWeather() {
    return Container();
  }

  Widget hourlyWeather() {
    return Container();
  }

  void checknet() async {
    await CheckInternet.instance.check().then((conn) {
      setState(() {
        print("net before $conn && $isConnection");
        isConnection = conn;
        print("net $conn && $isConnection");
      });
    });
    setState(() {});
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
}
