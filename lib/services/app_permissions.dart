import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  static Future<void> requestStoragePermission() async {
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request();
    }
  }

  static Future<bool> isStoragePermissionGranted() async{
    return await Permission.storage.isGranted;
  }
}