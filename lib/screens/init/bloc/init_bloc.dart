import 'dart:async';

import 'package:base/application/app_cache.dart';
import 'package:base/screens/init/model/app_config.dart';
import 'package:base/screens/init/repository/init_repository.dart';
import 'package:base/tools/api/result.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'init_event.dart';
part 'init_state.dart';

class InitBloc extends Bloc<InitEvent, InitState> {

  final InitRepository repository;

  InitBloc(this.repository) : super(InitLoading());

  @override
  Stream<InitState> mapEventToState(InitEvent event) async* {
    if (event is InitApplication) {
      yield* _mapInitApplicationToState();
    }
  }

  Stream<InitState> _mapInitApplicationToState() async* {
    await AppCache.instance.init();
    try {
      AppConfig appConfig = await repository.loadAppInitConfig();
      yield InitLoaded(appConfig);
    } on ErrorResult catch (ex) {
      yield InitError(ex.result.error);
    }
  }
}
