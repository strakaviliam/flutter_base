import 'package:base/application/constant.dart';
import 'package:base/tools/widget/screen_state.dart';
import 'package:base/tools/widget/txt.dart';
import 'package:flutter/material.dart';

class TextContentScreen extends StatefulWidget {

  static String path = "/text";

  Map<String, dynamic> routeParams;

  TextContentScreen(this.routeParams);

  @override
  State<StatefulWidget> createState() => _TextContentScreenState();
}

class _TextContentScreenState extends ScreenState<TextContentScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> pageContent = [];

    pageContent.add(_text());

    return buildPage(pageStack: pageContent, avoidResizeWithKeyboard: true, appBar: _appBar());
  }

  Widget _text() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 8, right: 8),
              child: SingleChildScrollView(
                child: Txt(widget.routeParams[Constant.PARAM_CONTENT] ?? "", multiline: true)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Txt(widget.routeParams[Constant.PARAM_TITLE] ?? "", normalStyle: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white)),
    );
  }
}
