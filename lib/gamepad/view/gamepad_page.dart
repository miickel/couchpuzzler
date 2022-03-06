import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzlehack/gamepad/gamepad.dart';

class GamepadPage extends StatelessWidget {
  const GamepadPage({Key? key, required this.channelId}) : super(key: key);

  final String channelId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GamepadBloc()..add(GamepadInitialized(channelId)),
      child: GamepadView(channelId: channelId),
    );
  }
}
