import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LobbyView extends StatelessWidget {
  const LobbyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: const [
          Title(),
          JoinInstructions(),
        ],
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key? key}) : super(key: key);

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

class JoinInstructions extends StatelessWidget {
  const JoinInstructions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              data: 'Whoop whoop 🕺',
              version: QrVersions.auto,
              size: 240,
              gapless: false,
              foregroundColor: Colors.purple.shade900,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(
                    width: 16,
                    height: 16,
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
            )
          ],
        ),
      ),
    );
  }
}
