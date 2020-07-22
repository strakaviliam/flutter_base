
import 'package:base/screens/init/model/app_config.dart';

abstract class InitRepository {
  Future<AppConfig> loadAppInitConfig();
}
