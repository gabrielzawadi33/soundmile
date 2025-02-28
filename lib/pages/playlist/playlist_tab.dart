import 'package:flutter/material.dart';
import 'package:sound_mile/util/color_category.dart';

import '../../helpers/playlist_helper.dart';
import 'playlist_dialog.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final PlaylistHelper _playlistHelper = PlaylistHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: FutureBuilder<List<String>>(
        future: _playlistHelper.getPlaylists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No playlists found.'));
          } else {
            return ListView(
              children: snapshot.data!.map((playlist) {
                return ListTile(
                  title: Text(playlist, style: TextStyle(color: textColor)
                  ,),
                  // onTap: () => _showPlaylistDialog(context, playlist),
                  subtitle: Text(
                    playlistHelper.getTrackCount(playlist),
                    style: TextStyle(color: textColor),),
                  
                  
                );
              }).toList(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddPlaylistModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  
}

