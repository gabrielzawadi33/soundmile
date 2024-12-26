import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';

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
    if (isShuffle.value) {
      currentIndex.value = generateUniqueRandomNumber(songs.length);
    } else {
      if (currentIndex.value < songs.length - 1) {
        currentIndex.value++;
      } else {
        currentIndex.value = 0; // Loop back to the first song if end is reached
      }
    }
    playingSong.value = songs[currentIndex.value];
    playSong(songs[currentIndex.value].uri!, currentIndex.value);
  }

  // Method to resume playback for a song
  Future<void> resumeCurrentSong() async {
    await audioPlayer.seek(currentPlaybackPosition);
    await audioPlayer.play();
  }

  // play previous Song
  void playPreviousSong() {
    if (isShuffle.value) {
      currentIndex.value = generateUniqueRandomNumber(songs.length);
    } else {
      if (currentIndex.value > 0) {
        currentIndex.value--;
      } else {
        currentIndex.value =
            songs.length - 1; // Loop back to the last song if start is reached
      }
    }
    playingSong.value = songs[currentIndex.value];
    playSong(songs[currentIndex.value].uri!, currentIndex.value);
  }

  Future<void> playSong(String? uri, int initialIndex) async {
    isPlaying.value = true;
    try {
      currentIndex.value = initialIndex;
      if (playingSong.value != null) {
                // Fetch the artwork for the current song
       final Uint8List? artwork = await OnAudioQuery().queryArtwork(
          playingSong.value!.id,
          ArtworkType.AUDIO,
        );
        
      String? artworkUri;
        if (artwork != null) {
          final tempDir = await getTemporaryDirectory();
          final file = await File('${tempDir.path}/${playingSong.value!.id}.jpg').writeAsBytes(artwork);
          artworkUri = file.uri.toString();
        }
        await audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(uri ?? ''),
            tag: MediaItem(
              id: playingSong.value!.id.toString(),
              album: playingSong.value!.album ?? 'Unknown Album',
              title: playingSong.value!.displayName,
              artist: playingSong.value!.artist ?? 'Unknown Artist',
              artUri:artworkUri != null ? Uri.parse(artworkUri) : null,
            ),
          ),
        );
        await audioPlayer.play();
      } else {
        print('Error: playingSong.value is null');
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
        playSong(playingSong.value?.uri!, currentIndex.value);
      } on Exception catch (e) {
        print('Error: $e');
      }
    }
  }
}
