import 'dart:async';

import 'package:base/application/app_cache.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState());

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is ChangeLocale) {
      yield* _mapChangeLocaleToState(event);
    }
  }

  Stream<AppState> _mapChangeLocaleToState(ChangeLocale event) async* {

    AppCache.instance.setLocale(event.language);
    EasyLocalization.of(event.context).locale = Locale(event.language);

    yield state;
  }
}
