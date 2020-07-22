import 'package:crypted_preferences/crypted_preferences.dart';

import 'storage.dart';

class StorageWeb extends Storage {

  Preferences prefs;

  StorageWeb() : super.protected();

  Future<void> write({String key, String value}) async {
    if (prefs == null) {
      prefs = await Preferences.preferences(path: './storage/prefs');
    }
    await prefs.setString(key, value);
  }

  Future<String> read({String key}) async {
    if (prefs == null) {
      prefs = await Preferences.preferences(path: './storage/prefs');
    }
    return prefs.getString(key);
  }

  Future<void> delete({String key}) async {
    if (prefs == null) {
      prefs = await Preferences.preferences(path: './storage/prefs');
    }
    await prefs.remove(key);
  }

  Future<Map<String, String>> readAll() async {
    if (prefs == null) {
      prefs = await Preferences.preferences(path: './storage/prefs');
    }
    Map<String, String> result = {};
    List<String> keys = prefs.getKeys().toList();

    await keys.forEach((key) {
      result[key] = prefs.getString(key);
    });

    return result;
  }

  void get(String key, Function(String) done) async {
    if (prefs == null) {
      prefs = await Preferences.preferences(path: './storage/prefs');
    }
    var value = await prefs.getString(key);
    done(value);
  }
}

Storage getStorage() => StorageWeb();
