import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../controllers/audio_controller.dart';
import '../../controllers/player_controller.dart';
import '../../util/color_category.dart';
import '../../util/constant.dart';
import '../../util/constant_widget.dart';
import '../player/music_player.dart';

class AllMusicPage extends StatefulWidget {
  const AllMusicPage({super.key});

  @override
  State<AllMusicPage> createState() => _AllMusicPageState();
}

class _AllMusicPageState extends State<AllMusicPage> {
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
            }, 'All Music'),
            Expanded(child: buildAllMusicList()),
          ],
        ),
      ),
    );
  }

  Column buildAllMusicList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getVerSpace(10.h),
        Expanded(
          child: Obx(
            () {
              if (playerController.allSongs.isEmpty) {
                return const Text('No Songs available');
              } else {
                return ListView.builder(
                  padding: EdgeInsets.only(right: 20.h, left: 6.h),
                  itemCount: playerController.allSongs.length,
                  itemBuilder: (context, index) {
                    SongModel song = playerController.allSongs[index];
                    return GestureDetector(
                      onTap: () async {
                        playerController.playList.value =
                            playerController.allSongs;
                        playerController.initialIndex.value = index;
                        playerController.playingSong.value =
                            playerController.allSongs[index];
                        playerController.playSong(
                            playerController.playingSong.value?.uri!,
                            playerController.initialIndex.value);
                        Get.to(() => MusicPlayer());
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22.h)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 60.h,
                              width: 60.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22.h),
                              ),
                              child: QueryArtworkWidget(
                                artworkBorder: BorderRadius.circular(22.h),
                                id: song.id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: ClipRRect(
                                  borderRadius: BorderRadius.circular(22.h),
                                  child: Image.asset(
                                    'assets/images/headphones.jpg', // Path to your asset imageA
                                    fit: BoxFit.cover,
                                    height: 60.h,
                                    width: 60.h,
                                  ),
                                ),
                              ),
                            ),
                            getHorSpace(12.h),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getCustomFont(song.title, 15.sp, textColor, 1,
                                      fontWeight: FontWeight.w700),
                                  getVerSpace(6.h),
                                  getCustomFont(
                                    "${song.artist}  ",
                                    10.sp,
                                    searchHint,
                                    1,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                            getHorSpace(12.h),
                            Icon(
                              Icons.play_arrow,
                              color: textColor,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}