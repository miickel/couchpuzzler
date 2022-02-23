import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
import 'package:puzzlehack/app.dart';
import 'package:puzzlehack/app_bloc_observer.dart';

void main() {
  // GoRouter.setUrlPathStrategy(UrlPathStrategy.path);

  BlocOverrides.runZoned(
    () => runApp(PuzzleApp()),
    blocObserver: AppBlocObserver(),
  );
}
