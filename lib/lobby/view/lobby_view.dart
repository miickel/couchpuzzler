import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js/js.dart';
import 'package:puzzlehack/interop.dart';
import 'package:puzzlehack/models/models.dart';
import 'package:puzzlehack/puzzle/puzzle.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LobbyView extends StatefulWidget {
  const LobbyView({Key? key}) : super(key: key);

  @override
  State<LobbyView> createState() => _LobbyViewState();
}

class _LobbyViewState extends State<LobbyView> {
  final _channelId = "tacotron";

  @override
  void initState() {
    Interop.onPlayerChange = allowInterop(_onPlayerChange);
    Interop.ready(_channelId);

    super.initState();
  }

  _onPlayerChange(JsPlayer player) {
    debugPrint("Player changed ${player.id}");
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
                    Icons.local_pizza_sharp,
                    size: 128.0,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "PuzzleHack",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 32.0,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "A Flutter P2P Multipuzzler.",
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
                  data: 'http://ultimate-machine:8000#/join/$channelId',
                  version: QrVersions.auto,
                  size: 240,
                  gapless: false,
                  foregroundColor: Colors.purple.shade900,
                ),
                const SizedBox(height: 32),
                if (state.numberOfPlayers == 0) ...[
                  _WaitingButton()
                ] else ...[
                  _ReadyButton()
                ],
              ],
            ),
          ),
        );
      },
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
