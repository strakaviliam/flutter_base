
import 'package:base/application/environment/environment.dart';

class Production extends Environment {
  final String environmentName = "";
  EnvironmentType environmentType = EnvironmentType.PRODUCTION;

  final String path = "https://api.mono.stoocq.com/test/api";
  final String fileserverEndpoint = "https://api.mono.stoocq.com/test/api/file";

  Production(String appVersion): super(appVersion);
}
