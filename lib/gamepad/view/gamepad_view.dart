import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js/js.dart';
import 'package:puzzlehack/gamepad/gamepad.dart';
import 'package:puzzlehack/interop.dart';
import 'package:puzzlehack/models/models.dart';

class GamepadView extends StatefulWidget {
  const GamepadView({Key? key, required this.channelId}) : super(key: key);

  final String channelId;

  @override
  State<GamepadView> createState() => _GamepadViewState();
}

class _GamepadViewState extends State<GamepadView>
    with TickerProviderStateMixin {
  GamepadInput? input;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  )..value = 1;

  late final Animation<double> _opacity =
      Tween(begin: 1.0, end: 0.0).animate(_controller);

  late final Animation<double> _scale =
      Tween(begin: 1.0, end: 0.6).animate(_controller);

  double _dx = 0.0;
  double _dy = 0.0;

  @override
  void initState() {
    var bloc = BlocProvider.of<GamepadBloc>(context);
    Interop.onGameStateChange = allowInterop((state) {
      bloc.add(GameStateChanged(state));
    });
    Interop.onPlayerChange = allowInterop((player) {
      bloc.add(PlayerChanged(player));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gamepadBloc = context.read<GamepadBloc>();
    return BlocBuilder<GamepadBloc, GamepadState>(
      builder: (context, state) {
        if (state.status == GamepadStatus.initial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.status == GamepadStatus.waiting) {
          return const Scaffold(
            body: Center(
              child: Text("Waiting for host to start the game."),
            ),
          );
        }

        return Scaffold(
          body: Column(children: [
            Expanded(
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: (details) => _onPanEnd(gamepadBloc, details),
                child: Container(
                  color: state.theme.primaryColor,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: Text(
                            state.theme.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              FractionallySizedBox(
                                widthFactor: .18,
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Transform.rotate(
                                      angle: pi / 4,
                                      child: Container(
                                        color: Colors.white30,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.cover,
                                child: ScaleTransition(
                                  scale: _scale,
                                  child: FadeTransition(
                                    opacity: _opacity,
                                    child: RotatedBox(
                                      quarterTurns:
                                          input != null ? input!.index + 1 : 0,
                                      child: const Icon(
                                        Icons.chevron_left_sharp,
                                        size: 400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  _onPanStart(details) {
    _controller.animateTo(
      .4,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
    );
  }

  _onPanUpdate(details) {
    _dx += details.delta.dx;
    _dy += details.delta.dy;

    var dir = _dx.abs() > _dy.abs()
        ? (_dx > 0 ? GamepadInput.right : GamepadInput.left)
        : (_dy > 0 ? GamepadInput.down : GamepadInput.up);

    if (dir == input) return;

    setState(() {
      input = dir;
    });
  }

  _onPanEnd(GamepadBloc bloc, details) {
    _dx = _dy = 0;
    if (input != null) {
      bloc.add(InputRegistered(input!));
      _controller.forward(from: 0);
    }
  }
}
