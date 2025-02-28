import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
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
    loadLastPlayedSong(); // Load last played song before initializing listeners
    _initPlayerListener();
  }

  void saveLastPlayedSong(ExtendedSongModel song) async {
    await prefData.saveLastPlayedSong(song);
  }

  Future<void> loadLastPlayedSong() async {
    ExtendedSongModel? lastPlayedSong = await prefData.loadLastPlayedSong();

    playingSong.value = lastPlayedSong;
    songList.clear();
    songList = [AudioSource.uri(Uri.parse(lastPlayedSong.uri!))];

    await audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(lastPlayedSong.uri!),
        tag: MediaItem(
          id: lastPlayedSong.id.toString(),
          album: lastPlayedSong.album ?? "Unknown Album",
          title: lastPlayedSong.displayNameWOExt,
          artUri: lastPlayedSong.artworkUri,
        ),
      ),
    );

    currentIndex.value =
        playList.indexWhere((song) => song.id == lastPlayedSong.id);
    }

  void _initPlayerListener() {
    audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index < playList.length) {
        currentIndex.value = index;
        playingSong.value = playList[index];
        saveLastPlayedSong(playList[index]); // Save song when changed
      }
    });

    audioPlayer.playerStateStream.listen((state) async {
      if (state.processingState == ProcessingState.completed) {
        if (!audioPlayer.hasNext && loopMode.value == LoopMode.off) {
          // No next song and looping is off, reset to first song
          isPlaying.value = false;
          await audioPlayer.seek(Duration.zero,
              index: 0); // Reset to the first song
          await audioPlayer.stop(); // Stop playback
        }
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
        allSongs.add(ExtendedSongModel.fromSongModel(
            song, artworkUri != null ? Uri.parse(artworkUri) : null));
      }

      await getRecent(allSongs);

      return allSongs;
    } catch (e) {
      print("Error fetching songs: $e");
      return [];
    }
  }

  Future<List<ExtendedSongModel>> getRecent(
      List<ExtendedSongModel> allSongs) async {
    // Use a Set to filter out duplicates based on a unique property
    final uniqueSongs = <String, ExtendedSongModel>{};

    for (var song in allSongs) {
      uniqueSongs[song.uri.toString()] =
          song; // Assuming 'uri' is a unique property
    }

    recentSongs.value = uniqueSongs.values.toList()
      ..sort((a, b) => b.dateModified!.compareTo(a.dateModified!));

    return recentSongs;
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

  Future<void> setPlaylistAndPlaySong(
      List<ExtendedSongModel> songs, int index) async {
    try {
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
      isPlaying.value = true;

      currentIndex.value = index;
      playingSong.value = playList[index];

      await audioPlayer.play();
    } catch (e) {
      print("Error setting playlist and playing song: $e");
    }
  }

  void togglePlayPause() async {
    if (audioPlayer.playing) {
      isPlaying.value = false;
      await audioPlayer.pause();
    } else {
      if (audioPlayer.currentIndex == null) {
        // Try to set audio source again if not set
        if (playList.isNotEmpty) {
          setPlaylistAndPlaySong(playList, currentIndex.value);
        }
      } else {
        isPlaying.value = true;
        await audioPlayer.play();
      }
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
    // if the Loop mode ==1
    if (loopMode.value == LoopMode.one) {
      if (audioPlayer.hasNext) {
        // checking id there is a next song on the playlist
        await audioPlayer.seek(Duration.zero,
            index: (audioPlayer.currentIndex! + 1));
      } else {
        await audioPlayer.seek(Duration.zero, index: 0);
      }
    } else {
      await audioPlayer.seekToNext();
    }
  }

  Future<void> playPreviousSong() async {
    // if the Loop mode ==1
    if (loopMode.value == LoopMode.one) {
      if (audioPlayer.hasPrevious) {
        // checking id there is a prev song on the playlist
        await audioPlayer.seek(Duration.zero,
            index: audioPlayer.currentIndex! - 1);
      } else {
        await audioPlayer.seek(Duration.zero, index: songList.length - 1);
      }
    } else {
      await audioPlayer.seekToPrevious();
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
