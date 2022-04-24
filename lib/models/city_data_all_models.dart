class CityData2 {
  late double lat;
  late double lon;
  late String timezone;
  late double timezoneOffset;
  late Current current;
  late List<Minutely> minutely;
  late List<Hourly> hourly;
  late List<Daily> daily;

  CityData2(this.lat, this.lon, this.timezone, this.timezoneOffset,
      this.current, this.minutely, this.hourly, this.daily);

  CityData2.fromJson(Map<String, dynamic> json) {
    lat = double.parse(json['lat'].toString());
    lon = double.parse(json['lon'].toString());
    timezone = json['timezone'].toString();
    timezoneOffset = double.parse(json['timezone_offset'].toString());
    current =
        (json['current'] != null ? Current.fromJson(json['current']) : null)!;
    if (json['minutely'] != null) {
      minutely = <Minutely>[];
      json['minutely'].forEach((v) {
        minutely.add(Minutely.fromJson(v));
      });
    }
    if (json['hourly'] != null) {
      hourly = <Hourly>[];
      json['hourly'].forEach((v) {
        hourly.add(Hourly.fromJson(v));
      });
    }
    if (json['daily'] != null) {
      daily = <Daily>[];
      json['daily'].forEach((v) {
        daily.add(Daily.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['timezone'] = this.timezone;
    data['timezone_offset'] = this.timezoneOffset;
    if (this.current != null) {
      data['current'] = this.current.toJson();
    }
    if (this.minutely != null) {
      data['minutely'] = this.minutely.map((v) => v.toJson()).toList();
    }
    if (this.hourly != null) {
      data['hourly'] = this.hourly.map((v) => v.toJson()).toList();
    }
    if (this.daily != null) {
      data['daily'] = this.daily.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Current {
  late double dt;
  late double sunrise;
  late double sunset;
  late double temp;
  late double feelsLike;
  late double pressure;
  late double humidity;
  late double dewPodouble;
  late double uvi;
  late double clouds;
  late double visibility;
  late double windSpeed;
  late double windDeg;
  // late double windGust;
  late List<Weather> weather;

  Current(
      this.dt,
      this.sunrise,
      this.sunset,
      this.temp,
      this.feelsLike,
      this.pressure,
      this.humidity,
      this.dewPodouble,
      this.uvi,
      this.clouds,
      this.visibility,
      this.windSpeed,
      this.windDeg,
     
      this.weather);

  Current.fromJson(Map<String, dynamic> json) {
    dt = double.parse(json['dt'].toString());
    sunrise = double.parse(json['sunrise'].toString());
    sunset = double.parse(json['sunset'].toString());
    temp = double.parse(json['temp'].toString());
    feelsLike = double.parse(json['feels_like'].toString());
    pressure = double.parse(json['pressure'].toString());
    humidity = double.parse(json['humidity'].toString());
    dewPodouble = double.parse(json['dew_point'].toString());
    uvi = double.parse(json['uvi'].toString());
    clouds = double.parse(json['clouds'].toString());
    visibility = double.parse(json['visibility'].toString());
    windSpeed = double.parse(json['wind_speed'].toString());
    windDeg = double.parse(json['wind_deg'].toString());
    // windGust = double.parse(json['wind_gust'].toString());
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather.add(Weather.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['dt'] = this.dt;
    data['sunrise'] = this.sunrise;
    data['sunset'] = this.sunset;
    data['temp'] = this.temp;
    data['feels_like'] = this.feelsLike;
    data['pressure'] = this.pressure;
    data['humidity'] = this.humidity;
    data['dew_point'] = this.dewPodouble;
    data['uvi'] = this.uvi;
    data['clouds'] = this.clouds;
    data['visibility'] = this.visibility;
    data['wind_speed'] = this.windSpeed;
    data['wind_deg'] = this.windDeg;
    // data['wind_gust'] = this.windGust;
    if (this.weather != null) {
      data['weather'] = this.weather.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Weather {
  late double id;
  late String main;
  late String description;
  late String icon;

  Weather(this.id, this.main, this.description, this.icon);

  Weather.fromJson(Map<String, dynamic> json) {
    id = double.parse(json['id'].toString());
    main =json['main'].toString();
    description = json['description'].toString();
    icon = json['icon'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['main'] = this.main;
    data['description'] = this.description;
    data['icon'] = this.icon;
    return data;
  }
}

class Minutely {
  late double dt;
  late double precipitation;

  Minutely(this.dt, this.precipitation);

  Minutely.fromJson(Map<String, dynamic> json) {
    dt = double.parse(json['dt'].toString());
    precipitation = double.parse(json['precipitation'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['dt'] = this.dt;
    data['precipitation'] = this.precipitation;
    return data;
  }
}

class Hourly {
  late double dt;
  late double temp;
  late double feelsLike;
  late double pressure;
  late double humidity;
  late double dewPodouble;
  late double uvi;
  late double clouds;
  late double visibility;
  late double windSpeed;
  late double windDeg;
  // late double windGust;
  late List<Weather> weather;
  late double pop;

  Hourly(
      this.dt,
      this.temp,
      this.feelsLike,
      this.pressure,
      this.humidity,
      this.dewPodouble,
      this.uvi,
      this.clouds,
      this.visibility,
      this.windSpeed,
      this.windDeg,
     
      this.weather,
      this.pop);

  Hourly.fromJson(Map<String, dynamic> json) {
    dt = double.parse(json['dt'].toString());
    temp = double.parse(json['temp'].toString());
    feelsLike = double.parse(json['feels_like'].toString());
    pressure = double.parse(json['pressure'].toString());
    humidity = double.parse(json['humidity'].toString());
    dewPodouble = double.parse(json['dew_point'].toString());
    uvi = double.parse(json['uvi'].toString());
    clouds = double.parse(json['clouds'].toString());
    visibility = double.parse(json['visibility'].toString());
    windSpeed = double.parse(json['wind_speed'].toString());
    windDeg = double.parse(json['wind_deg'].toString());
    // windGust = double.parse(json['wind_gust'].toString());
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather.add(Weather.fromJson(v));
      });
    }
    pop = double.parse(json['pop'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['dt'] = this.dt;
    data['temp'] = this.temp;
    data['feels_like'] = this.feelsLike;
    data['pressure'] = this.pressure;
    data['humidity'] = this.humidity;
    data['dew_point'] = this.dewPodouble;
    data['uvi'] = this.uvi;
    data['clouds'] = this.clouds;
    data['visibility'] = this.visibility;
    data['wind_speed'] = this.windSpeed;
    data['wind_deg'] = this.windDeg;
    // data['wind_gust'] = this.windGust;
    if (this.weather != null) {
      data['weather'] = this.weather.map((v) => v.toJson()).toList();
    }
    data['pop'] = this.pop;
    return data;
  }
}

class Daily {
  late double dt;
  late double sunrise;
  late double sunset;
  late double moonrise;
  late double moonset;
  late double moonPhase;
  Temp? temp;
  FeelsLike? feelsLike;
  late double pressure;
  late double humidity;
  late double dewPodouble;
  late double windSpeed;
  late double windDeg;
  // late double windGust;
  late List<Weather> weather;
  late double clouds;
  late double pop;
  late double uvi;

  Daily(
      this.dt,
      this.sunrise,
      this.sunset,
      this.moonrise,
      this.moonset,
      this.moonPhase,
      this.temp,
      this.feelsLike,
      this.pressure,
      this.humidity,
      this.dewPodouble,
      this.windSpeed,
      this.windDeg,
     
      this.weather,
      this.clouds,
      this.pop,
      this.uvi);

  Daily.fromJson(Map<String, dynamic> json) {
    dt = double.parse(json['dt'].toString());
    sunrise = double.parse(json['sunrise'].toString());
    sunset = double.parse(json['sunset'].toString());
    moonrise = double.parse(json['moonrise'].toString());
    moonset = double.parse(json['moonset'].toString());
    moonPhase = double.parse(json['moon_phase'].toString());
    temp = json['temp'] != null ? Temp.fromJson(json['temp']) : null;
    feelsLike =json['feels_like'] != null
        ? FeelsLike.fromJson(json['feels_like'])
        : null;
    pressure = double.parse(json['pressure'].toString());
    humidity = double.parse(json['humidity'].toString());
    dewPodouble = double.parse(json['dew_point'].toString());
    windSpeed = double.parse(json['wind_speed'].toString());
    windDeg = double.parse(json['wind_deg'].toString());
    // windGust = double.parse(json['wind_gust'].toString());
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather.add(Weather.fromJson(v));
      });
    }
    clouds = double.parse(json['clouds'].toString());
    pop = double.parse(json['pop'].toString());
    uvi = double.parse(json['uvi'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['dt'] = this.dt;
    data['sunrise'] = this.sunrise;
    data['sunset'] = this.sunset;
    data['moonrise'] = this.moonrise;
    data['moonset'] = this.moonset;
    data['moon_phase'] = this.moonPhase;
    if (this.temp != null) {
      data['temp'] = this.temp!.toJson();
    }
    if (this.feelsLike != null) {
      data['feels_like'] = this.feelsLike!.toJson();
    }
    data['pressure'] = this.pressure;
    data['humidity'] = this.humidity;
    data['dew_point'] = this.dewPodouble;
    data['wind_speed'] = this.windSpeed;
    data['wind_deg'] = this.windDeg;
    // data['wind_gust'] = this.windGust;
    if (this.weather != null) {
      data['weather'] = this.weather.map((v) => v.toJson()).toList();
    }
    data['clouds'] = this.clouds;
    data['pop'] = this.pop;
    data['uvi'] = this.uvi;
    return data;
  }
}

class Temp {
  late double day;
  late double min;
  late double max;
  late double night;
  late double eve;
  late double morn;

  Temp(this.day, this.min, this.max, this.night, this.eve, this.morn);

  Temp.fromJson(Map<String, dynamic> json) {
    day = double.parse(json['day'].toString());
    min = double.parse(json['min'].toString());
    max = double.parse(json['max'].toString());
    night = double.parse(json['night'].toString());
    eve = double.parse(json['eve'].toString());
    morn = double.parse(json['morn'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['day'] = this.day;
    data['min'] = this.min;
    data['max'] = this.max;
    data['night'] = this.night;
    data['eve'] = this.eve;
    data['morn'] = this.morn;
    return data;
  }
}

class FeelsLike {
  late double day;
  late double night;
  late double eve;
  late double morn;

  FeelsLike(this.day, this.night, this.eve, this.morn);

  FeelsLike.fromJson(Map<String, dynamic> json) {
    day = double.parse(json['day'].toString());
    night = double.parse(json['night'].toString());
    eve = double.parse(json['eve'].toString());
    morn = double.parse(json['morn'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['day'] = this.day;
    data['night'] = this.night;
    data['eve'] = this.eve;
    data['morn'] = this.morn;
    return data;
  }
}
