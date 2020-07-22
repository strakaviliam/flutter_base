import 'package:base/tools/widget/text_entry/validator.dart';

class ValidatorEmpty extends Validator {

  ValidatorEmpty({String error = "error.validate_empty"}): super(error);

  @override
  Future<ValidatorResult> validate(Map<ValidableParam, dynamic> params) async {
    String text = params[ValidableParam.text];
    if (text == null) {
      return ValidatorResult(false, error);
    }

    if (text.length == 0) {
      return ValidatorResult(false, error);
    } else {
      return ValidatorResult(true, null);
    }
  }
}
