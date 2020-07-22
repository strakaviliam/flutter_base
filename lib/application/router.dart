
import 'package:base/application/app_cache.dart';
import 'package:base/screens/home/ui/home_screen.dart';
import 'package:base/screens/init/bloc/init_bloc.dart';
import 'package:base/screens/init/repository/init_repository_api.dart';
import 'package:base/screens/init/ui/init_screen.dart';
import 'package:base/screens/login/bloc/login_bloc.dart';
import 'package:base/screens/login/repository/login_repository_api.dart';
import 'package:base/screens/login/ui/login_screen.dart';
import 'package:base/screens/text_content/text_content_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Router {

  static String initPath = InitScreen.path;
  static String loginPath = LoginScreen.path;

  //by default all screens are protected - need token
  static List<String> notProtectedScreens = [
    LoginScreen.path,
    TextContentScreen.path
  ];

  static Map<String, WidgetBuilder> get routes {
    Map<String, WidgetBuilder> routes = {};

    //init screen
    routes[InitScreen.path] = (context) => BlocProvider<InitBloc>(
        create: (_) => InitBloc(InitRepositoryApi()),
        child: InitScreen()
    );

    //text screen
    routes[TextContentScreen.path] = (context) => TextContentScreen(ModalRoute.of(context).settings.arguments);

    //home screen
    routes[HomeScreen.path] = (context) => HomeScreen();

    //login screen
    routes[LoginScreen.path] = (context) => BlocProvider<LoginBloc>(
        create: (_) => LoginBloc(LoginRepositoryApi()),
        child: LoginScreen()
    );

    return routes;
  }

  static void push(BuildContext context, String path, {bool root = false, Map<String, dynamic> params}) {
    if(path == null) {
      return;
    }
    if (!_canAccess(path)) {
      push(context, loginPath, root: true, params: params);
      return;
    }

    if (root) {
      Navigator.of(context).pushNamedAndRemoveUntil(path, (_) => false, arguments: params); return;
    } else {
      Navigator.of(context).pushNamed(path, arguments: params);
    }
  }

  static void pushScreen(BuildContext context, Widget screen, {bool root = false, bool animate = true}) {

    if(screen == null) {
      return;
    }

    if (root) {
      if (animate) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => screen), (route) => false); return;
      } else {
        Navigator.of(context).pushAndRemoveUntil(PageRouteBuilder(pageBuilder: (_, __, ___) => screen), (route) => false); return;
      }
    }
    if (!root) {
      if (animate) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen)); return;
      } else {
        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___) => screen)); return;
      }
    }
  }

  static void pushRoute(BuildContext context, PageRoute route, {bool root = false}) {
    if(route == null) {
      return;
    }
    if (root) {
      Navigator.of(context).pushAndRemoveUntil(route, (_) => false); return;
    } else {
      Navigator.of(context).push(route); return;
    }
  }

  static void pop(BuildContext context, {int popCount}) {

    if (Navigator.of(context).canPop()) {
      if (popCount != null) {
        int actualPop = 0;
        Navigator.of(context).popUntil((route) => actualPop++ >= popCount);
      } else {
        Navigator.of(context).pop();
      }
      return;
    }
  }

    static bool _canAccess(String path) {
      if (notProtectedScreens.contains(path)) {
        return true;
      }
      if (AppCache.instance.token != null && AppCache.instance.tokenExpire != null && AppCache.instance.tokenExpire.isAfter(DateTime.now())) {
        return true;
      }
      return false;
    }
}
