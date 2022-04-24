import 'package:flutter/foundation.dart';
import 'package:weather_app1/models/WeatherModel.dart';

import '../models/citymodel.dart';

class ProviderClass with ChangeNotifier {
  String temporarytext = "";
  void setTemptext(String t) {
    temporarytext = t;
    notifyListeners();
  }

  List<String> parmvalues = ["--", "--", "--", "--", "--", "--"];

  List<CityModel> cityModels = [];

  void addNewCityModel(CityModel cityModel) {
    cityModels.add(cityModel);
    notifyListeners();
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
}
