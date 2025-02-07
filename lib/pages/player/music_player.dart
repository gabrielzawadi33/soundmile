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

  @override
  void dispose() {
    super.dispose();
  }

  void backClick() {
    Constant.backToPrev(context);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;
    final screenHeight = mediaQueryData.size.height;
    final orientation = mediaQueryData.orientation;
    return WillPopScope(
      onWillPop: () async {
        backClick();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 61, 37, 37),
        
        body: Stack(
          children: [
            buildMusicImage(
              context,
              0.0,
            ),
            Container(
                height: screenHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      
                      colors: [bgDark.withOpacity(0.95),Color.fromARGB(255, 61, 37, 37)]),
                  // color: bgDark.withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22.r),
                    topRight: Radius.circular(22.r),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      // color: Color.fromARGB(255, 61, 37, 37),
                      child: Column(
                        children: [
                          getVerSpace(40.h),
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () {
                                backClick();
                              },
                              icon: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 40.h,
                                color: textColor,
                              ),
                            ),
                          ),
                          getVerSpace(20.h),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        primary: true,
                        shrinkWrap: false,
                        children: [
                          buildMusicPoster(),
                          getVerSpace(20.h),
                          buildMusicDetail(),
                          getVerSpace(20.h),
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
        // color: accentColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
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
                          : CupertinoIcons.play_circle,
                      size: 72.h,
                      color: textColor,
                    ),
                    onPressed: () async {
                      playerController.togglePlayPause();
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
                icon: Icon(Icons.replay_10, color: textColor),
                onPressed: () {
                  final currentPosition = playerController.audioPlayer.position;
                  if (currentPosition - Duration(seconds: 10) > Duration.zero) {
                    playerController.audioPlayer
                        .seek(currentPosition - Duration(seconds: 5));
                    showToast("Back 10 seconds", context);
                  } else {
                    playerController.audioPlayer.seek(Duration.zero);
                    showToast("Reached start of song", context);
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.forward_10, color: textColor),
                onPressed: () {
                  final currentPosition = playerController.audioPlayer.position;
                  final duration = playerController.audioPlayer.duration;
                  if (currentPosition + Duration(seconds: 10) < duration!) {
                    playerController.audioPlayer
                        .seek(currentPosition + Duration(seconds: 10));
                    showToast(
                      "Forward 10ss seconds",
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
          return getCustomFont(playerController.playingSong.value?.title ?? '',
              15.sp, textColor, 1,
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
    return SizedBox(height: 400.h, child: buildMusicImage(context, 20));
  }
}
