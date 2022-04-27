
import 'WeatherModel.dart';

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
