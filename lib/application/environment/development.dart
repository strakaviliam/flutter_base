
import 'package:base/application/environment/environment.dart';

class Development extends Environment {
  final String environmentName = "DEV";
  EnvironmentType environmentType = EnvironmentType.DEVELOPMENT;

  final String path = "https://api.mono.stoocq.com/test/api";
  final String fileserverEndpoint = "https://api.mono.stoocq.com/test/api/file";

  Development(String appVersion): super(appVersion);
}
