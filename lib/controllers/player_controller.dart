import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sound_mile/controllers/home_conroller.dart';
import 'package:sound_mile/model/extended_song_model.dart';
import 'package:sound_mile/util/pref_data.dart';

class PlayerController extends GetxController {
  static final PlayerController _instance = PlayerController._internal();
  factory PlayerController() => _instance;
  PlayerController._internal();

  final AudioPlayer audioPlayer = AudioPlayer();

  var isPlaying = false.obs;
  var currentIndex = 0.obs;
  var isShuffle = false.obs;
  var loopMode = LoopMode.off.obs;

  var playList = <ExtendedSongModel>[].obs;
  var recentSongs = <ExtendedSongModel>[].obs;
  var allSongs = <ExtendedSongModel>[].obs;
  var playingSong = Rx<ExtendedSongModel?>(null);

  List<AudioSource> songList = [];

  @override
  void onInit() {
    super.onInit();
    _initPlayerListener();
  }

  void _initPlayerListener() {
    audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index < playList.length) {
        currentIndex.value = index;
        playingSong.value = playList[index];
      }
    });

    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed &&
          loopMode.value == LoopMode.off) {
        audioPlayer.stop(); // Stop playback when not looping.
      }
    });
  }

  Future<List<ExtendedSongModel>> fetchSongs() async {
    try {
      List<SongModel> fetchedSongs = await OnAudioQuery().querySongs(
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );

      for (var song in fetchedSongs) {
        String? artworkUri = await fetchArtworkUri(song.id);
        allSongs.add(ExtendedSongModel.fromSongModel(song, artworkUri != null ? Uri.parse(artworkUri) : null));
      }

      recentSongs.value = allSongs.toList()
        ..sort((a, b) => b.dateModified!.compareTo(a.dateModified!));
        return allSongs.value;
    } catch (e) {
      print("Error fetching songs: $e");
      return [];
    }
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

  Future<void> setPlaylistAndPlaySong(List<ExtendedSongModel> songs, int index) async {
    try {
      // Clear previous song list and playlist
      songList.clear();
      playList.value = songs;

      for (var song in songs) {
        songList.add(AudioSource.uri(
          Uri.parse(song.uri!),
          tag: MediaItem(
            id: song.id.toString(),
            album: song.album ?? "Unknown Album",
            title: song.displayNameWOExt,
            artUri: song.artworkUri,
          ),
        ));
      }

      await audioPlayer.setAudioSource(
        ConcatenatingAudioSource(children: songList),
        initialIndex: index,
      );

      currentIndex.value = index;
      playingSong.value = playList[index];

      await audioPlayer.play();
      isPlaying.value = true;
    } catch (e) {
      print("Error setting playlist and playing song: $e");
    }
  }

   togglePlayPause() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
      isPlaying.value = false;
    } else {
      audioPlayer.play();
      isPlaying.value = true;
    }
  }

  void toggleShuffleMode() {
    isShuffle.value = !isShuffle.value;
    audioPlayer.setShuffleModeEnabled(isShuffle.value);
  }

  void toggleLoopMode() {
    loopMode.value =
        LoopMode.values[(loopMode.value.index + 1) % LoopMode.values.length];
    audioPlayer.setLoopMode(loopMode.value);
  }

  Future<void> playNextSong() async {
    await audioPlayer.seekToNext();
  }

  Future<void> playPreviousSong() async {
    await audioPlayer.seekToPrevious();
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
