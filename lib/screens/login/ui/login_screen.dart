
import 'package:base/application/constant.dart';
import 'package:base/application/router.dart';
import 'package:base/application/strings.dart';
import 'package:base/common/widget/popup.dart';
import 'package:base/common/widget/progress_indicator.dart';
import 'package:base/screens/home/ui/home_screen.dart';
import 'package:base/screens/login/bloc/login_bloc.dart';
import 'package:base/screens/text_content/text_content_screen.dart';
import 'package:base/tools/widget/any_image.dart';
import 'package:base/tools/widget/btn.dart';
import 'package:base/tools/widget/font_awesome.dart';
import 'package:base/tools/widget/screen_state.dart';
import 'package:base/tools/widget/text_entry/text_entry.dart';
import 'package:base/tools/widget/text_entry/validator_email.dart';
import 'package:base/tools/widget/text_entry/validator_empty.dart';
import 'package:base/tools/widget/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {

  static String path = "/login";

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ScreenState<LoginScreen> {

  LoginBloc _loginBloc;
  String _email = "";

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _loginBloc.add(PrepareVerifyEmail());

    _loginBloc.listen((state) {
      if (state is LoginError) {
        Progress.hideProgress(context);

        if (state.message.isEmpty) {
          Popup.showAlertError(context, state.error);
        } else {
          state.message.forEach((key, value) {
            textEntryModel(key).error = value.tr();
          });
          setState(() {});
        }
      } else if (state is LoginDone) {
        Progress.hideProgress(context);
        Router.push(context, HomeScreen.path, root: true);
      } else if (state is VerifyEmailDone) {
        textEntryModel("password").text = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> pageContent = [];

    pageContent.add(_logo());

    pageContent.add(BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (prevState, newState) => !(newState is LoginError),
      builder: (context, state) {

        List<Widget> columns = [];

        if (state is VerifyEmailReady || state is VerifyEmailInProgress) {
          columns.add(_title(S.SCREEN_LOGIN_WELCOME.tr(args: [""])));
          columns.add(_subtitle(S.SCREEN_LOGIN_ENTER_EMAIL.tr()));
          columns.add(_emailField(showProgress: state is VerifyEmailInProgress));
        } else if (state is VerifyEmailDone) {
          columns.add(_title(S.SCREEN_LOGIN_WELCOME.tr(args: [state.email.split("@").first])));
          columns.add(_subtitle((state.existingEmail ? S.SCREEN_LOGIN_PLEASE_LOGIN : S.SCREEN_LOGIN_SET_PASSWORD).tr()));
          columns.add(_emailField());
          columns.add(_passwordField());
          columns.add(_helperPasswordBtn(state.existingEmail));
          columns.add(_actionButton(state.existingEmail));
          columns.add(Spacer());

          if (!state.existingEmail) {
            columns.add(_terms());
          }
        }

        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columns,
          ),
        );
      }
    ));

    return buildPage(pageStack: formStack(pageContent), avoidResizeWithKeyboard: true);
  }

  Widget _logo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 32),
          width: 100,
          height: 100,
          child: AnyImage("images/logo.png"),
        ),
      ],
    );
  }

  Widget _title(String text) {
    return Container(
      margin: EdgeInsets.only(top: 32),
      child: Text(text, style: Theme.of(context).textTheme.headline3),
    );
  }

  Widget _subtitle(String text) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Text(text, style: Theme.of(context).textTheme.headline5),
    );
  }

  Widget _emailField({bool showProgress = false}) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: TextEntry(textEntryModel("email"),
        keyboardType: TextInputType.emailAddress,
        hint: S.COMMON_EMAIL,
        iconColor: Theme.of(context).primaryColor,
        icon: FontAwesomeIcons.envelope,
        progress: showProgress,
        onChanged: (value) => _email = value,
        validators: [
          ValidatorEmail()
        ],
        beginEdit: (te) {
          handleTextEntryBegin(te);
          _loginBloc.add(PrepareVerifyEmail());
        },
        endEdit: (te) async {
          if (await handleTextEntryEnd(te)) {
            _loginBloc.add(VerifyEmail(_email));
          }
        }
      )
    );
  }

  Widget _passwordField() {
    return Container(
        margin: EdgeInsets.only(top: 16),
        child: TextEntry(textEntryModel("password"),
          hint: S.COMMON_PASSWORD,
          secure: true,
          iconColor: Theme.of(context).primaryColor,
          icon: FontAwesomeIcons.lock,
          validators: [
            ValidatorEmpty()
          ]
        )
    );
  }

  Widget _helperPasswordBtn(bool existingEmail) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Btn(text: (existingEmail ? S.SCREEN_LOGIN_FORGOT_PASSWORD : S.SCREEN_LOGIN_SKIP_PASSWORD).tr(),
            textStyle: Theme.of(context).textTheme.button.copyWith(color: Theme.of(context).primaryColor),
            onClick: () {
              if (existingEmail) {
                //todo: go to forgot password
              } else {
                _loginBloc.add(RegisterUser(textEntryModel("email").text, ""));
              }
            },
          )
        ],
      )
    );
  }

  Widget _actionButton(bool existingEmail) {
    return Container(
      height: 50,
        margin: EdgeInsets.fromLTRB(0, 32, 0, 0),
        child: Btn(text: (existingEmail ? S.SCREEN_LOGIN_LOGIN_ACTION : S.SCREEN_LOGIN_REGISTER_ACTION).tr(),
          backgroundColor: Theme.of(context).primaryColor,
          textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
          onClick: () async {
            bool valid = await TextEntryModel.validateFields([textEntryModel("email"), textEntryModel("password")]);
            if (valid) {
              Progress.showFullscreen(context);
              if (existingEmail) {
                _loginBloc.add(LoginUser(textEntryModel("email").text, textEntryModel("password").text));
              } else {
                _loginBloc.add(RegisterUser(textEntryModel("email").text, textEntryModel("password").text));
              }
            } else {
              setState(() {});
            }
          },
        )
    );
  }

  Widget _terms() {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 4, 0, 8),
        child: Txt(S.SCREEN_LOGIN_TERMS.tr())
          ..addClickable(S.SCREEN_LOGIN_TERMS_CLICKABLE.tr(), (_) => _goToTerms())
          ..addClickable(S.SCREEN_LOGIN_PRIVACY_CLICKABLE.tr(), (_) => _goToPrivacy())
    );
  }

  void _goToTerms() {
    Router.push(context, TextContentScreen.path, params: {
      Constant.PARAM_TITLE: S.TERMS_TITLE.tr(),
      Constant.PARAM_CONTENT: S.TERMS_CONTENT.tr()
    });
  }

  void _goToPrivacy() {
    Router.push(context, TextContentScreen.path, params: {
      Constant.PARAM_TITLE: S.PRIVACY_TITLE.tr(),
      Constant.PARAM_CONTENT: S.PRIVACY_CONTENT.tr()
    });
  }
}
