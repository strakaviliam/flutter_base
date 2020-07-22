
import 'package:base/application/environment/environment.dart';
import 'package:base/screens/init/model/app_config.dart';
import 'package:base/screens/init/repository/init_repository.dart';
import 'package:base/tools/api/api.dart';
import 'package:base/tools/api/result.dart';

class InitRepositoryApi implements InitRepository {

  Api _appInitApi;

  InitRepositoryApi({Api appInitApi}) {
    _appInitApi = appInitApi ?? Api("/app/init", method: HTTPMethod.post, publicAPI: true);
  }

  @override
  Future<AppConfig> loadAppInitConfig() async {
    Result result = await _appInitApi.call(parameters: {
      "version": Environment.value.appVersion
    });

    if (result.status == Status.fail) {
      throw ErrorResult(result);
    }

    return AppConfig.fromMap(Map<String, dynamic>.of(result.data));
  }
}
