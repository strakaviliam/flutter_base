import 'package:flutter/material.dart';

import 'any_image.dart';

class Btn extends StatelessWidget {

  Color backgroundColor;
  String text;
  bool shadow;
  bool enabled;
  EdgeInsets padding;
  String image;
  List<PopupOption> popupMenu;
  bool vertical;
  bool imageTextSwitch;
  double space;
  BorderRadius radius;
  Size imageSize;
  Color imageColor;
  TextStyle textStyle;

  Function() onClick;
  Function(BuildContext) onClickWithSelf;
  Function() onCancelPopup;
  Function(PopupOption) onSelectPopup;

  Btn({
    this.backgroundColor,
    this.onClick,
    this.onClickWithSelf,
    this.text,
    this.textStyle,
    this.shadow = false,
    this.enabled = true,
    this.padding = const EdgeInsets.all(4),
    this.image,
    this.popupMenu,
    this.onSelectPopup,
    this.onCancelPopup,
    this.vertical = false,
    this.space = 4.0,
    this.imageTextSwitch = false,
    this.radius,
    this.imageSize,
    this.imageColor
  });

  @override
  Widget build(BuildContext context) {

    if (textStyle == null) {
      textStyle = Theme.of(context).textTheme.button;
    }

    Widget btnChild = Container();
    Widget imageChild = Container();
    Widget textChild = Text(
      text ?? "",
      textAlign: TextAlign.center,
      style: textStyle
    );

    if (image != null) {
      imageChild = LayoutBuilder(builder: (context, constraints) {
        Size useSize = imageSize;
        if (useSize == null) {
          if (constraints.minWidth == 0 && constraints.maxWidth == double.infinity &&
              constraints.minHeight == 0 && constraints.maxHeight == double.infinity) {
            useSize = Size(16, 16);
          } else {
            useSize = constraints.maxWidth == double.infinity ? Size(constraints.maxHeight, constraints.maxHeight) : null;
          }
        }
        return Container(
            width: useSize?.width,
            height: useSize?.height,
            child: AnyImage(image, color: imageColor ?? textStyle.color)
        );
      });
      if (vertical) {
        imageChild = Expanded(
            child: imageChild
        );
      }
    }

    if (image != null && text != null) {
      List<Widget> child = [
        imageChild, Container(width: space, height: space), textChild
      ];

      if (imageTextSwitch) {
        child = [
          textChild, Container(width: space, height: space), imageChild
        ];
      }

      btnChild = vertical ? Column(children: child) : Row(children: child, mainAxisAlignment: MainAxisAlignment.center);

    } else if (image != null) {
      btnChild = imageChild;
    } else {
      btnChild = textChild;
    }

    Function action;

    if (popupMenu != null && popupMenu.isNotEmpty) {
      action = () {

        FocusScope.of(context).requestFocus(FocusNode());
        final RenderBox button = context.findRenderObject();
        final RenderBox overlay = Overlay.of(context).context.findRenderObject();
        final RelativeRect position = RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(Offset(0, 0), ancestor: overlay),
            button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
          ),
          Offset.zero & overlay.size,
        );

        List<PopupMenuEntry<PopupOption>> toShow = [];

        popupMenu.forEach((it) {
          toShow.add(it.make());
        });

        if (onClick != null) {
          onClick();
        }
        if (onClickWithSelf != null) {
          onClickWithSelf(context);
        }

        showMenu(
            context: context,
            position: position,
            items: toShow
        ).then<void>((PopupOption newValue) {
          if (newValue == null) {
            //cancel
            if (onCancelPopup != null) onCancelPopup();
          } else {
            if (onSelectPopup != null) onSelectPopup(newValue);
            if (newValue.action != null) newValue.action();
          }
        });
      };
    }

    ShapeBorder shape = RoundedRectangleBorder(
        borderRadius: radius ?? BorderRadius.circular(0)
    );
    return Container(
      child: LayoutBuilder(builder: (context, constraints) {
        return ButtonTheme(
          minWidth: constraints.maxHeight == double.infinity ? constraints.minHeight : constraints.maxHeight,
          child: RaisedButton(
            elevation: shadow ? 2 : 0,
            color: backgroundColor ?? Colors.transparent,
            padding: padding,
            onPressed: enabled ? (action ?? (() {
              if (onClick != null) {
                onClick();
              }
              if (onClickWithSelf != null) {
                onClickWithSelf(context);
              }
            })) : null,
            child: Container(
                color: Colors.transparent,
                child: Center(
                    child: btnChild
                )
            ),
            shape: shape,
            hoverElevation: 0,
            focusElevation: 0,
            highlightElevation: 0,
          ),
        );
      },),
    );
  }

}

class PopupOption {
  String title;
  String subtitle;
  dynamic value;
  Function action;
  AnyImage image;
  List<Btn> buttons;
  bool divider;
  TextStyle textStyle;
  TextStyle subtitleTextStyle;


  PopupOption({this.title = "", this.subtitle, this.value, this.action, this.image, this.buttons = const [], this.divider = false, this.textStyle, this.subtitleTextStyle});

  PopupMenuEntry make() {
    if (divider) {
      return PopupMenuDivider(height: 1,);
    } else if (title.isNotEmpty) {
      return PopupMenuItem<PopupOption>(
        child: Builder(builder: (context) {
          return Container(
            child: Row(
              children: <Widget>[
                image != null ? Container(
                  padding: EdgeInsets.all(4),
                  width: 40,
                  height: 40,
                  child: image,
                ) : Container(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(title, style: textStyle != null ? textStyle : Theme.of(context).textTheme.headline5),
                    subtitle == null ? Container() : Text(subtitle, style: subtitleTextStyle != null ? subtitleTextStyle : Theme.of(context).textTheme.subtitle1)
                  ],
                )
              ],
            )
          );
        }),
        value: this,
        enabled: action != null,
      );
    } else if (buttons.isNotEmpty) {
      return PopupMenuItem<PopupOption>(
        child: Container(
          child: Row(
              children: buttons.map((btn) {
                return Container(
                  padding: EdgeInsets.all(4),
                  width: 40,
                  height: 40,
                  child: btn,
                );
              }).toList()
          ),
        ),
        enabled: false,
        value: this,
      );
    }
  }
}