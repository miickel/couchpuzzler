import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'lobby/lobby.dart';

class PuzzleApp extends StatelessWidget {
  PuzzleApp({Key? key}) : super(key: key);

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LobbyPage(),
      ),
      GoRoute(
        path: '/join/:channel',
        builder: (context, state) => Scaffold(
          body: Center(
            child: Text(
              "join channel: ${state.params['channel']!}",
            ),
          ),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}
