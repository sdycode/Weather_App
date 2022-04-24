import 'package:weather_app1/models/WeatherModel.dart';

class CityModel {
  late WeatherModel currentWeatherModel;
  late List<WeatherModel> hourlyWeatherModels;
  late List<WeatherModel> dailyWeatherModels;
  CityModel(
    this.currentWeatherModel, 
    this.hourlyWeatherModels, 
    this.dailyWeatherModels
  );
}
