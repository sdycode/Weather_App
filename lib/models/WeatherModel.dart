class WeatherModel {
// temp
// dew point
// pressure
// humidiy
// visibiliity
// wind sepped
// descrp
// icon
  late String descrp;
  late String icon;
  late double temp;
  late double dew;
  late double pressure;
  late double humidity;
  late double visibility;
  late double windspeed;

  WeatherModel(
    this.descrp,
    this.icon,
    this.temp,
    this.dew,
    this.pressure,
    this.humidity,
    this.visibility,
    this.windspeed,
  );
}
