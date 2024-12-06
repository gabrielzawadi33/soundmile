import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerController extends GetxController {
  static final PlayerController _instance = PlayerController._internal();
  final AudioPlayer audioPlayer = AudioPlayer();
  var  playingSong = Rx<SongModel>;
  var isPlaying = false.obs;
  var currentIndex = 0.obs;
  var isFavourite = false.obs;
  var isShuffle = false.obs;

  PlayerController._internal();

  factory PlayerController() {
    return _instance;
  }

  Duration get currentPlaybackPosition => audioPlayer.position;

  // Method to resume playback for a song
  Future<void> resumeCurrentSong() async {
    await audioPlayer.seek(currentPlaybackPosition);
    await audioPlayer.play();
  }

  @override
  void onInit() {
    super.onInit();

    audioPlayer.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        // Move to next song when the current song is finished
        // playNextSong();
      }
    });
  }

  // Toggle play/pause state
  Future<void> togglePlayPause() async {
    isPlaying.value = !isPlaying.value;
    if (audioPlayer.playing) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }
  }

  // Play next song
  void playNextSong(List<String> songUrls) {
    if (currentIndex.value < songUrls.length - 1) {
      currentIndex++;
      playSong(songUrls[currentIndex.value]);
    }
  }

  // Play previous song
  void playPreviousSong(List<String> songUrls) {
    if (currentIndex.value > 0) {
      currentIndex--;
      playSong(songUrls[currentIndex.value]);
    }
  }

  

  // Play song from a URL or file path
  Future<void> playSong(String url) async {
    try {
      await audioPlayer.setUrl(url); // Use setFilePath for local files
      await audioPlayer.play();
      isPlaying.value = true;
    } catch (e) {
      print("Error playing song: $e");
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}