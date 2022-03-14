import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PlayerTheme extends Equatable {
  final String name;
  final Color primaryColor;

  const PlayerTheme({required this.name, required this.primaryColor});

  static PlayerTheme empty() {
    return const PlayerTheme(name: "Empty", primaryColor: Colors.blue);
  }

  @override
  List<Object?> get props => [name, primaryColor];
}
