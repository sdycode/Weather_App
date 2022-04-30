import 'package:weather/models/date_time_epoch.dart';

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

  late double windspeed;
  late double time;
  late EpochDateTime epTime;

  WeatherModel(this.descrp, this.icon, this.temp, this.dew, this.pressure,
      this.humidity, this.windspeed, this.time, 
      
      this.epTime
      );
}
