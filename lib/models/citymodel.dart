import 'WeatherModel.dart';

class CityModel {
  String cityname = "City Name";
  late WeatherModel currentWeatherModel;
  late List<WeatherModel> hourlyWeatherModels;
  late List<WeatherModel> dailyWeatherModels;
  CityModel(this.cityname, this.currentWeatherModel, this.hourlyWeatherModels,
      this.dailyWeatherModels);
}
