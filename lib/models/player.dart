import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String id;
  final bool hosting;

  const Player(this.id, this.hosting);

  @override
  List<Object?> get props => [id];
}
