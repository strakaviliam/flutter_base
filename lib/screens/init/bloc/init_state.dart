part of 'init_bloc.dart';

@immutable
abstract class InitState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitLoading extends InitState {

  @override
  String toString() => 'InitLoading { }';
}

class InitError extends InitState {
  final String error;

  InitError(this.error);

  @override
  String toString() => 'InitError { error: $error }';

  @override
  List<Object> get props => [error];
}

class InitLoaded extends InitState {

  final AppConfig appConfig;

  InitLoaded(this.appConfig);

  @override
  String toString() => 'InitLoaded { appConfig: $appConfig }';

  @override
  List<Object> get props => [appConfig];
}
