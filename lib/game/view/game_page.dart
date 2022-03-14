import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzlehack/constants.dart';
import 'package:puzzlehack/game/game.dart';
import 'package:puzzlehack/models/models.dart';
import 'package:puzzlehack/puzzle/puzzle.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PuzzleBloc(
        playerThemes: playerThemes,
        ticker: const Ticker(),
      ),
      child: const GameView(),
    );
  }
}
