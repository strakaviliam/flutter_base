
import 'package:base/tools/widget/text_entry/validator.dart';

class ValidatorRegex extends Validator {

  String regEx = "";

  ValidatorRegex(this.regEx, String error): super(error);

  @override
  Future<ValidatorResult> validate(Map<ValidableParam,dynamic> params) async {
    String text = params[ValidableParam.text];
    if (text == null) {
      return ValidatorResult(true, null);
    }

    if(text.isEmpty) {
      return ValidatorResult(true, null);
    }

    RegExp regExp = RegExp(regEx);

    if (!regExp.hasMatch(text)) {
      return ValidatorResult(false, error);
    } else {
      return ValidatorResult(true, null);
    }

  }
}
