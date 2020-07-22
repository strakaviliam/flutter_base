import 'dart:convert';
import 'dart:io';
import 'package:base/application/app_cache.dart';
import 'package:base/application/environment/environment.dart';
import 'package:base/tools/api/api.dart';
import 'package:mockito/mockito.dart';

class MockApi extends Mock implements Api {}
class MockAppCache extends Mock implements AppCache {}

Future<Map<String, dynamic>> mockedJson(String name) async {
  String data = await mockedJsonString(name);
  return json.decode(data);
}

Future<String> mockedJsonString(String name) async {
  String jsonString;
  try {
    jsonString = await File('../test_resources/$name.json').readAsString();
  } catch (e) {
    jsonString = await File('test_resources/$name.json').readAsString();
  }
  return jsonString;
}


void commonSetup() {
  Environment.value = MockEnvironment();
  MockAppCache appCache = MockAppCache();
  AppCache.value = appCache;
}

class MockEnvironment extends Environment {
  MockEnvironment() : super.mock();
}
