part of 'init_bloc.dart';

@immutable
abstract class InitEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class InitApplication extends InitEvent {
  @override
  String toString() => 'InitApplication { }';
}
