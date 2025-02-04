import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sound_mile/controllers/player_controller.dart';
import 'package:sound_mile/util/constant_widget.dart';
import '../../util/color_category.dart';
import '../../util/constant.dart';

class MusicPlayer extends StatefulWidget {
  List<SongModel>? songs;
  int? index;

  MusicPlayer({super.key, this.songs, this.index});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  PlayerController playerController = Get.put(PlayerController());

  @override
  void initState() {
    super.initState();
  }

  // late int currentIndex;
  // bool isThirtySecondsReached = false;
  //
  // late List<String> existingPlaylists;

  // fetchPlaylists() async {
  //   final dbHelper = PlaylistHelper();
  //   existingPlaylists = await dbHelper.getPlaylists();
  //   setState(() {});
  // }

  // void _showPlaylistDialog(BuildContext context, int songId) {
  //   final TextEditingController playlistNameController =
  //       TextEditingController();

  //   void addToExistingPlaylist(
  //       BuildContext context, String playlist, int songId) async {
  //     final dbHelper = PlaylistHelper();
  //     int? playlistId = await dbHelper.getPlaylistIdByName(playlist);

  //     if (playlistId != null) {
  //       await dbHelper.addSongToPlaylist(playlistId, songId);
  //       Navigator.of(context).pop(); // Close the dialog
  //       // ignore: use_build_context_synchronously
  //       showToast("Added $songId to $playlist", context);
  //     } else {
  //       showToast("Playlist not found", context);
  //     }
  //   }

  // void createNewPlaylist(
  //     BuildContext context, String playlistName, int songId) async {
  //   final dbHelper = PlaylistHelper();
  //   int playlistId = await dbHelper.createPlaylist(playlistName);
  //   await dbHelper.addSongToPlaylist(playlistId, songId);
  //   Navigator.of(context).pop(); // Close the dialog
  //   showToast("New playlist '$playlistName' created and song added", context);
  // }

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         backgroundColor: containerBg,
  //         title: Text(
  //           "Add to Playlist",
  //           style: TextStyle(color: accentColor),
  //           textAlign: TextAlign.center,
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(
  //               "Select an existing playlist or create a new one:",
  //               style: TextStyle(fontSize: 10.sp, color: Colors.white),
  //               textAlign: TextAlign.center,
  //             ),
  //             SizedBox(height: 10.h),
  //             // Existing playlists dropdown
  //             DropdownButtonFormField<String>(
  //               decoration: InputDecoration(
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(8.h),
  //                 ),
  //                 labelText: "Existing Playlists",
  //               ),
  //               dropdownColor:
  //                   Colors.white, // Set the dropdown background color
  //               style: TextStyle(
  //                 color: Colors.black, // Set the text color
  //                 fontSize: 16.sp, // Set the text size
  //               ),
  //               items: existingPlaylists
  //                   .map((playlist) => DropdownMenuItem(
  //                         value: playlist,
  //                         child: Text(playlist),
  //                       ))
  //                   .toList(),
  //               onChanged: (selectedPlaylist) {
  //                 if (selectedPlaylist != null) {
  //                   addToExistingPlaylist(context, selectedPlaylist, songId);
  //                 }
  //               },
  //               icon: Icon(
  //                 Icons.arrow_drop_down,
  //                 color: Colors.white, // Set the icon color
  //               ),
  //               isExpanded: true, // Make the dropdown take the full width
  //             ),
  //             SizedBox(height: 10.h),
  //             const Divider(),
  //             SizedBox(height: 10.h),
  //             // Create a new playlist
  //             TextField(
  //               controller: playlistNameController,
  //               decoration: InputDecoration(
  //                 labelText: "New Playlist Name",
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(8.h),
  //                 ),
  //               ),
  //               style: TextStyle(
  //                 color: Colors.white, // Set the text color to white
  //               ),
  //             )
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text("Cancel"),
  //           ),
  //           ElevatedButton(
  //             style: ButtonStyle(
  //               backgroundColor: MaterialStateProperty.all(
  //                   accentColor), // Use MaterialStateProperty.all
  //             ),
  //             onPressed: () {
  //               if (playlistNameController.text.isNotEmpty) {
  //                 createNewPlaylist(
  //                     context, playlistNameController.text, songId);
  //               } else {
  //                 showToast("Please enter a playlist name", context);
  //               }
  //             },
  //             child: const Text(
  //               "Create Playlist",
  //               style: TextStyle(color: Colors.white),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchPlaylists();
  //   currentIndex = widget.currentIndex;
  //   shuffledSongs = List.from(widget.songs); // Initialize shuffledSongs

  //   // Check if a song is already playing
  //   if (audioController.playingSong.value != null &&
  //       audioController.audioPlayer.playing) {
  //     // If the same song is already playing, resume it
  //     if (audioController.playingSong.value!.id ==
  //         widget.songs[currentIndex].id) {
  //       isThirtySecondsReached =
  //           audioController.audioPlayer.position.inSeconds >= 30;
  //     } else {
  //       // If a different song, prepare the new one
  //       _prepareNetworkAudio();
  //     }
  //   } else {
  //     // No song is playing, start fresh
  //     _prepareNetworkAudio();
  //   }

  //   audioController.audioPlayer.positionStream.listen((position) {
  //     if (!isThirtySecondsReached && position.inSeconds >= 30) {
  //       audioController.icrementPlayCount(widget.songs[currentIndex].id!);
  //       isThirtySecondsReached = true;
  //     }
  //   });

  //   audioController.audioPlayer.playerStateStream.listen((state) {
  //     if (state.processingState == ProcessingState.completed) {
  //       playNextSong();
  //     }
  //   });
  // }

  // Future<void> _prepareNetworkAudio() async {
  //   if (widget.songs.isNotEmpty) {
  //     await audioController.audioPlayer
  //         .setUrl(widget.songs[currentIndex].audioPath!);
  //     isThirtySecondsReached = false; // Reset for each new song
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    // You can comment out the following line to prevent disposal.
    // audioController.audioPlayer.dispose();
  }

  void backClick() {
    Constant.backToPrev(context);
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   playerController.currentIndex.value = widget.index;
    // });

    setStatusBarColor(bgDark);
    Constant.setupSize(context);
    return WillPopScope(
      onWillPop: () async {
        backClick();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: bgDark,
        body: Stack(
          children: [
            buildMusicImage(
              context,
              0.0,
              boxFit: BoxFit.fitHeight, // Example BoxFit
            ),
            Container(
                decoration: BoxDecoration(
                  color: bgDark.withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22.h),
                    topRight: Radius.circular(22.h),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          getVerSpace(50.h),
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () {
                                backClick();
                              },
                              icon: Icon(
                                CupertinoIcons.arrow_left,
                                size: 30.h,
                                color: textColor,
                              ),
                            ),
                          ),
                          Obx(() {
                            return Column(
                              children: [
                                Text(
                                    playerController
                                            .playingSong.value?.title ??
                                        '',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ],
                            ).paddingSymmetric(horizontal: 20);
                          }),
                          getVerSpace(30.h),
                        ],
                      ),
                    ),

                    // Obx(() {
                    //   return getAppBar(() {
                    //     backClick();
                    //   },
                    //       playerController
                    //               .playbackState.value.playingSong?.title ??
                    //           '');
                    // }),
                    // getVerSpace(10.h),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        primary: true,
                        shrinkWrap: false,
                        children: [
                          buildMusicPoster(),
                          getVerSpace(20.h),
                          buildMusicDetail(),
                          getVerSpace(30.h),
                          buildPlaybackControls(),
                          getVerSpace(30.h),
                          // buildPlaylistSection(),
                          // Center(
                          //   child: Text(
                          //     'Lyrics',
                          //     style: TextStyle(color: textColor),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

// Inside your buildPlaybackControls method
  Widget buildPlaybackControls() {
    return Container(
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(22.h),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 20.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Current Position Display
              StreamBuilder<Duration>(
                stream: playerController.audioPlayer.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final minutes = position.inMinutes.toString().padLeft(2, '0');
                  final seconds =
                      (position.inSeconds % 60).toString().padLeft(2, '0');
                  return getCustomFont("$minutes:$seconds", 13.sp, textColor, 1,
                      fontWeight: FontWeight.w700);
                },
              ),
              // Position Slider
              StreamBuilder<Duration?>(
                stream: playerController.audioPlayer.durationStream,
                builder: (context, snapshot) {
                  final duration = snapshot.data ?? Duration.zero;
                  final maxDuration = duration.inMilliseconds.toDouble();
                  return StreamBuilder<Duration>(
                    stream: playerController.audioPlayer.positionStream,
                    builder: (context, positionSnapshot) {
                      final position =
                          positionSnapshot.data?.inMilliseconds.toDouble() ??
                              0.0;
                      return Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius:
                                    6.0), // Adjust the radius as needed
                            activeTrackColor: secondaryColor,
                            inactiveTrackColor: textColor.withOpacity(0.5),
                            thumbColor: textColor,
                            overlayColor: secondaryColor.withOpacity(0.2),
                          ),
                          child: Slider(
                            min: 0.0,
                            max: maxDuration,
                            value:
                                position > maxDuration ? maxDuration : position,
                            onChanged: (value) {
                              playerController.audioPlayer
                                  .seek(Duration(milliseconds: value.toInt()));
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              // Total Duration Display
              StreamBuilder<Duration?>(
                stream: playerController.audioPlayer.durationStream,
                builder: (context, snapshot) {
                  final duration = snapshot.data ?? Duration.zero;
                  final minutes = duration.inMinutes.toString().padLeft(2, '0');
                  final seconds =
                      (duration.inSeconds % 60).toString().padLeft(2, '0');
                  return getCustomFont("$minutes:$seconds", 14.sp, textColor, 1,
                      fontWeight: FontWeight.w700);
                },
              ),
            ],
          ),
          // getVerSpace(5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(CupertinoIcons.backward_end_fill,
                    color: textColor, size: 30.h),
                onPressed: () {
                  playerController.playPreviousSong();
                },
              ),
              getHorSpace(30.h),
              Obx(() => IconButton(
                    icon: Icon(
                      playerController.isPlaying.value
                          ? CupertinoIcons.pause_circle
                          : CupertinoIcons.play_circle_fill,
                      size: 72.h,
                      color: textColor,
                    ),
                    onPressed: () async {
                      await playerController.togglePlayPause();
                    },
                  )),
              getHorSpace(30.h),
              IconButton(
                icon: Icon(CupertinoIcons.forward_end_fill,
                    color: textColor, size: 30.h),
                onPressed: () {
                  playerController.playNextSong();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                return IconButton(
                  icon: playerController.isShuffle.value
                      ? Icon(CupertinoIcons.shuffle_thick,
                          color: secondaryColor)
                      : Icon(CupertinoIcons.shuffle, color: textColor),
                  onPressed: () {
                    playerController.toggleShuffleMode();
                    showToast(
                        playerController.isShuffle.value
                            ? "Shuffle mode enabled"
                            : "Shuffle mode disabled",
                        context);
                  },
                );
              }),
              IconButton(
                icon: Icon(Icons.replay_5, color: textColor),
                onPressed: () {
                  final currentPosition = playerController.audioPlayer.position;
                  if (currentPosition - Duration(seconds: 5) > Duration.zero) {
                    playerController.audioPlayer
                        .seek(currentPosition - Duration(seconds: 5));
                    showToast("Back 5 seconds", context);
                  } else {
                    playerController.audioPlayer.seek(Duration.zero);
                    showToast("Reached start of song", context);
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.forward_5, color: textColor),
                onPressed: () {
                  final currentPosition = playerController.audioPlayer.position;
                  final duration = playerController.audioPlayer.duration;
                  if (currentPosition + Duration(seconds: 5) < duration!) {
                    playerController.audioPlayer
                        .seek(currentPosition + Duration(seconds: 5));
                    showToast(
                      "Forward 5 seconds",
                      context,
                    );
                  } else {
                    playerController.audioPlayer.seek(duration);
                    showToast("Reached end of song", context);
                  }
                },
              ),
              IconButton(
                icon: Obx(() {
                  switch (playerController.loopMode.value) {
                    case LoopMode.one:
                      return Icon(CupertinoIcons.repeat_1,
                          color: secondaryColor);
                    case LoopMode.all:
                      return Icon(CupertinoIcons.repeat, color: secondaryColor);
                    default: // LoopMode.off
                      return Icon(Icons.repeat, color: textColor);
                  }
                }),
                onPressed: () {
                  playerController.toggleLoopMode();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPlaylistSection() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // getCustomFont('  ${widget.songs.length.toString()}  Songs', 15.sp,
            //     "#F9F9F9".toColor(), 1,
            //     fontWeight: FontWeight.w700),
            //   GestureDetector(
            //     onTap: () {
            //       // Constant.sendToNext(context, Routes.playListRoute);
            //     },
            //     child: getCustomFont("View All", 12.sp, accentColor, 1,
            //         fontWeight: FontWeight.w700),
            //   )
          ],
        ),
        getVerSpace(20.h),
        // buildSongsList(),
        getVerSpace(40.h),
        // buildPlayListButton(context, widget.songs[currentIndex].id!),
        getVerSpace(40.h),
      ],
    );
  }

  // ListView buildSongsList() {
  //   return ListView.builder(
  //     itemCount: 3,
  //     primary: false,
  //     shrinkWrap: true,
  //     itemBuilder: (context, index) {
  //       Song song = widget.songs[index];
  //       return Container(
  //         padding: EdgeInsets.all(12.h),
  //         decoration: BoxDecoration(
  //             color: containerBg, borderRadius: BorderRadius.circular(22.h)),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     height: 76.h,
  //                     width: 76.h,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(22.h),
  //                       image: DecorationImage(
  //                           image: NetworkImage(song.photo!),
  //                           fit: BoxFit.cover),
  //                     ),
  //                   ),
  //                   // getAssetImage(widget.songs[index].artistName!,
  //                   //     height: 56.h, width: 56.h),
  //                   getHorSpace(12.h),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       getCustomFont(song.title!, 16.sp, Colors.white, 1,
  //                           fontWeight: FontWeight.w700),
  //                       getVerSpace(6.h),
  //                       getCustomFont("${widget.songs[index].artistName!} ",
  //                           12.sp, searchHint, 1,
  //                           fontWeight: FontWeight.w400)
  //                     ],
  //                   )
  //                 ],
  //               ),
  //             ),
  //             Row(
  //               children: [
  //                 Icon(
  //                   Icons.favorite_border,
  //                   color: Colors.white,
  //                   size: 20.h,
  //                 ),
  //                 getHorSpace(11.h),
  //                 getSvgImage("play_white.svg", height: 20.h, width: 20.h),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ).marginOnly(bottom: 20.h);
  //     },
  //   );A
  // }

  Column buildMusicDetail() {
    return Column(
      children: [
        Obx(() {
          return getCustomFont(
              playerController.playingSong.value?.title ?? '',
              18.sp,
              textColor,
              1,
              fontWeight: FontWeight.w700);
        }),
        getVerSpace(2.h),
        Obx(
          () {
            return getMultilineCustomFont(
                playerController.playingSong.value?.artist ?? '',
                12.sp,
                hintColor,
                fontWeight: FontWeight.w400);
          },
        ),
      ],
    );
  }

  Widget buildMusicPoster() {
    return Container(
        height: 300.h,
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(2.h),
            ),
        child: buildMusicImage(
          context,
          20.0, // Example border radius
          boxFit: BoxFit.fitWidth, // Example BoxFit
        ));

    // Widget buildPlayListButton(BuildContext context, int songId) {
    //   return getButton(context, accentColor, "Add To Playlist", Colors.black, () {
    //     _showPlaylistDialog(context, songId);
    //   }, 18.sp,
    //       weight: FontWeight.w700,
    //       buttonHeight: 60.h,
    //       borderRadius: BorderRadius.circular(12.h));
    // }
  }
}
