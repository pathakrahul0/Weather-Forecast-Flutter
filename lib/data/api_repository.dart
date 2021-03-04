import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:weather_forcast/core/models/weather_model.dart';
import 'package:weather_forcast/core/strings.dart';

class ApiRepository {
  Future<WeatherModel> getWeather(String cityName) async {
    // http://api.openweathermap.org/data/2.5/forecast?q=Howrah&cnt=7&appid=0ec673c9544985cfaf6907aa64ed3250&units=metric
    debugPrint(
        "URL :- $kDomain/forecast?q=$cityName&cnt=7&appid=$mWeatherAPIKey&units=metric");
    final response = await get(Uri.encodeFull(
        "http://api.openweathermap.org/data/2.5/forecast?q=$cityName&cnt=7&appid=0ec673c9544985cfaf6907aa64ed3250&units=metric"));
    if (response.statusCode == 200) {
      debugPrint("Weather Response:- ${response.body}");
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      debugPrint("Error");
    }
  }
}
