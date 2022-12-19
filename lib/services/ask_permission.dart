import 'package:permission_handler/permission_handler.dart';

class HandlePermissions {
  static askPermission() async {
    var resp = await [
      Permission.storage,
      Permission.camera,
      Permission.audio,
      Permission.microphone,
      Permission.location
    ].request();
  }
}
