import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:puzzlehack/app.dart';
import 'package:puzzlehack/app_bloc_observer.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(const PuzzleApp()),
    blocObserver: AppBlocObserver(),
  );
}
