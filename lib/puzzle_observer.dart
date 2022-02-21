import 'package:bloc/bloc.dart';

/// {@template counter_observer}
/// [BlocObserver] for the puzzle application which
/// observes all state changes.
/// {@endtemplate}
class PuzzleObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}
