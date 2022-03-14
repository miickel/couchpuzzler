import 'package:js/js.dart';

@JS()
@anonymous
class JsPlayer {
  external String get id;
  external int get theme;

  external const factory JsPlayer({required String id, required int theme});
}
