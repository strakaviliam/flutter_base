import 'dart:ui';

import 'package:base/application/router.dart';
import 'package:flutter/material.dart';

class Progress extends CircularProgressIndicator {

  Progress({double strokeWidth = 2, Color color}): super(
      strokeWidth: strokeWidth,
      valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.black)
  );

  static Widget view(BuildContext context, {Size size: const Size(60, 60)}){
    return Container(
      width: size.width,
      height: size.height,
      child: Progress(strokeWidth: 3, color: Theme.of(context).primaryColor),
    );
  }

  static bool isPresent = false;

  static void showFullscreen(BuildContext context) {
    if (isPresent) {
      return;
    }
    isPresent = true;
    Router.pushRoute(context, PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            FullscreenPopup(
                Center(
                    child: Progress.view(context)
                )
            )
    )
    );
  }

  static void hideProgress(BuildContext context) {
    if (!isPresent) {
      return;
    }
    isPresent = false;
    Router.pop(context);
  }
}

class FullscreenPopup extends StatelessWidget {

  final Widget content;

  FullscreenPopup(this.content);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Container(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.white.withOpacity(0.0),
                ),
              ),
            ),
            content
          ],
        )
    );
  }

}