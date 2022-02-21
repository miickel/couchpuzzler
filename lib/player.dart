import 'package:equatable/equatable.dart';
import 'package:js/js.dart';

@JS()
@anonymous
class Player extends Equatable {
  external String get id;
  external bool get hosting;

  external const factory Player({String id, bool hosting});

  @override
  List<Object?> get props => [id];

  //@override
  //external bool operator ==(Object other) => other is Player && other.id == id;
}
