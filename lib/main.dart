import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_forcast/core/strings.dart';
import 'package:weather_forcast/data/api_repository.dart';
import 'package:weather_forcast/core/models/weather_model.dart';

import 'core/colors.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WeatherApp(),
  ));
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  Future<WeatherModel> weatherData;

  var _currentCity = "Howrah";

  @override
  void initState() {
    super.initState();
    weatherData = getCityWeather(_currentCity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              searchField(),
              Container(
                child: FutureBuilder<WeatherModel>(
                  future: weatherData,
                  builder: (BuildContext context,
                      AsyncSnapshot<WeatherModel> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          dataListView(snapshot),
                          bottomView(snapshot, context)
                        ],
                      );
                    } else {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchField() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search_rounded),
          hintText: "Search City",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.all(8),
        ),
        onSubmitted: (values) {
          setState(() {
            _currentCity = values;
            weatherData = getCityWeather(_currentCity);
          });
        },
      ),
    );
  }

  Future<WeatherModel> getCityWeather(String cityName) =>
      ApiRepository().getWeather(_currentCity);

  Widget dataListView(AsyncSnapshot<WeatherModel> snapshot) {
    var forecastList = snapshot.data.nextDayList;
    var cityName = snapshot.data.city.name;
    var countryName = snapshot.data.city.country;
    var formattedDateTime =
        DateTime.fromMillisecondsSinceEpoch(forecastList[0].dt * 1000);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 8,),
          Text(
            "$cityName, $countryName",
            style: TextStyle(
              color: kDeepOrange,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8,),
          Text(
            "${Utils.getFormattedDate(formattedDateTime)}",
            style: TextStyle(
              color: kDeepOrange,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          getWeatherIcons(
            weatherDescription: forecastList[0].weather[0].main,
            color: Colors.amber,
            size: 140,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${forecastList[0].main.temp.toStringAsFixed(0)} °C",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 4,),
                Text(
                  "${forecastList[0].weather[0].description}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${forecastList[0].wind.speed.toStringAsFixed(0)} m/s",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Icon(
                      FontAwesomeIcons.wind,
                      color: Colors.cyanAccent,
                      size: 20,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${forecastList[0].main.humidity.toStringAsFixed(0)} %",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Icon(
                      FontAwesomeIcons.solidGrinBeamSweat,
                      color: Colors.brown,
                      size: 20,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${forecastList[0].main.tempMax.toStringAsFixed(0)} °C",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Icon(
                      FontAwesomeIcons.temperatureHigh,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget getWeatherIcons(
      {String weatherDescription, Color color, double size}) {
    switch (weatherDescription) {
      case "Clear":
        return Icon(FontAwesomeIcons.sun, color: color, size: size);
        break;
      case "Rain":
        return Icon(FontAwesomeIcons.cloudRain, color: color, size: size);
        break;
      case "Clouds":
        return Icon(FontAwesomeIcons.cloud, color: color, size: size);
        break;
      case "Snow":
        return Icon(FontAwesomeIcons.snowman, color: color, size: size);
        break;
      default:
        return Icon(FontAwesomeIcons.sun, color: color, size: size);
        break;
    }
  }

  Widget bottomView(
      AsyncSnapshot<WeatherModel> snapshot, BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "${snapshot.data.nextDayList.length} Days Forecast List",
            style: TextStyle(
              color: kDeepOrange,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Container(
            height: 150,
            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(
                      width: 8,
                    ),
                itemCount: snapshot.data.nextDayList.length,
                itemBuilder: (context, index) => ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 140,
                        child: forecastCard(snapshot, context, index),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Colors.deepPurpleAccent,
                          Colors.white,
                        ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                      ),
                    )),
          )
        ],
      ),
    );
  }

  forecastCard(
      AsyncSnapshot<WeatherModel> snapshot, BuildContext context, int index) {
    var forecastList = snapshot.data.nextDayList;
    var dayOfWeek = Utils.getFormattedDate(DateTime.fromMillisecondsSinceEpoch(forecastList[index].dt * 1000)).split(",")[0];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$dayOfWeek",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: getWeatherIcons(
                    weatherDescription:
                        snapshot.data.nextDayList[index].weather[0].main,
                    color: Colors.cyanAccent,
                    size: 40),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "${forecastList[index].wind.speed.toStringAsFixed(0)} m/s",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "${forecastList[index].main.humidity.toStringAsFixed(0)} %",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "${forecastList[index].main.tempMax.toStringAsFixed(0)} °C",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
