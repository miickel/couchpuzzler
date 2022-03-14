import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js/js.dart';
import 'package:puzzlehack/game/view/grid_page.dart';
import 'package:puzzlehack/interop.dart';
import 'package:puzzlehack/lobby/view/lobby_page.dart';
import 'package:puzzlehack/puzzle/puzzle.dart';

class GameView extends StatefulWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  @override
  void initState() {
    var bloc = BlocProvider.of<PuzzleBloc>(context);
    Interop.onGamepadInput = allowInterop((playerId, input) {
      bloc.add(GamepadInputRegistered(playerId, input));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PuzzleBloc, PuzzleState>(builder: (context, state) {
      switch (state.status) {
        case Status.lobby:
          return const LobbyPage();
        case Status.playing:
        case Status.complete:
          return const GridPage();
      }
    });
  }
}
