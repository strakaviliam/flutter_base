
import 'package:base/application/environment/environment.dart';
import 'package:base/tools/widget/text_entry/text_entry.dart';
import 'package:base/tools/widget/text_entry/validator.dart';
import 'package:flutter/material.dart';

abstract class ScreenState<T extends StatefulWidget> extends State<T> {

  @override
  void initState() {
    super.initState();
  }

  Widget buildPage({bool avoidResizeWithKeyboard = false, List<Widget> pageStack = const [], Widget appBar}) {

    final banner = Environment.banner();

    List<Widget> defaultPage = [
      Scaffold(
        body: Stack(
          children: pageStack,
        ),
        resizeToAvoidBottomInset: !avoidResizeWithKeyboard,
        backgroundColor: Colors.white,
        appBar: appBar,
      )
    ];

    if (banner != null) {
      defaultPage.add(banner);
    }

    return Container(
      constraints: BoxConstraints.expand(),
      child: Stack(
        children: defaultPage,
      ),
    );
  }

  List<Widget> formStack(List<Widget> pageContent) {
    return [
      SafeArea(
        child: GestureDetector(
          child: Container(
              color: Colors.transparent,
              constraints: BoxConstraints.expand(),
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: pageContent,
              )
          ),
          onTap: () => hideKeyboard(),
        ),
      )
    ];
  }


  //support for text entry

  Map<String, TextEntryModel> _textEntryModels = {};

  TextEntryModel textEntryModel(String name) {
    TextEntryModel model = _textEntryModels[name] ?? TextEntryModel();
    _textEntryModels[name] = model;
    return model;
  }

  void handleTextEntryBegin(TextEntry te) {
    te.model.error = null;
    setState(() {});
  }

  Future<bool> handleTextEntryEnd(TextEntry te) async {
    ValidatorResult result = await te.model.validate();
    if (!result.valid) {
      setState(() {});
    }
    return result.valid;
  }

  void hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}