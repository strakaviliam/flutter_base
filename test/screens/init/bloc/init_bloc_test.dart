import 'package:base/application/app_cache.dart';
import 'package:base/screens/init/bloc/init_bloc.dart';
import 'package:base/screens/init/model/app_config.dart';
import 'package:base/screens/init/repository/init_repository.dart';
import 'package:base/tools/api/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../test_tools.dart';

class MockInitRepository extends Mock implements InitRepository {}

void main() {
  group('InitBloc', () {

    InitBloc initBloc;
    MockInitRepository initRepository;

    setUp(() {
      commonSetup();
      initRepository = MockInitRepository();
      initBloc = InitBloc(initRepository);
    });

    tearDown(() {
      initBloc?.close();
    });

    test('after initialization bloc state is correct', () {
      expect(InitLoading(), initBloc.state);
    });

    test('after closing bloc does not emit any states', () {
      expectLater(initBloc, emitsInOrder([InitLoading(), emitsDone]));

      initBloc.close();
    });

    test('after InitApplication error, bloc InitError state should be emited', () async {

      final expectedResponse = [
        InitLoading(),
        InitError("error")
      ];

      when(initRepository.loadAppInitConfig()).thenThrow(ErrorResult(Result.fail("error", "")));

      expectLater(initBloc, emitsInOrder(expectedResponse));

      initBloc.add(InitApplication());

      await untilCalled(AppCache.instance.init());
      verify(AppCache.instance.init()).called(1);
    });

    test('after InitApplication success, bloc InitLoaded state should be emited', () async {

      AppConfig appConfig = AppConfig();
      final expectedResponse = [
        InitLoading(),
        InitLoaded(appConfig)
      ];

      when(initRepository.loadAppInitConfig()).thenAnswer((_) => Future.value(appConfig));

      expectLater(initBloc, emitsInOrder(expectedResponse));

      initBloc.add(InitApplication());

      await untilCalled(AppCache.instance.init());
      verify(AppCache.instance.init()).called(1);
    });
  });
}