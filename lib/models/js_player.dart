import 'package:js/js.dart';

@JS()
@anonymous
class JsPlayer {
  external String get id;
  external bool get hosting;

  external const factory JsPlayer({String id, bool hosting});
}
