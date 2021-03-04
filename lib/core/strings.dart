import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

const kDomain = " http://api.openweathermap.org/data/2.5";
const mWeatherAPIKey = "0ec673c9544985cfaf6907aa64ed3250";

class Utils{
  static String getFormattedDate(DateTime dateTime){
    return DateFormat("EEEE, MMM d, y").format(dateTime);
  }


}


List<String> kCountries = ['in', 'us', 'dk', 'nz', 'fr', 'gb', 'ca'];
List<String> kCountryNames = [
  'India',
  'America',
  'Denmark',
  'New Zealand',
  'France',
  'United Kingdom',
  'Canada'
];
