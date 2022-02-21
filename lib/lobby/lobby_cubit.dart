import 'package:bloc/bloc.dart';

class LobbyCubit extends Cubit<int> {
  LobbyCubit() : super(0);
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
