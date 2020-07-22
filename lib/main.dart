import 'package:base/application/environment/development.dart';
import 'package:base/application/environment/environment.dart';
import 'package:base/application/environment/production.dart';
import 'application/environment/local.dart';

void main() {

  EnvironmentType environment = EnvironmentType.DEVELOPMENT;
  String appVersion = "0.0.1";

  //run environment
  switch (environment) {
    case EnvironmentType.LOCAL: {
      Local(appVersion);
    } break;
    case EnvironmentType.DEVELOPMENT: {
      Development(appVersion);
    } break;
    case EnvironmentType.PRODUCTION: {
      Production(appVersion);
    } break;
  }
}
