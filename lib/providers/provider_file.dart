import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/WeatherModel.dart';
import '../models/citymodel.dart';

class ProviderClass with ChangeNotifier {
  // ---------- Fields
  int buildCount = 0;
  String temporarytext = "---=";
  String cityName = "";
  bool animateCurrent = false;
  int animatecurrntTime = 1;

  bool showOverlayPoint = false;
// index to show comare dta of cities & list of cities

  int compareCitiesTabIndex = 0;
  void setcompareCitiesTabIndex(int ij) {
    compareCitiesTabIndex = ij;
    print("ind compareCitiesTabIndex $compareCitiesTabIndex & $ij");
    notifyListeners();
  }

  // Shoe and hide overloay point hich chill show x & y values
  void setShowOverlayPoint(bool b) {
    showOverlayPoint = b;
    notifyListeners();
  }

  // Show point x,y on hover over bar graph
  Offset hoverPoint = Offset.zero;
  void seHoverOffset(Offset o) {
    hoverPoint = o;
    notifyListeners();
  }

  // Show point x,y on hover over line graph

  Offset lineHoverPoint = Offset.zero;
  void setLineHoverOffset(Offset o) {
    lineHoverPoint = o;
    notifyListeners();
  }

  // Show temporary text
  String temptext = "";
  void setTemptext(String t) {
    temptext = t;
    notifyListeners();
  }

  // Bar index where finger moved
  int barOverlayIndex = -1;
  void setbarOverlayIndex(int i) {
    barOverlayIndex = i;
    notifyListeners();
  }

  // ---------------------
  void setAnimateCurrent(bool b) {
    animateCurrent = b;
  }

  void setTempotext(String t) {
    temporarytext = t;
    print("buildcount text $temporarytext");
    notifyListeners();
  }

  void incrementBuildcounter() {
    buildCount++;
    print("buildcount $buildCount");
  }

  // Shrink factor for chart came in 1 screen
  double shrinkFactor = 1.0;
  void setShrinkFactor(double d) {
    shrinkFactor = d;
    notifyListeners();
  }
 List<String> units = ["\u00B0 C", "\u00B0 C", "hPa", "%", "m/s"];
  List<String> parmvalues = ["--", "--", "--", "--", "--"];
  List<String> parameternames = [
    'Temperature',
    'Dew Point',
    'Pressure',
    'Humidity',
    'Wind Speed'
  ];

  // Single city fields
  bool loadingInSingleCity = false;
  void setLoadingInSingleCity(bool b) {
    loadingInSingleCity = b;
    notifyListeners();
  }

  // All cities current model
  List<CityModel> cityModels = [];

  void addHourlyWeatherModelToCityModel(
      int i, List<WeatherModel> hourWeatherModels) {
    cityModels[i].hourlyWeatherModels = hourWeatherModels;
  }

  void addDailyWeatherModelToCityModel(
      int i, List<WeatherModel> dayWeatherModels) {
    cityModels[i].dailyWeatherModels = dayWeatherModels;
  }

  bool addNewCityModel(CityModel cityModel) {
    bool isNewCity = true;
    cityModels.forEach((e) {
      print('citynamme ${e.cityname} / ${cityModel.cityname}');
      if (e.cityname.toLowerCase() == cityModel.cityname.toLowerCase()) {
        isNewCity = false;
        print(
            'citynamme condiii $isNewCity ${e.cityname} / ${cityModel.cityname}');
      }
    });
    if (isNewCity) {
      cityModels.add(cityModel);
    }

    notifyListeners();
    return isNewCity;
  }

  void addHourlyWeatherModel(WeatherModel weatherModel, int cityNo) {
    cityModels[cityNo].hourlyWeatherModels.add(weatherModel);
    notifyListeners();
  }

  void addDailyWeatherModel(WeatherModel weatherModel, int cityNo) {
    cityModels[cityNo].dailyWeatherModels.add(weatherModel);
    notifyListeners();
  }

  CityModel getCityModel(int cityNo) {
    return cityModels[cityNo];
  }

  void setParamValues(List<String> params) {
    parmvalues.clear();
    print("paramsssssss $params");
    for (var e in params) {
      parmvalues.add(e);
    }
    notifyListeners();
  }

  List<String> getParams() {
    print("object parmslist $parmvalues");
    // notifyListeners();
    return parmvalues;
  }

  setParameterValuesForCity(WeatherModel currentweathermodel) {
    List<String> parametervalue = [];
    parametervalue.clear();
    parametervalue
        .add(((currentweathermodel.temp).toStringAsFixed(2)).toString());
    parametervalue
        .add(((currentweathermodel.dew).toStringAsFixed(2)).toString());
    parametervalue.add((currentweathermodel.pressure).toInt().toString());
    parametervalue.add((currentweathermodel.humidity).toInt().toString());

    parametervalue.add((currentweathermodel.windspeed).toInt().toString());
    // widget.providerClass.setParamValues(parametervalue);
    // providerClass.setAnimateCurrent(true);
    // Future.delayed(Duration(seconds: providerClass.animatecurrntTime))
    //     .then((value) {
    //   providerClass.setAnimateCurrent(false);
    // });

    return parametervalue;

  }
  // Weather chip index :

  int weathchipindex = 0;
  void setWeathchipindex(int i) {
    weathchipindex = i;
    notifyListeners();
  }

  // Parameter name in hourly data

  int hourlyChipIndex = 0;
  int daysChipIndex = 0;

  void sethourlyChipIndex(int i) {
    hourlyChipIndex = i;
    notifyListeners();
  }

  void setDaysChipIndex(int i) {
    daysChipIndex = i;
    notifyListeners();
  }

  // bool to animate or not animate graph
  bool animateBar = false;
  void setAnimateBar(bool b) {
    animateBar = b;
    notifyListeners();
  }

  void updateUI() {
    notifyListeners();
  }

  void removeCity(int i) {
    cityModels.removeAt(i);
    notifyListeners();
  }

  // show loading on when getting added city weather data
  bool showCityDataLoading = false;
  void setShowCityDataLoading(bool b) {
    showCityDataLoading = b;

    notifyListeners();
  }

  // Top bar height
  double topbarh = 24;

  void setTopBarHeight(double top) {
    topbarh = top;
    // notifyListeners();
    // removed as called in build
  }

  int chipIndexForComparingCities = 0;
  void setChipIndexForComparingCities(int i) {
    chipIndexForComparingCities = i;
    notifyListeners();
  }

  int currentCityIndex = 0;
  void setCurrentCityIndex(int i) {
    if (i >= cityModels.length) {
      return;
    }
    currentCityIndex = i;
    notifyListeners();
  }

  int selectedMainTabIndex = 0;
  void setSelectedMainTabIndex(int index) {
    selectedMainTabIndex = index;
    notifyListeners();
  }
}
