import 'dart:developer';

import 'package:flutter/material.dart';

enum Direction { none, up, right, down, left }

class GamepadView extends StatefulWidget {
  const GamepadView({Key? key, required this.channelId}) : super(key: key);

  final String channelId;

  @override
  State<GamepadView> createState() => _GamepadViewState();
}

class _GamepadViewState extends State<GamepadView>
    with TickerProviderStateMixin {
  Direction direction = Direction.none;

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: (details) => _onPanEnd(context, details),
            child: Container(
              color: Colors.purple.shade900,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: ScaleTransition(
                          scale: _scale,
                          child: FadeTransition(
                            opacity: _opacity,
                            child: RotatedBox(
                              quarterTurns: direction.index,
                              child: const Icon(
                                Icons.chevron_left_rounded,
                                size: 400,
                                color: Colors.tealAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
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
        ? (_dx > 0 ? Direction.right : Direction.left)
        : (_dy > 0 ? Direction.down : Direction.up);

    if (dir == direction) return;

    setState(() {
      direction = dir;
    });
  }

  _onPanEnd(context, details) {
    _dx = _dy = 0;
    if (direction != Direction.none) {
      log("send $direction");

      _controller.forward(from: 0);
    }
  }
}
