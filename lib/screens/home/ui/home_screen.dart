import 'package:base/application/app_cache.dart';
import 'package:base/application/router.dart';
import 'package:base/screens/login/ui/login_screen.dart';
import 'package:base/tools/api/api.dart';
import 'package:base/tools/widget/btn.dart';
import 'package:base/tools/widget/screen_state.dart';
import 'package:base/tools/widget/txt.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  static String path = "/home";

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ScreenState<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return buildPage(
      appBar: AppBar(
        title: Txt("Home", normalStyle: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white)),
      ),
      pageStack: [
        Container(
            child: Center(
                child: Container(
                  width: 100,
                  height: 50,
                  child: Btn(
                    text: "Logout",
                    onClick: () => _logout(),
                  ),
                )
            )
        )
      ]
    );
  }

  void _logout() async {
    await Api("/user/logout", method: HTTPMethod.post, publicAPI: false).call();
    AppCache.instance.clear();
    Router.push(context, LoginScreen.path, root: true);
  }
}
