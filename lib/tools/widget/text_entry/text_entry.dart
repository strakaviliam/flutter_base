
import 'package:base/common/widget/progress_indicator.dart';
import 'package:base/tools/widget/text_entry/validator.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../any_image.dart';

class TextEntry extends TextField {

  Function(TextEntry) _beginEdit;
  Function(TextEntry) _endEdit;
  List<Validator> validators;

  TextEntryModel model;

  TextEntry(this.model, {
    String icon,
    bool progress = false,
    String name,
    String hint = "",
    String text,
    bool secure = false,
    int maxLines = 1,
    ValueChanged<String> onChanged,
    Function(TextEntry) beginEdit,
    Function(TextEntry) endEdit,
    this.validators = const [],
    TextInputType keyboardType,
    bool enabled = true,
    bool editable = true,
    bool autofocus = false,
    bool enableSelection = true,
    Color fillColor,
    Color iconColor
  }):
        super(
          obscureText: secure,
          focusNode: model.focusNode,
          keyboardType: keyboardType,
          maxLines: maxLines,
          enabled: enabled && editable,
          controller: TextEditingController(text: (model.text ?? text))
            ..selection = (
                text != null ?
                TextSelection.collapsed(offset: (model.text ?? text).length) :
                (model._field?.controller?.selection ?? TextSelection.collapsed(offset: ((model.text ?? text) ?? "").length))
            ),
          onChanged: (text) {
            model.text = text;
            if (onChanged != null) {
              onChanged(text);
            }
          },
          autofocus: autofocus,
          decoration: InputDecoration(
            suffixIcon: initIcon(icon, progress, enabled, iconColor),
            filled: fillColor != null,
            fillColor: fillColor,
            hintText: hint.tr(),
            labelText: name?.tr(),
            errorText: model.error?.tr()
          ),
          enableInteractiveSelection: enableSelection //todo: this is because of bug https://github.com/flutter/flutter/issues/14489
      ) {
    _beginEdit = beginEdit;
    _endEdit = endEdit;

    model._field = this;
    if (text != null && model.text == null) {
      model.text = text;
    }

    _initFocus();
  }

  void _initFocus() {

    if(!focusNode.hasListeners) {
      focusNode.addListener(() {

        if (!focusNode.hasFocus) {
          if (_endEdit != null) {
            _endEdit(this);
          }
        } else {
          if (_beginEdit != null) {
            _beginEdit(this);
          }
        }
      });
    }
  }

  static Widget initIcon(String icon, bool progress, bool enabled, Color color) {
    if (icon == null) {
      return null;
    }
    Widget suffixIcon = Container(
      width: 24,
      height: 24,
      padding: EdgeInsets.all(9),
      child: AnyImage(icon, color: color ?? Colors.black),
    );

    if(progress) {
      suffixIcon = Container(
        padding: EdgeInsets.all(16),
        width: 8,
        height: 18,
        child: Progress(color: color ?? Colors.black),
      );
    }

    return suffixIcon;
  }
}

class TextEntryModel {
  TextEntry _field;
  FocusNode focusNode = FocusNode();
  String error;
  String text;
  List<TextEntrySuggestion> suggestions = [];
  TextEntrySuggestion selectedSuggestion;

  TextEntryModel();

  Future<ValidatorResult> validate() async {
    error = null;
    if (_field.validators == null || _field.validators.isEmpty) {
      return ValidatorResult(true, null);
    }

    bool isValid = true;
    String hasError;

    for (Validator validator in _field.validators) {
      ValidatorResult result = await validator.validate({ValidableParam.text: text});
      if (!result.valid) {
        isValid = isValid && result.valid;
        hasError = hasError ?? result.error;
      }
    }
    this.error = hasError;
    return ValidatorResult(isValid, hasError);
  }

  static Future<bool> validateFields(List<TextEntryModel> fields) async {
    bool isValid = true;

    for (TextEntryModel model in fields) {
      ValidatorResult result = await model.validate();
      isValid = isValid && result.valid;
    }

    return isValid;
  }
}

class TextEntrySuggestion<T> {
  T model;
  Widget Function(T) display;
  String Function(T) title;

  TextEntrySuggestion(this.model, {@required this.display, @required this.title});

  Widget view() {
    return display(model);
  }

  String text() {
    return title(model);
  }
}
