part of 'gamepad_bloc.dart';

abstract class GamepadState extends Equatable {
  const GamepadState();
  
  @override
  List<Object> get props => [];
}

class GamepadInitial extends GamepadState {}
