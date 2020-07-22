
import 'package:base/application/app_cache.dart';
import 'package:base/application/router.dart';
import 'package:base/common/widget/popup.dart';
import 'package:base/common/widget/progress_indicator.dart';
import 'package:base/screens/home/ui/home_screen.dart';
import 'package:base/screens/init/bloc/init_bloc.dart';
import 'package:base/tools/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitScreen extends StatefulWidget {

  static String path = "/init";

  @override
  State<StatefulWidget> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {

  InitBloc _initBloc;

  @override
  void initState() {
    super.initState();
    _initBloc = BlocProvider.of<InitBloc>(context);
    _initBloc.add(InitApplication());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<InitBloc, InitState>(
        bloc: _initBloc,
        listener: (context, state) {
          if (state is InitError) {
            Popup.showAlertError(context, state.error);
          } else if (state is InitLoaded) {
            Tools.changeLocale(context, AppCache.instance.language);
            Router.push(context, HomeScreen.path);
          }
        },
        child: Container(
          child: Center(
            child: Progress.view(context, size: Size(100, 100))
          )
        ),
      )
    );
  }

}
