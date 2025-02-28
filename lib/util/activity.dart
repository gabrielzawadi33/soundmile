import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sound_mile/controllers/playlist_controller.dart';
import 'package:sound_mile/util/color_category.dart';

import '../helpers/playlist_helper.dart';
import 'constant_widget.dart';

final TextEditingController playlistNameController = TextEditingController();
void addToExistingPlaylist(
    BuildContext context, String playlist, int songId) async {
  final dbHelper = PlaylistHelper();
  int? playlistId = await dbHelper.getPlaylistIdByName(playlist);

  if (playlistId != null) {
    await dbHelper.addSongToPlaylist(playlistId, songId);
    Navigator.of(context).pop(); // Close the dialog
    // ignore: use_build_context_synchronously
    showToast("Added $songId to $playlist", context);
  } else {
    showToast("Playlist not found", context);
  }
}

void createNewPlaylist(
    BuildContext context, String playlistName, int songId) async {
  final dbHelper = PlaylistHelper();
  int playlistId = await dbHelper.createPlaylist(playlistName);
  await dbHelper.addSongToPlaylist(playlistId, songId);
  Navigator.of(context).pop(); // Close the dialog
  showToast("New playlist '$playlistName' created and song added", context);
}

void showAddToPlaylistDialog(BuildContext context, int songId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: containerBg,
        title: Text(
          "Add to Playlist",
          style: TextStyle(color: accentColor),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Select an existing playlist or create a new one:",
              style: TextStyle(fontSize: 10.sp, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            // Existing playlists dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.h),
                ),
                labelText: "Existing Playlists",
              ),
              dropdownColor: Colors.white, // Set the dropdown background color
              style: TextStyle(
                color: Colors.black, // Set the text color
                fontSize: 16.sp, // Set the text size
              ),
              items: PlayListController()
                  .existingPlaylists
                  .map((playlist) => DropdownMenuItem(
                        value: playlist,
                        child: Text(playlist),
                      ))
                  .toList(),
              onChanged: (selectedPlaylist) {
                if (selectedPlaylist != null) {
                  addToExistingPlaylist(context, selectedPlaylist, songId);
                }
              },
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.white, // Set the icon color
              ),
              isExpanded: true, // Make the dropdown take the full width
            ),
            SizedBox(height: 10.h),
            const Divider(),
            SizedBox(height: 10.h),
            // Create a new playlist
            TextField(
              controller: playlistNameController,
              decoration: InputDecoration(
                labelText: "New Playlist Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.h),
                ),
              ),
              style: TextStyle(
                color: Colors.white, // Set the text color to white
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  accentColor), // Use MaterialStateProperty.all
            ),
            onPressed: () {
              if (playlistNameController.text.isNotEmpty) {
                createNewPlaylist(context, playlistNameController.text, songId);
              } else {
                showToast("Please enter a playlist name", context);
              }
            },
            child: const Text(
              "Create Playlist",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
