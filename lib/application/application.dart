import 'package:base/application/bloc/app_bloc.dart';
import 'package:base/application/router.dart';
import 'package:base/application/simple_bloc_observer.dart';
import 'package:base/application/style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Application extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ApplicationState();
}

class _ApplicationState extends State {

  @override
  void initState() {
    super.initState();

    Bloc.observer = SimpleBlocObserver();

    //supported orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }

  @override
  Widget build(BuildContext context) {

    return EasyLocalization(
        path: 'assets/translations',
        supportedLocales: [Locale('en'), Locale('sk')],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<AppBloc>(
                create: (context) => AppBloc(),
              )
            ],
          child: ApplicationWidget()
        )
    );
  }
}

class ApplicationWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          debugShowCheckedModeBanner: false,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: Style.themeData,
          routes: Router.routes,
          initialRoute: Router.initPath,
        );
      },
    );
  }
}
