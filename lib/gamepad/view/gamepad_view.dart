import 'dart:math';

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

        return Scaffold(
          body: Column(children: [
            Expanded(
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: (details) => _onPanEnd(gamepadBloc, details),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOut,
                  color: state.status == GamepadStatus.ready
                      ? Colors.white
                      : state.theme.primaryColor,
                  child: Stack(
                    children: [
                      if (state.status == GamepadStatus.waiting)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.black38,
                                    onPrimary: Colors.white,
                                  ),
                                  onPressed: () => gamepadBloc.add(
                                    const InputRegistered(GamepadInput.ready),
                                  ),
                                  child: const Text("Tap here when ready!"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: Column(
                            children: [
                              Text(
                                state.theme.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.black54,
                                ),
                              ),
                              if (state.status == GamepadStatus.waiting) ...[
                                const SizedBox(height: 16),
                                const Text(
                                  "Swipe 👆 / 👇 for 🌈",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                              if (state.status == GamepadStatus.ready) ...[
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        color: Colors.black38,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Waiting on opponents...",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
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
