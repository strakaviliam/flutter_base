
import 'package:equatable/equatable.dart';

enum Status{
  success, fail
}

class Result<T> extends Equatable {

  Status status;
  T data;
  String error = "";
  Map<String, String> message = Map();

  String key;

  Result();

  Result.fail(this.error, this.key) {
    status = Status.fail;
  }

  Result.success(this.data, this.key) {
    status = Status.success;
  }

  @override
  List<Object> get props => [status, error, key, data];
}

class ErrorResult implements Exception {
  final Result result;
  ErrorResult(this.result);
}
