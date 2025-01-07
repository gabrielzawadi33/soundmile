import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../controllers/audio_controller.dart';
import '../../controllers/player_controller.dart';
import '../../model/extended_song_model.dart';
import '../../util/color_category.dart';
import '../../util/constant.dart';
import '../../util/constant_widget.dart';
import '../player/music_player.dart';

class AllRecentMusic extends StatefulWidget {
  const AllRecentMusic({super.key});

  @override
  State<AllRecentMusic> createState() => _AllRecentMusicState();
}

class _AllRecentMusicState extends State<AllRecentMusic> {
  SongController songController = Get.find<SongController>();
  PlayerController playerController = Get.put(PlayerController());
  void backClick() {
    Constant.backToPrev(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgDark,
        body: Column(
          children: [
            getVerSpace(10.h),
            getAppBar(() {
              backClick();
            }, 'Recent Music'),
            Expanded(child: buildRecentMusicList()),
          ],
        ),
      ),
    );
  }

  Column buildRecentMusicList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getVerSpace(20.h),
        Expanded(
          child: Obx(
            () {
              if (playerController.allSongs.isEmpty) {
                return const Text('No Songs available');
              } else {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Number of columns
                    crossAxisSpacing: 8.h, // Horizontal spacing between items
                    mainAxisSpacing: 10.0, // Vertical spacing between items
                    childAspectRatio: 0.58, // Aspect ratio of each item
                  ),
                  itemCount: playerController.recentSongs.length > 20
                      ? 20
                      : playerController.recentSongs.length,
                  itemBuilder: (context, index) {
                    // sor the sond according to their date of Modification
                    List<ExtendedSongModel> popularSongs =
                        playerController.recentSongs;

                    // Get the song at the current index
                    ExtendedSongModel popularSong = popularSongs[index];
                    return GestureDetector(
                      onTap: () async {
                        playerController.playList.value = popularSongs;
                        playerController.currentIndex.value = index;
                        playerController.playingSong.value = popularSong;
                        playerController.playSong(
                            playerController.playingSong.value?.uri!,
                            playerController.currentIndex.value);
                        Get.to(() => MusicPlayer());
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 187.h,
                            width: 120.h,
                            child: QueryArtworkWidget(
                              artworkBorder: BorderRadius.circular(22.h),
                              id: popularSong.id,
                              type: ArtworkType.AUDIO,
                              artworkFit: BoxFit.cover,
                              nullArtworkWidget: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: Image.asset(
                                  'assets/images/headphones.jpg', // Path to your asset image
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getCustomFont(popularSong.title!, 10.sp,
                                          textColor, 1,
                                          fontWeight: FontWeight.w700),
                                      getVerSpace(1.h),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: getCustomFont(
                                          popularSong.artist!,
                                          8.sp,
                                          Colors.white,
                                          1,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          )
                        ],
                      ).paddingSymmetric(horizontal: 8.h),
                    );
                  },
                );
              }
            },
          ),
        )
      ],
    );
  }
}
