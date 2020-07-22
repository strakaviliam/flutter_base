
import 'package:equatable/equatable.dart';

class AppConfig extends Equatable {
  String actualVersion;
  bool canUpgrade;
  bool needUpgrade;

  AppConfig();

  AppConfig.fromMap(Map<String, dynamic> map) {
    actualVersion = map["version"];
    canUpgrade = map["canUpgrade"];
    needUpgrade = map["needUpgrade"];
  }

  @override
  String toString() => 'AppConfig { '
      'actualVersion: $actualVersion, '
      'canUpgrade: $canUpgrade, '
      'needUpgrade: $needUpgrade }';

  @override
  List<Object> get props => [actualVersion, canUpgrade, needUpgrade];
}
