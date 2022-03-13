import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          children.add(Puzzle(player: player, playerTheme: playerTheme));
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
          color: Colors.black,
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

class Puzzle extends StatelessWidget {
  const Puzzle({Key? key, required this.player, required this.playerTheme})
      : super(key: key);

  final Player player;
  final PlayerTheme playerTheme;

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    var padding = deviceData.size.width * .008;

    return Expanded(
      flex: 1,
      child: Center(
        child: AspectRatio(
          aspectRatio: .9,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: playerTheme.primaryColor,
                  ),
                ),
                SizedBox(height: padding),
                const Expanded(
                  child: LinearProgressIndicator(
                    color: Colors.white70,
                    backgroundColor: Colors.white24,
                    minHeight: 16,
                    value: .5,
                  ),
                )
              ],
            ),
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
