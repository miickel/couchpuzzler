import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzlehack/game/game.dart';
import 'package:puzzlehack/models/models.dart';
import 'package:puzzlehack/puzzle/puzzle.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PuzzleBloc(playerThemes: [
        const PlayerTheme(
          name: "East Side",
          primaryColor: Color(0xffB68EBE),
        ),
        const PlayerTheme(
          name: "Bittersweet",
          primaryColor: Color(0xffFF8368),
        ),
        const PlayerTheme(
          name: "Laser Lemon",
          primaryColor: Color(0xffF9F871),
        ),
        const PlayerTheme(
          name: "Allports",
          primaryColor: Color(0xff1C6E7D),
        ),
        const PlayerTheme(
          name: "Celestial Blue",
          primaryColor: Color(0xff4A9BDC),
        ),
        const PlayerTheme(
          name: "Dark Turquoise",
          primaryColor: Color(0xff00D1D8),
        ),
        const PlayerTheme(
          name: "Pale Green",
          primaryColor: Color(0xffA0F38C),
        ),
        const PlayerTheme(
          name: "Cement",
          primaryColor: Color(0xff8A7356),
        ),
        const PlayerTheme(
          name: "Rhino",
          primaryColor: Color(0xff3C4856),
        ),
      ]),
      child: const GameView(),
    );
  }
}
