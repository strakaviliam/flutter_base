
import 'package:base/application/app_cache.dart';
import 'package:flutter/material.dart';

class Style {

  static ThemeData get themeData {
    //application theme
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.lightBlue[800],
      accentColor: Colors.cyan[600],
      fontFamily: AppCache.instance.appFont[AppCache.instance.language],

      textTheme: TextTheme(
        headline3: TextStyle(fontSize: 28.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, color: Colors.black),
        headline5: TextStyle(fontSize: 20.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.normal, color: Colors.black),
        subtitle1: TextStyle(fontSize: 17.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.normal, color: Colors.black),
        bodyText1: TextStyle(fontSize: 14.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.normal, color: Colors.black),
      )
    );
  }
}
