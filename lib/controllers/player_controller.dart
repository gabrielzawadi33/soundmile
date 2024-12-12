import 'dart:math';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerController extends GetxController {
  static final PlayerController _instance = PlayerController._internal();
  factory PlayerController() => _instance;
  PlayerController._internal();

  final AudioPlayer audioPlayer = AudioPlayer();

  var isPlaying = false.obs;
  var currentIndex = 0.obs;
  var isFavourite = false.obs;
  var isShuffle = false.obs;
  var songs = <SongModel>[].obs;
  var generatedNumbers = <int>{}.obs;
  var playingSong = Rx<SongModel?>(null);
  Duration get currentPlaybackPosition => audioPlayer.position;
  

  @override
  void onInit() {
    super.onInit();
    // fetchSongs();
    audioPlayer.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        // Move to next song when the current song is finished
        // playNextSong();
      }
    });
    ;
  }

  Future<List<SongModel>> fetchSongs() async {
    songs.value = await OnAudioQuery().querySongs(
      ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: null,
        uriType: UriType.EXTERNAL,
    );
    // ignore: invalid_use_of_protected_member
    return songs.value;
  }

// generate random index for shuffle
  int generateUniqueRandomNumber(int range) {
    final random = Random();
    if (generatedNumbers.length == range) {
      // All possible numbers have been generated
      generatedNumbers.clear(); // Reset the set if all numbers have been used
    }
    int number;
    do {
      number = random.nextInt(range);
    } while (generatedNumbers.contains(number));
    generatedNumbers.add(number);
    return number;
  }

//plat next Song

  void playNextSong() {
    if (isShuffle.value) {
      currentIndex.value = generateUniqueRandomNumber(songs.length);
    } else {
      if (currentIndex < songs.length - 1) {
        currentIndex++;
      } else {
        // Handle end of the list in original mode
        return;
      }
    }

    audioPlayer.stop();
    playSong( songs[currentIndex.value].uri!);
    playingSong.value = songs[currentIndex.value];
    isPlaying.value = true;
  }

  // Method to resume playback for a song
  Future<void> resumeCurrentSong() async {
    await audioPlayer.seek(currentPlaybackPosition);
    await audioPlayer.play();
  }

//play previous Song
  void playPreviousSong() {
    if (isShuffle.value) {
      if (currentIndex > 0) {
        currentIndex--;
      } else {
        currentIndex.value = songs.length - 1;
      }
    } else {
      if (currentIndex > 0) {
        currentIndex--;
      }
    }

    audioPlayer.stop();
    playSong( songs[currentIndex.value].uri!);
    playingSong.value = songs[currentIndex.value];
    isPlaying.value = true;
  }

// Initialize the player listener
  void initPlayerListener() {
    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        playNextSong();
      }
    });
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

  togglePlayPause() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      try {
        if (audioPlayer.position == Duration.zero) {
          audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(playingSong.value?.uri?? '')));
        }
        audioPlayer.play();
      } on Exception catch (e) {
        print('Error: $e');
      }
    }
    isPlaying.value = !isPlaying.value;
  }
}
