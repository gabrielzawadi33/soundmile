
import 'package:get/get.dart';
import 'package:sound_mile/controllers/audio_controller.dart';

import '../helpers/playlist_helper.dart';
import '../model/playlist.dart';
import '../model/song_model.dart';

class PlayListController extends GetxController {
  final PlaylistHelper playlistHelper = PlaylistHelper();
  SongController songController = Get.put(SongController());
  List<PlayList> playLists = [];
  var isLoading = false.obs;
  var specialSongList = <Song>[].obs;
 var  existingPlaylists = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlaylists();
  }

  Future<void> fetchPlaylists() async {
    final List<Map<String, dynamic>> maps =
        await playlistHelper.getPlaylistsWithSongCount();
    playLists = maps.map((map) {
      return PlayList(
        id: map['id'],
        name: map['name'],
        image: 'path/to/image', // Update with actual image path
        time: 'some time', // Update with actual time
        songsCount: map['song_count'],
      );
    }).toList();
    update();
  }

  // Future<void> navigateToPlayList(
  //     BuildContext context, int playlistId, String playListName) async {
  //   try {
  //     final songIds = await playlistHelper.getSongIdsForPlaylist(playlistId);
  //     final results = songController.songList
  //         .where((song) => songIds.contains(song.id as int))
  //         .toList();

  //     // ignore: use_build_context_synchronously
  //     // Navigator.pushNamed(
  //     //   context,
  //     //   Routes.playListRoute,
  //     //   arguments: {
  //     //     'playlist': results,
  //     //     'name': playListName,
  //     //   },
  //     // );
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
}