import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js/js.dart';
import 'package:puzzlehack/interop.dart';
import 'package:puzzlehack/models/models.dart';
import 'package:puzzlehack/puzzle/puzzle.dart';
import 'package:puzzlehack/utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

final host = html.window.location.hostname;

class LobbyView extends StatefulWidget {
  const LobbyView({Key? key}) : super(key: key);

  @override
  State<LobbyView> createState() => _LobbyViewState();
}

class _LobbyViewState extends State<LobbyView> {
  final _channelId = Utils.getRandomString(6);

  @override
  void initState() {
    Interop.onPlayerChange = allowInterop(_onPlayerChange);
    Interop.ready(_channelId);

    super.initState();
  }

  _onPlayerChange(JsPlayer player) {
    context.read<PuzzleBloc>().add(PlayerAdded(Player.fromJsPlayer(player)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const _Title(),
          _JoinInstructions(channelId: _channelId),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  final Gradient _titleGradient = const LinearGradient(
    colors: [
      Colors.white,
      Colors.tealAccent,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.purple.shade900,
        child: Center(
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => _titleGradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: SizedBox(
              width: 240,
              height: 240,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.cabin,
                    size: 128.0,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "CouchPuzzler",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 32.0,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "A Flutter P2P Multiplayer Game.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _JoinInstructions extends StatelessWidget {
  const _JoinInstructions({Key? key, required this.channelId})
      : super(key: key);

  final String channelId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PuzzleBloc, PuzzleState>(
      builder: (context, state) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Scan the code with your\nmobile device to join.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple.shade900,
                  ),
                ),
                const SizedBox(height: 32),
                QrImage(
                  data: 'https://$host#/join/$channelId',
                  version: QrVersions.auto,
                  size: 240,
                  gapless: false,
                  foregroundColor: Colors.purple.shade900,
                ),
                const SizedBox(height: 48),
                if (state.numberOfPlayers == 0) ...[
                  _WaitingButton()
                ] else ...[
                  _ReadyButton()
                ],
                const SizedBox(height: 32),
                SizedBox(
                  child: _buildPlayerList(state),
                  width: 180,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayerList(PuzzleState state) {
    var children = state.players.map(
      (e) {
        var theme = state.themeForPlayer(state.players.indexOf(e));
        var ready = state.playersReady[e.id] == true;
        return SizedBox.square(
          dimension: 32,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              color: theme.primaryColor,
              border: Border.all(color: Colors.black26, width: 2),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withAlpha(ready ? 120 : 0),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ready
                ? FractionallySizedBox(
                    widthFactor: .95,
                    heightFactor: .95,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(1000)),
                      ),
                      child: Icon(
                        Icons.thumb_up,
                        size: 14,
                        color: theme.primaryColor,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        );
      },
    ).toList();

    return Wrap(
      children: children,
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
    );
  }
}

class _WaitingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Row(
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
          Text("Waiting for players to join..."),
        ],
      ),
      onPressed: null,
    );
  }
}

class _ReadyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final numPlayers =
        context.select((PuzzleBloc bloc) => bloc.state.numberOfPlayers);
    return ElevatedButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.play_arrow, size: 16),
          const SizedBox(width: 4),
          Text(
              "Start the game with $numPlayers player${numPlayers > 1 ? "s" : ""}"),
        ],
      ),
      onPressed: () => context.read<PuzzleBloc>().add(GameStarted()),
    );
  }
}
