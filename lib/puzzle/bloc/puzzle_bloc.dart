import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:puzzlehack/interop.dart';
import 'package:puzzlehack/models/models.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

const _size = 4;
const _countDown = 5;

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc({
    required this.playerThemes,
    required Ticker ticker,
  })  : _ticker = ticker,
        super(PuzzleState(
          playerThemes: playerThemes,
          secondsToBegin: _countDown,
        )) {
    on<PlayerAdded>(_onPlayerAdded);
    on<PlayerRemoved>(_onPlayerRemoved);
    on<GameStarted>(_onGameStarted);
    on<CountdownTicked>(_onCountdownTicked);
    on<GamepadInputRegistered>(_onGamepadInputRegistered);
  }

  final List<PlayerTheme> playerThemes;
  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;

  _onPlayerAdded(PlayerAdded event, Emitter<PuzzleState> emit) {
    if (state.numberOfPlayers < 8 &&
        !state.players.any((e) => e.id == event.player.id)) {
      var player = _changePlayerTheme(event.player, 1);
      var players = state.players.toList()..add(player);
      var jsPlayer = JsPlayer(id: player.id, theme: player.theme);
      Interop.updatePlayer(jsPlayer);
      emit(state.copyWith(players: players));
    }
  }

  _onPlayerRemoved(PlayerRemoved event, Emitter<PuzzleState> emit) {
    var players = state.players.toList()
      ..removeWhere((e) => e.id == event.player.id);
    emit(state.copyWith(players: players));
  }

  _onGameStarted(GameStarted event, Emitter<PuzzleState> emit) {
    Interop.setGameState("playing");
    _startTicker();
    emit(state.copyWith(
      status: Status.playing,
      puzzles: _shufflePuzzles(false),
      isCountdownRunning: true,
      secondsToBegin: _countDown,
    ));
  }

  _onCountdownTicked(CountdownTicked event, Emitter<PuzzleState> emit) {
    if (state.secondsToBegin == 0) {
      _tickerSubscription?.pause();
      emit(state.copyWith(
        isCountdownRunning: false,
      ));
    } else {
      emit(state.copyWith(
        secondsToBegin: state.secondsToBegin - 1,
        puzzles: state.secondsToBegin < 5 && state.secondsToBegin != 1
            ? _shufflePuzzles(true)
            : state.puzzles,
      ));
    }
  }

  _onGamepadInputRegistered(
      GamepadInputRegistered event, Emitter<PuzzleState> emit) {
    if (state.isCountdownRunning) {
      return false;
    }

    var player = state.players.firstWhere((p) => p.id == event.playerId);
    var playerIndex = state.players.indexOf(player);
    var input = GamepadInput.values[event.input];

    switch (state.status) {
      case Status.lobby:
        if (input == GamepadInput.up || input == GamepadInput.down) {
          var players = state.players.toList();
          var step = input == GamepadInput.up ? 1 : -1;
          player = _changePlayerTheme(player, step);
          players[playerIndex] = player;
          var jsPlayer = JsPlayer(id: player.id, theme: player.theme);
          Interop.updatePlayer(jsPlayer);
          emit(state.copyWith(players: players));
        } else if (input == GamepadInput.ready) {
          var playersReady = {...state.playersReady, player.id: true};
          emit(state.copyWith(playersReady: playersReady));

          if (playersReady.length == state.numberOfPlayers) {
            add(GameStarted());
          }
        }
        break;
      case Status.playing:
        Tile? tile;
        var puzzle = state.puzzles[event.playerId]!;

        if (input == GamepadInput.down) {
          tile = puzzle.getTileRelativeToWhitespaceTile(const Offset(0, -1));
        } else if (input == GamepadInput.up) {
          tile = puzzle.getTileRelativeToWhitespaceTile(const Offset(0, 1));
        } else if (input == GamepadInput.right) {
          tile = puzzle.getTileRelativeToWhitespaceTile(const Offset(-1, 0));
        } else {
          tile = puzzle.getTileRelativeToWhitespaceTile(const Offset(1, 0));
        }

        if (tile != null) {
          if (puzzle.isTileMovable(tile)) {
            final mutablePuzzle = Puzzle(tiles: [...puzzle.tiles]);
            final newPuzzle = mutablePuzzle.moveTiles(tile, []);
            final newPuzzles = {
              ...state.puzzles,
              player.id: newPuzzle,
            };
            if (newPuzzle.isComplete()) {
              emit(state.copyWith(
                puzzles: newPuzzles,
                status: Status.complete,
                winner: playerIndex,
              ));
            } else {
              emit(state.copyWith(puzzles: newPuzzles));
            }
          }
        }

        break;
      case Status.complete:
        break;
    }
  }

  Map<String, Puzzle> _shufflePuzzles(bool shuffle) {
    final puzzle = _generatePuzzle(_size, shuffle: shuffle);
    return {for (var p in state.players) p.id: puzzle};
  }

  _startTicker() {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick().listen((_) => add(CountdownTicked()));
  }

  Player _changePlayerTheme(Player player, int step) {
    var activeThemes = state.players.map((p) => p.theme);
    var themeIndex = player.theme;
    var numThemes = state.playerThemes.length;

    while (activeThemes.contains(themeIndex)) {
      themeIndex = (themeIndex + step) % numThemes;
    }

    return player.copyWith(theme: themeIndex);
  }

  /// Build a randomized, solvable puzzle of the given size.
  Puzzle _generatePuzzle(int size, {bool shuffle = true}) {
    final correctPositions = <Position>[];
    final currentPositions = <Position>[];
    final whitespacePosition = Position(x: size, y: size);

    // Create all possible board positions.
    for (var y = 1; y <= size; y++) {
      for (var x = 1; x <= size; x++) {
        if (x == size && y == size) {
          correctPositions.add(whitespacePosition);
          currentPositions.add(whitespacePosition);
        } else {
          final position = Position(x: x, y: y);
          correctPositions.add(position);
          currentPositions.add(position);
        }
      }
    }

    if (shuffle) {
      // Randomize only the current tile posistions.
      currentPositions.shuffle();
    }

    var tiles = _getTileListFromPositions(
      size,
      correctPositions,
      currentPositions,
    );

    var puzzle = Puzzle(tiles: tiles);

    if (shuffle) {
      // Assign the tiles new current positions until the puzzle is solvable and
      // zero tiles are in their correct position.
      while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
        currentPositions.shuffle();
        tiles = _getTileListFromPositions(
          size,
          correctPositions,
          currentPositions,
        );
        puzzle = Puzzle(tiles: tiles);
      }
    }

    return puzzle;
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<Tile> _getTileListFromPositions(
    int size,
    List<Position> correctPositions,
    List<Position> currentPositions,
  ) {
    final whitespacePosition = Position(x: size, y: size);
    return [
      for (int i = 1; i <= size * size; i++)
        if (i == size * size)
          Tile(
            value: i,
            correctPosition: whitespacePosition,
            currentPosition: currentPositions[i - 1],
            isWhitespace: true,
          )
        else
          Tile(
            value: i,
            correctPosition: correctPositions[i - 1],
            currentPosition: currentPositions[i - 1],
          )
    ];
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
