
import 'package:base/screens/init/model/app_config.dart';
import 'package:base/screens/init/repository/init_repository_api.dart';
import 'package:base/tools/api/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../test_tools.dart';

void main() {
  group('InitRepositoryApi', () {
    MockApi appInitApi;
    InitRepositoryApi initRepositoryApi;

    setUp(() {
      commonSetup();
      appInitApi = MockApi();
      initRepositoryApi = InitRepositoryApi(appInitApi: appInitApi);
    });

    test('after call loadAppInitConfig error response throw ErrorResult', () async {
      when(appInitApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(Result.fail("error", "")));

      try {
        await initRepositoryApi.loadAppInitConfig();
      } catch (ex) {
        expect(ex, isInstanceOf<ErrorResult>());
      }
    });

    test('after call loadAppInitConfigsuccess response return AppConfig', () async {
      Map<String, dynamic> json = (await mockedJson("app_config"))["body"];
      Result result = Result.success(json, "");

      when(appInitApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(result));

      expect(await initRepositoryApi.loadAppInitConfig(), AppConfig.fromMap(json));
    });
  });
}
