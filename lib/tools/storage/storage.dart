import 'storage_general.dart'
if (dart.library.io)  'storage_mobile.dart'
if (dart.library.html) 'storage_web.dart';

abstract class Storage {

  Future<void> write({String key, String value}) async {}

  Future<String> read({String key}) async {}

  Future<void> delete({String key}) async {}

  Future<Map<String, String>> readAll() async {}

  void get(String key, Function(String) done) async {}

  factory Storage() => getStorage();

  Storage.protected();
}
