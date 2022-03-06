import 'package:js/js.dart';

@JS()
@anonymous
class JsPlayer {
  external String get id;

  external const factory JsPlayer({String id});
}
