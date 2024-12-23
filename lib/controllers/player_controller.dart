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
  var initialIndex = 0.obs;
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
    initPlayerListener();
  }

  void initPlayerListener() {
    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        playNextSong();
      }
    });
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

  void playNextSong() {
    if (songs.isEmpty) return; // Guard clause for empty song list

    if (isShuffle.value) {
      initialIndex.value = generateUniqueRandomNumber(songs.length);
    } else {
      if (initialIndex.value < songs.length - 1) {
        initialIndex.value++;
      } else {
        initialIndex.value = 0; // Loop back to the first song if end is reached
      }
    }

    playingSong.value = songs[currentIndex.value];
    playSong(songs[currentIndex.value].uri!, initialIndex.value);
  }

  // Method to resume playback for a song
  Future<void> resumeCurrentSong() async {
    await audioPlayer.seek(currentPlaybackPosition);
    await audioPlayer.play();
  }

  // play previous Song
  void playPreviousSong() {
    if (isShuffle.value) {
      if (initialIndex > 0) {
        initialIndex--;
      } else {
        initialIndex.value = songs.length - 1;
      }
    } else {
      if (initialIndex > 0) {
        initialIndex--;
      }
    }

    audioPlayer.stop();
    playSong(songs[currentIndex.value].uri!, initialIndex.value);
    playingSong.value = songs[currentIndex.value];
    isPlaying.value = true;
  }

  Future<void> playSong(String? uri, int initialIndex) async {
    isPlaying.value = true;
    try {
      if (currentIndex.value == initialIndex) {
        // If the current index is equal to the initial index, resume from the current position
        if (audioPlayer.position > Duration.zero) {
          await audioPlayer.play();
        } else {
          await audioPlayer
              .setAudioSource(AudioSource.uri(Uri.parse(uri ?? '')));
          await audioPlayer.play();
        }
      } else {
        // If the current index is not equal to the initial index, set the playing index to the initial index
        currentIndex.value = initialIndex;
        await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri ?? '')));
        await audioPlayer.play();
      }
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
      isPlaying.value = false;
      audioPlayer.pause();
    } else {
      try {
        playSong(playingSong.value?.uri!, initialIndex.value);
      } on Exception catch (e) {
        print('Error: $e');
      }
    }
  }
}
