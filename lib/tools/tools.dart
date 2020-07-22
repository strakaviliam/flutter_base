
import 'package:base/application/app_cache.dart';
import 'package:base/application/bloc/app_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'generator.dart';

class Tools {

  static String uuid() {
    return Uuid().v4();
  }

  static String randomString({int length = 10}) {
    return Generator.randomString(length);
  }

  static changeLocale(BuildContext context, String locale) {
    BlocProvider.of<AppBloc>(context).add(ChangeLocale(context, AppCache.instance.language));
  }
}
