import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_mile/controllers/player_controller.dart';

class SongController extends GetxController {
  final audioQuery = OnAudioQuery();
  var isGranted = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  Future<List<SongModel>> checkPermission() async {
    var permision = await Permission.storage.request();
    if (permision.isGranted) {
      return  await PlayerController().fetchSongs();
    }
    else {

      return checkPermission();
    }
  }
}
