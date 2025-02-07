import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../controllers/audio_controller.dart';
import '../../controllers/player_controller.dart';
import '../../model/extended_song_model.dart';
import '../../util/color_category.dart';
import '../../util/constant.dart';
import '../../util/constant_widget.dart';
import '../player/music_player.dart';

class AllRecentMusicPage extends StatefulWidget {
  const AllRecentMusicPage({super.key});

  @override
  State<AllRecentMusicPage> createState() => _AllRecentMusicPageState();
}

class _AllRecentMusicPageState extends State<AllRecentMusicPage> {
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
        bottomNavigationBar: buildBottomMusicBar(),
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
                    List<ExtendedSongModel> recentSongs =
                        playerController.recentSongs;

                    // Get the song at the current index
                    ExtendedSongModel recentSong = recentSongs[index];
                    return GestureDetector(
                      onTap: () async {
                        playerController.setPlaylistAndPlaySong(recentSongs, index);
                       
                        Get.to(() => MusicPlayer());
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.h),
                              color: secondaryColor,
                            ),
                            height: 187.h,
                            width: 120.w,
                            child: buildRecentImage(context, recentSong.id)
                          ),
                          Positioned(
                              bottom: 2,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 100.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        getCustomFont(recentSong.title, 10.sp,
                                            textColor, 1,
                                            fontWeight: FontWeight.w700),
                                        getVerSpace(1.h),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: getCustomFont(
                                            recentSong.artist!,
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
                              ))
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
