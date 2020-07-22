
import 'package:base/common/model/user.dart';
import 'package:base/screens/login/model/token_model.dart';
import 'package:base/tools/storage/storage.dart';
import 'package:flutter/material.dart';

class AppCache {

  static const String _tokenKey = "kTokenKey";
  static const String _tokenExpireKey = "kTokenExpireKey";
  static const String _languageKey = "kLanguageKey";

  static AppCache _inst = AppCache._();
  AppCache._();
  factory AppCache() => _inst;
  static AppCache get instance => _inst;
  @visibleForTesting
  static set value(AppCache val) => _inst = val;

  User _user;
  String _token;
  DateTime _tokenExpire;
  String _language = "en";
  String _currency = "USD";

  final Map<String, String> appFont = {
    "en": "Montserrat",
    "sk": "Roboto"
  };

  String get token => _token;
  User get user => _user;
  DateTime get tokenExpire => _tokenExpire;
  String get language => _language;
  String get currency => _currency;

  void setupToken(TokenModel tokenModel) async {
    this._token = tokenModel.token;
    this._tokenExpire = tokenModel.tokenExpire;

    Storage storage = Storage();
    await storage.write(key: _tokenKey, value: token);
    await storage.write(key: _tokenExpireKey, value: tokenExpire.millisecondsSinceEpoch.toString());
  }

  Future<void> setLocale(String lang) async {
    this._language = lang;
    Storage storage = Storage();
    await storage.write(key: _languageKey, value: lang);
  }

  Future<void> init() async {
    Storage storage = Storage();
    AppCache.instance._language = await storage.read(key: _languageKey) ?? "en";
    AppCache.instance._token = await storage.read(key: _tokenKey);
    String expireMillisString = await storage.read(key: _tokenExpireKey) ?? "0";
    int expireMillis = int.parse(expireMillisString);
    if (expireMillis > 0) {
      AppCache.instance._tokenExpire = DateTime.fromMillisecondsSinceEpoch(expireMillis);
    }
  }

  void clear() async {
    _user = null;
    _token = null;
    _tokenExpire = null;
    _language = "en";
    _currency = "USD";

    Storage storage = Storage();
    await storage.delete(key: _tokenKey);
    await storage.delete(key: _tokenExpireKey);
    await storage.delete(key: _languageKey);
  }
}