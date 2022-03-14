import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzlehack/game/view/puzzle_tile.dart';
import 'package:puzzlehack/models/models.dart';
import 'package:puzzlehack/puzzle/puzzle.dart';

class GridPage extends StatefulWidget {
  const GridPage({Key? key}) : super(key: key);

  @override
  _GridPageState createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PuzzleBloc, PuzzleState>(builder: (context, state) {
      var deviceData = MediaQuery.of(context);
      var padding = deviceData.size.width * .015;

      var gridSpec = _getGridSpec(state.numberOfPlayers, deviceData.size.width);
      var widgets = <Widget>[];
      var playerIndex = 0;

      for (var i = 0; i < gridSpec.rows; i++) {
        var children = <Widget>[];

        for (var i = 0;
            i < gridSpec.cols && playerIndex < state.numberOfPlayers;
            i++) {
          var player = state.players[playerIndex];
          var playerTheme = state.themeForPlayer(playerIndex);
          children.add(_Puzzle(
            player: player,
            playerTheme: playerTheme,
            puzzle: state.puzzles[player.id]!,
          ));
          playerIndex++;
        }

        var row = Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
          flex: 1,
        );

        widgets.add(row);
      }

      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 29, 25, 39),
              Color.fromARGB(255, 9, 6, 17),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widgets,
            ),
          ),
        ),
      );
    });
  }
}

class _Puzzle extends StatelessWidget {
  const _Puzzle({
    Key? key,
    required this.player,
    required this.playerTheme,
    required this.puzzle,
  }) : super(key: key);

  final Player player;
  final PlayerTheme playerTheme;
  final Puzzle puzzle;

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    var padding = deviceData.size.width * .008;

    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

    final tiles =
        puzzle.tiles.map((t) => PuzzleTile(tile: t, puzzle: puzzle)).toList();

    return Expanded(
      flex: 1,
      child: Center(
        child: AspectRatio(
          aspectRatio: .9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FractionallySizedBox(
                widthFactor: .9,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Container(
                      decoration: BoxDecoration(
                        color: playerTheme.primaryColor.withAlpha(50),
                        borderRadius: BorderRadius.all(
                          Radius.circular(constraints.maxWidth * .1),
                        ),
                        border: Border.all(
                          color: playerTheme.primaryColor,
                          width: constraints.maxWidth * .01,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * .05),
                        child: Stack(children: tiles),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: padding * 2),
              FractionallySizedBox(
                widthFactor: .3,
                alignment: Alignment.topCenter,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                  child: Text(
                    playerTheme.name,
                    style: TextStyle(
                      color: playerTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

GridSpec _getGridSpec(int numPuzzles, double width) {
  if (width >= 650) {
    if (numPuzzles > 3) {
      return GridSpec(rows: 2, cols: (numPuzzles / 2).ceil());
    } else {
      return GridSpec(rows: 1, cols: numPuzzles);
    }
  } else if (width >= 400) {
    if (numPuzzles > 6) {
      return GridSpec(rows: (numPuzzles / 3).ceil(), cols: 3);
    } else if (numPuzzles > 2) {
      return GridSpec(rows: (numPuzzles / 2).ceil(), cols: 2);
    }
  } else {
    if (numPuzzles > 3) {
      return GridSpec(rows: (numPuzzles / 2).ceil(), cols: 2);
    }
  }
  return GridSpec(rows: numPuzzles, cols: 1);
}

class GridSpec {
  final int rows;
  final int cols;

  GridSpec({required this.rows, required this.cols});
}
