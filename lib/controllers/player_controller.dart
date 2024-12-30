import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_service/audio_service.dart';
import 'package:sound_mile/model/extended_song_model.dart';

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
  var isReversed = false.obs;
  var allSongs = <ExtendedSongModel>[].obs;
  var recentSongs = <ExtendedSongModel>[].obs;
  var playList = <ExtendedSongModel>[].obs;

  var generatedNumbers = <int>{}.obs;
  var playingSong = Rx<ExtendedSongModel?>(null);
  var artworkUri = Rx<Uri?>(null);
  Duration get currentPlaybackPosition => audioPlayer.position;
  List<AudioSource> songList = [];

  @override
  void onInit() {
    super.onInit();
    initPlayerListener();
  }

  void initPlayerListener() {
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        playNextSong();
      }
    });
    ;
    audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index < playList.length) {
        currentIndex.value = index;
        playingSong.value = playList[index];
      }
    });
  }

  Future<List<ExtendedSongModel>> fetchSongs() async {
    // Fetch songs using OnAudioQuery.
    List<SongModel> fetchedSongs = await OnAudioQuery().querySongs(
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      sortType: null,
      uriType: UriType.EXTERNAL,
    );

    // Transform each SongModel into ExtendedSongModel by fetching its artwork URI.

    for (var song in fetchedSongs) {
      String? artworkUriString = await fetchArtworkUri(song.id);
      Uri? artworkUri =
          artworkUriString != null ? Uri.parse(artworkUriString) : null;
      allSongs.add(ExtendedSongModel.fromSongModel(song, artworkUri));
    }
    List<ExtendedSongModel> sortedSongs = List.from(allSongs)
      ..sort((a, b) => b.dateModified!.compareTo(a.dateModified!));

// Get the first 5 items from the sorted list
    recentSongs.value = sortedSongs.take(20).toList();
    return allSongs;
  }

  int generateUniqueRandomNumber(int range) {
    final random = Random();
    if (generatedNumbers.length == range) {
      generatedNumbers.clear();
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
      currentIndex.value = generateUniqueRandomNumber(playList.length);
    } else {
      if (currentIndex.value < playList.length - 1) {
        currentIndex.value++;
      } else {
        currentIndex.value = 0;
      }
    }
    playCurrentSong();
  }

  void playCurrentSong() async {
    playingSong.value = playList[currentIndex.value];

    songList[currentIndex.value] = AudioSource.uri(
      Uri.parse(playingSong.value!.uri!),
      tag: MediaItem(
        id: playingSong.value!.id.toString(),
        album: playingSong.value!.album ?? "No Album",
        title: playingSong.value!.displayNameWOExt,
        artUri: playingSong.value!.artworkUri,
      ),
    );

    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(children: songList),
      initialIndex: currentIndex.value,
    );

    await audioPlayer.play();
  }

  void playPreviousSong() {
    if (isShuffle.value) {
      currentIndex.value = generateUniqueRandomNumber(playList.length);
    } else {
      if (currentIndex.value > 0) {
        currentIndex.value--;
      } else {
        currentIndex.value = playList.length - 1;
      }
    }
    playCurrentSong();
  }

  Future<String?> fetchArtworkUri(int songId) async {
    final Uint8List? artwork = await OnAudioQuery().queryArtwork(
      songId,
      ArtworkType.AUDIO,
    );

    if (artwork != null) {
      final tempDir = await getTemporaryDirectory();
      final file =
          await File('${tempDir.path}/$songId.jpg').writeAsBytes(artwork);
      return file.uri.toString();
    }
    return null;
  }

  Future<void> playSong(String? uri, int initialIndex) async {
    isPlaying.value = true;
    try {
      currentIndex.value = initialIndex;
      if (playingSong.value != null) {
        for (var song in playList) {
          songList.add(
            AudioSource.uri(
              Uri.parse(song.uri!),
              tag: MediaItem(
                id: song.id.toString(),
                album: song.album ?? "No Album",
                title: song.displayNameWOExt,
                artUri: song.artworkUri,
              ),
            ),
          );
        }

        await audioPlayer.setAudioSource(
          ConcatenatingAudioSource(children: songList),
          initialIndex: initialIndex,
        );

        await audioPlayer.play();
      } else {}
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
      isPlaying.value = true;
      audioPlayer.play();
    }
  }
}
