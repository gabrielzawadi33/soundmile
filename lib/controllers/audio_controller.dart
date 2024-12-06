import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class SongController extends GetxController {
  final audioQuery = OnAudioQuery();
  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }
  checkPermission() async {
    var permision = await Permission.storage.request();
    if (permision.isGranted) {
    } else {
      checkPermission();
    }
  }
}
