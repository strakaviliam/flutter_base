
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Txt extends StatelessWidget {

  String text;
  TextStyle normalStyle;
  TextStyle clickableStyle;
  Map<String, Function(String)> clickable = {};
  TextAlign align;
  bool multiline = false;
  EdgeInsets padding;
  int maxLines;

  Txt(this.text, {this.normalStyle, this.clickableStyle, this.align = TextAlign.start, this.multiline = false, this.padding = EdgeInsets.zero, this.maxLines});

  void addClickable(String text, Function(String) action) {
    clickable[text] = action;
  }

  @override
  Widget build(BuildContext context) {

    normalStyle = normalStyle ?? Theme.of(context).textTheme.bodyText1;
    clickableStyle = clickableStyle ?? Theme.of(context).textTheme.bodyText1.copyWith(color: Theme.of(context).accentColor);

    if (multiline ?? false) {
      return _buildMultiline(context);
    }

    List<TextSpan> textComponents = [];
    Map<int, String> mapOrder = {};

    for (String key in clickable.keys) {
      int index = text.indexOf(key);
      if (index != -1) {
        mapOrder[index] = key;
      }
    }

    if (mapOrder.isEmpty) {
      textComponents.add(TextSpan(
          text: text,
          style: normalStyle
      ));
    } else {

      String workingText = text;

      for (int index in mapOrder.keys.toList()) {

        String actualText = text.substring(text.indexOf(workingText), index);
        String clickableText = mapOrder[index];

        textComponents.add(TextSpan(
            text: actualText,
            style: normalStyle
        ));

        textComponents.add(TextSpan(
            text: clickableText,
            style: clickableStyle,
            recognizer: TapGestureRecognizer()..onTap = () {
              clickable[clickableText](clickableText);
            }
        ));

        workingText = text.substring(index + clickableText.length);
      }

      textComponents.add(TextSpan(
          text: workingText,
          style: normalStyle
      ));
    }

    return RichText(
      textAlign: align,
      maxLines: maxLines,
      text: TextSpan(
        children: textComponents,
      ),
    );
  }


  Widget _buildMultiline(BuildContext context) {

    ThemeData actualTheme = Theme.of(context);
    TextStyle textStyle = normalStyle;

    return Markdown(
        data: text,
        shrinkWrap: true,
        padding: padding,
        physics: ClampingScrollPhysics(),
        styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
        styleSheet: MarkdownStyleSheet.fromTheme(actualTheme.copyWith(
            textTheme: actualTheme.textTheme.apply(
              fontFamily: textStyle.fontFamily,
              fontSizeDelta: textStyle.fontSize - actualTheme.textTheme.bodyText1.fontSize,
              bodyColor: textStyle.color,
            )
        )).copyWith(
            blockquoteDecoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  left: BorderSide(color: Colors.grey.withAlpha(100), width: 6),
                )
            ),
            blockquotePadding: EdgeInsets.all(16.0)
          //todo format specific
        )
    );
  }
}
