import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../model/extended_song_model.dart';

class SearchController extends GetxController {
  var allSongs = <ExtendedSongModel>[].obs; // Observable list of songs
  var filteredSongs = <ExtendedSongModel>[].obs; // List to hold filtered results

  // Method to filter the allSongs list based on search input
  void onItemChanged(String value) {
    if (value.isEmpty) {
      filteredSongs.value = allSongs;
    } else {
      filteredSongs.value = allSongs.where((song) {
        return song.title.toLowerCase().contains(value.toLowerCase()) ||
               song.artist!.toLowerCase().contains(value.toLowerCase());
      }).toList();
    }
    update();
  }

  // Method to remove an item from the filteredSongs list
  void itemRemove(int index) {
    var song = filteredSongs[index];
    filteredSongs.removeAt(index);
    allSongs.remove(song); // Optionally remove from allSongs as well
    update();
  }
}
