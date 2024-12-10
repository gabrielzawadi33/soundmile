import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerController extends GetxController {
  static final PlayerController _instance = PlayerController._internal();
  final AudioPlayer audioPlayer = AudioPlayer();
  var playingSong = Rx<SongModel?>(null);
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

  // Play next song
  void playNextSong(List<SongModel> songs) {
    if (currentIndex.value < songs.length - 1) {
      currentIndex++;
      playSong(songs[currentIndex.value].uri as String);
    }
  }

  // Play previous song
  void playPreviousSong(List<SongModel> songs) {
    if (currentIndex.value > 0) {
      currentIndex--;
      playSong(songs[currentIndex.value].uri as String);
    }
  }

  // Play song from a URI or file path
  playSong(String uri) {
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri)));
      audioPlayer.play();
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

  togglePlayPause(String uri) {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      try {
        if (audioPlayer.position == Duration.zero) {
          audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri)));
        }
        audioPlayer.play();
      } on Exception catch (e) {
        print('Error: $e');
      }
    }
    isPlaying.value = !isPlaying.value;
  }
}
