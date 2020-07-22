import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage.dart';

class StorageMobile extends Storage {

  final kvs = FlutterSecureStorage();

  StorageMobile() : super.protected();

  Future<void> write({String key, String value}) async {
    await kvs.write(key: key, value: value);
  }

  Future<String> read({String key}) async {
    return kvs.read(key: key);
  }

  Future<void> delete({String key}) async {
    await kvs.delete(key: key);
  }

  Future<Map<String, String>> readAll() async {
    Map<String, String> result = await kvs.readAll();

    return result;
  }

  void get(String key, Function(String) done) async {
    var value = await kvs.read(key: key);
    done(value);
  }
}

Storage getStorage() => StorageMobile();
