import 'package:flutter/material.dart';
import 'package:puzzlehack/models/models.dart';

class PuzzleTile extends StatefulWidget {
  const PuzzleTile({
    Key? key,
    required this.tile,
    required this.puzzle,
  }) : super(key: key);

  final Puzzle puzzle;
  final Tile tile;

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
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: SizedBox.square(
            dimension: constraints.maxWidth / size,
            child: Padding(
              padding: EdgeInsets.all(constraints.maxWidth * .05),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(1000)),
                ),
                child: Center(
                  child: Text(
                    widget.tile.value.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
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
