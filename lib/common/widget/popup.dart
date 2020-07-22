
import 'package:base/application/router.dart';
import 'package:base/application/strings.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Popup {

  static void showAlertError(BuildContext context, String message, {Function cancelAction}) {
    showAlert(context, S.ERROR_GENERAL, message, cancelAction: cancelAction);
  }

  static void showAlert(BuildContext context, String title, String message, {String confirm, Function confirmAction, Function cancelAction}) {

    showDialog(context: context,
        builder: (BuildContext context) {

          List<Widget> actions = [];

          if (confirm != null && confirmAction != null) {
            //add cancel
            actions.add(
              FlatButton(
                child: Text(S.COMMON_CANCEL.tr()),
                onPressed: () {
                  Router.pop(context);
                  if (cancelAction != null) {
                    cancelAction();
                  }
                },
              )
            );
            //add confirm
            actions.add(
              FlatButton(
                child: Text(confirm.tr()),
                onPressed: () {
                  confirmAction();
                  Router.pop(context);
                },
              )
            );
          } else {
            //add OK
            actions.add(
              FlatButton(
                child: new Text(S.COMMON_OK.tr()),
                onPressed: () {
                  Router.pop(context);
                  if (cancelAction != null) {
                    cancelAction();
                  }
                },
              )
            );
          }

          return AlertDialog(
            title: Text(title.tr()),
            content: Text(message.tr()),
            actions: actions,
          );
        }
    );
  }


  static void showPopup(BuildContext context, Widget content, {Function(BuildContext) popupContext, bool enableTouchPop = true, Function() onTouchPop, bool top = false}) {
    showDialog(context: context, builder: (BuildContext context) {
      if(popupContext != null) {
        popupContext(context);
      }
      return Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints.expand(),
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              enableTouchPop ? GestureDetector(
                onTap: () => onTouchPop == null ? Navigator.pop(context) : onTouchPop(),
                child: Container(
                  color: Colors.transparent,
                ),
              ) : Container(),
              top ? GestureDetector(
                onTap: () => onTouchPop == null ? Navigator.pop(context) : onTouchPop(),
                child: Container(
                  alignment: Alignment(0, -1),
                  margin: EdgeInsets.only(top: 32),
                  color: Colors.transparent,
                  child: GestureDetector(child: content, onTap: () {}),
                ),
              ) : Center(
                child: Container(
                  color: Colors.transparent,
                  child: content,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
