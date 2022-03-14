import 'package:flutter/material.dart';
import 'package:puzzlehack/models/models.dart';

class PuzzleTile extends StatefulWidget {
  const PuzzleTile({
    Key? key,
    required this.tile,
    required this.puzzle,
    this.isCountdownRunning = true,
  }) : super(key: key);

  final Puzzle puzzle;
  final Tile tile;
  final bool isCountdownRunning;

  @override
  State<PuzzleTile> createState() => _PuzzleTileState();
}

class _PuzzleTileState extends State<PuzzleTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.tile.isWhitespace) {
      return const SizedBox();
    }

    final size = widget.puzzle.getDimension();

    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedAlign(
          alignment: FractionalOffset(
            (widget.tile.currentPosition.x - 1) / (size - 1),
            (widget.tile.currentPosition.y - 1) / (size - 1),
          ),
          duration:
              Duration(milliseconds: widget.isCountdownRunning ? 900 : 400),
          curve: widget.isCountdownRunning
              ? Curves.easeInOutCubicEmphasized
              : Curves.easeOutCirc,
          child: SizedBox.square(
            dimension: constraints.maxWidth / size,
            child: Padding(
              padding: EdgeInsets.all(constraints.maxWidth * .015),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.all(Radius.circular(1000)),
                ),
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: .5,
                    heightFactor: .5,
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        widget.tile.value.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
