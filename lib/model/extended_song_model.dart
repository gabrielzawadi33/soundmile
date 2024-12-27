import 'package:on_audio_query/on_audio_query.dart';

class ExtendedSongModel extends SongModel {
  final Uri? artworkUri;

  // Constructor that initializes the base SongModel with _info and adds artworkUri.
  ExtendedSongModel(Map<dynamic, dynamic> info, {this.artworkUri}) : super(info);

  // Factory method to create ExtendedSongModel from a SongModel.
  factory ExtendedSongModel.fromSongModel(SongModel song, Uri? artworkUri) {
    return ExtendedSongModel(song.getMap, artworkUri: artworkUri);
  }

  @override
  String toString() {
    return '${super.toString()}, artworkUri: $artworkUri';
  }
}
