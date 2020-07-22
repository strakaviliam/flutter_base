part of 'app_bloc.dart';

@immutable
abstract class AppEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class ChangeLocale extends AppEvent {
  final BuildContext context;
  final String language;

  ChangeLocale(this.context, this.language);

  @override
  String toString() => 'ChangeLocale { email: $language }';

  @override
  List<Object> get props => [language];
}
