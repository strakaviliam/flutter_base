import 'package:base/application/application.dart';
import 'package:flutter/material.dart';

enum EnvironmentType {
  LOCAL,
  DEVELOPMENT,
  PRODUCTION
}

abstract class Environment {

  static Environment value;

  EnvironmentType environmentType = EnvironmentType.DEVELOPMENT;
  String environmentName;

  String path;
  String fileserverEndpoint;
  String ws;

  String appVersion;

  Environment(this.appVersion) {
    value = this;
    _init();
  }

  Environment.mock() {
    appVersion = "1.0";
    path = "";
    environmentName = "mock";
  }

  void _init() {
    Application application = Application();
    runApp(application);
  }

  static Widget banner() {
    if (Environment.value.environmentType != EnvironmentType.PRODUCTION) {
      return Banner(
        message: Environment.value.environmentName,
        location: BannerLocation.topStart,
      );
    }
    return null;
  }
}
