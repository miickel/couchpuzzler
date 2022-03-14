import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzlehack/game/game.dart';
import 'package:puzzlehack/gamepad/gamepad.dart';

class PuzzleApp extends StatelessWidget {
  PuzzleApp({Key? key}) : super(key: key);

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const GamePage(),
      ),
      GoRoute(
        path: '/join/:channel',
        builder: (context, state) => GamepadPage(
          channelId: state.params['channel']!,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
    );
  }
}
