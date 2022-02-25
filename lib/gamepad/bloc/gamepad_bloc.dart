import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'gamepad_event.dart';
part 'gamepad_state.dart';

class GamepadBloc extends Bloc<GamepadEvent, GamepadState> {
  GamepadBloc() : super(GamepadInitial()) {
    on<GamepadEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
