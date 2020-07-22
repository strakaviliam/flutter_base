
import 'package:base/application/environment/environment.dart';

class Local extends Environment {
  final String environmentName = "LOC";
  EnvironmentType environmentType = EnvironmentType.LOCAL;

  final String path = "http://192.168.0.105:9001/srvr/api";
  final String fileserverEndpoint = "http://192.168.0.105:9001/srvr/api/file";

  Local(String appVersion): super(appVersion);
}
