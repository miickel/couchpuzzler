import 'dart:html';

import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:puzzlehack/player.dart';
import 'package:puzzlehack/utils.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'interop.dart';

String? getChannelQueryParam() {
  var uri = Uri.dataFromString(window.location.href);
  return uri.queryParameters['channel'];
}

void main() {
  var channel = getChannelQueryParam();
  runApp(MyApp(
    channel: channel,
  ));
}

class MyApp extends StatelessWidget {
  final String? channel;
  const MyApp({Key? key, this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Puzzle Hack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "title", channel: channel),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, this.channel})
      : super(key: key);
  final String title;
  final String? channel;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final String _baseUrl = "http://ultimate-machine:8000";
  final List<Player> _players = [];
  Player? _player;
  String? _channelId;

  @override
  void initState() {
    Interop.onPlayerChange = allowInterop(handlePlayerChange);
    Interop.onMove = allowInterop(handlePlayerMove);

    var hosting = false;

    _channelId = widget.channel;

    if (_channelId == null) {
      _channelId = Utils.getRandomString(6);
      hosting = true;
    }

    _player = Player(hosting: hosting, id: Utils.getRandomString(12));
    Interop.ready(_channelId!, _player!);

    super.initState();
  }

  void handlePlayerChange(Player player) {
    setState(() {
      _players.removeWhere((p) => p.id == player.id);
      _players.add(player);
    });
  }

  void handlePlayerMove(String playerId, String direction) {
    debugPrint("Move registered: $playerId - $direction");
  }

  @override
  Widget build(BuildContext context) {
    var joinUrl =
        _channelId != null ? '$_baseUrl?channel=$_channelId' : _baseUrl;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QrImage(
              data: joinUrl,
              version: QrVersions.auto,
              size: 220,
              gapless: false,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _players.length,
                itemBuilder: (BuildContext context, int index) {
                  var player = _players[index];
                  return ListTile(
                    title: Text(player.id),
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    Interop.move(_player!.id, "up");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
