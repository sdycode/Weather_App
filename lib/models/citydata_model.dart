// import 'package:json_annotation/json_annotation.dart';

// part 'citydata_model.g.dart';

// @JsonSerializable()
// class Welcome8 {
//   /// The generated code assumes these values exist in JSON.
//   final String lat,
//       lon,
//       timezone,
//       timezoneOffset,
//       current,
//       minutely,
//       hourly,
//       daily;

//   /// The generated code below handles if the corresponding JSON value doesn't
//   /// exist or is empty.
//   // final DateTime? dateOfBirth;

//   Welcome8(this.lat, this.lon, this.timezone, this.timezoneOffset, this.current, this.minutely, this.hourly, this.daily);

//   /// Connect the generated [_$PersonFromJson] function to the `fromJson`
//   /// factory.
//   factory Welcome8.fromJson(Map<String, dynamic> json) =>
//       _$Welcome8FromJson(json);

//   /// Connect the generated [_$PersonToJson] function to the `toJson` method.
//   Map<String, dynamic> toJson() => _$Welcome8ToJson(this);
// }

// // class Welcome8 {
// //     Welcome8(
// //           this.lat,
// //          this.lon,
// //           this.timezone,
// //           this.timezoneOffset,
// //           this.current,
// //           this.minutely,
// //           this.hourly,
// //           this.daily,
// //     );

// //     double lat;
// //     double lon;
// //     String timezone;
// //     int timezoneOffset;
// //     Current current;
// //     List<Minutely> minutely;
// //     List<Current> hourly;
// //     List<Daily> daily;
// //      factory Welcome8.fromJson(Map<String, dynamic> json) => Welcome8(json);

// //   /// Connect the generated [_$PersonToJson] function to the `toJson` method.
// //   Map<String, dynamic> toJson() => _$PersonToJson(this);
// // }

// // class Current {
// //     Current(
        
// //     );

// //     int dt;
// //     int sunrise;
// //     int sunset;
// //     double temp;
// //     double feelsLike;
// //     int pressure;
// //     int humidity;
// //     double dewPoint;
// //     double uvi;
// //     int clouds;
// //     int visibility;
// //     double windSpeed;
// //     int windDeg;
// //     double windGust;
// //     List<Weather> weather;
// //     int pop;
// // }

// // class Weather {
// //     Weather(
// //           this.id,
// //           this.main,
// //           this.description,
// //           this.icon,
// //     );

// //     int id;
// //     Main main;
// //     Description description;
// //     Icon icon;
// // }

// // enum Description { CLEAR_SKY, SCATTERED_CLOUDS }

// // enum Icon { THE_01_N, THE_01_D, THE_03_D }

// // enum Main { CLEAR, CLOUDS }

// // class Daily {
// //     Daily(
// //           this.dt,
// //           this.sunrise,
// //           this.sunset,
// //           this.moonrise,
// //           this.moonset,
// //           this.moonPhase,
// //           this.temp,
// //           this.feelsLike,
// //           this.pressure,
// //           this.humidity,
// //           this.dewPoint,
// //           this.windSpeed,
// //           this.windDeg,
// //           this.windGust,
// //           this.weather,
// //           this.clouds,
// //           this.pop,
// //           this.uvi,
// //     );

// //     int dt;
// //     int sunrise;
// //     int sunset;
// //     int moonrise;
// //     int moonset;
// //     double moonPhase;
// //     Temp temp;
// //     FeelsLike feelsLike;
// //     int pressure;
// //     int humidity;
// //     double dewPoint;
// //     double windSpeed;
// //     int windDeg;
// //     double windGust;
// //     List<Weather> weather;
// //     int clouds;
// //     int pop;
// //     double uvi;
// // }

// // class FeelsLike {
// //     FeelsLike(
// //           this.day,
// //           this.night,
// //           this.eve,
// //           this.morn,
// //     );

// //     double day;
// //     double night;
// //     double eve;
// //     double morn;
// // }

// // class Temp {
// //     Temp(
// //           this.day,
// //           this.min,
// //           this.max,
// //           this.night,
// //           this.eve,
// //           this.morn,
// //     );

// //     double day;
// //     double min;
// //     double max;
// //     double night;
// //     double eve;
// //     double morn;
// // }

// // class Minutely {
// //     Minutely(
// //           this.dt,
// //           this.precipitation,
// //     );

// //     int dt;
// //     int precipitation;
// // }
