import 'package:flutter/material.dart';
import 'package:sound_mile/util/color_category.dart';
import '../../helpers/playlist_helper.dart';

class AddPlaylistDialog extends StatefulWidget {
  @override
  _AddPlaylistDialogState createState() => _AddPlaylistDialogState();
}

class _AddPlaylistDialogState extends State<AddPlaylistDialog> {
  final TextEditingController _controller = TextEditingController();
  final PlaylistHelper _playlistHelper = PlaylistHelper();
  String? _selectedPlaylist;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgDark,
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'New Playlist Name',
              labelStyle: TextStyle(color: secondaryColor), // Set label color
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: secondaryColor), // Set border color
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: secondaryColor), // Set focused border color
              ),
            ),
            style: TextStyle(color: secondaryColor), // Set text color
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<String>>(
            future: _playlistHelper.getPlaylists(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No existing playlists.');
              } else {
                return DropdownButton<String>(
                  hint: Text('Select Existing Playlist', style: TextStyle(color: secondaryColor),),
                  value: _selectedPlaylist,
                  onChanged: (value) {
                    setState(() {
                      _selectedPlaylist = value;
                    });
                  },
                  items: snapshot.data!.map((playlist) {
                    return DropdownMenuItem<String>(
                      value: playlist,
                      child: Text(playlist),
                    );
                  }).toList(),
                );
              }
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (_controller.text.isNotEmpty) {
                    await _playlistHelper.createPlaylist(_controller.text);
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showAddPlaylistModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => AddPlaylistDialog(),
  );
}