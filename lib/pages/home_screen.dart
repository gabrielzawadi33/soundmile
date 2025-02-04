import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sound_mile/controllers/player_controller.dart';

import '../controllers/audio_controller.dart';
import '../controllers/home_conroller.dart';
import '../model/bottom_model.dart';
import '../util/color_category.dart';
import '../util/constant.dart';
import '../util/constant_widget.dart';
import 'player/music_player.dart';
import 'tab/tab_home.dart';
import '../dataFile/data_file.dart';

class HomeScreen extends StatefulWidget {
  // final User? user;
  HomeScreen({
    // void backClick() {
    //   Constant.closeApp();
    // }
    super.key,
  });
  final user = Get.arguments;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ModelBottom> bottomLists = DataFile.bottomList;
  SongController audioController = Get.put(SongController());
  PlayerController playerController = Get.put(PlayerController());
  HomeController homeController = Get.put(HomeController());
  bool isShowPlaying = true;

  // void backClick() {
  //   Constant.closeApp();
  // }

  @override
  void initState() {
    super.initState();
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const TabHome(),
    // const TabDiscover(),
    // const TabLibrary(),
    // const TabProfile()
  ];

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(bgDark);
    Constant.setupSize(context);
    return WillPopScope(
      onWillPop: () async {
        // backClick();
        return false;
      },
      child: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) => Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: bgDark,
          bottomNavigationBar:
              buildBottomnavigation(controller, audioController),
          body: SafeArea(
            child: GetX<HomeController>(
              init: HomeController(),
              builder: (controller) => _widgetOptions[controller.index.value],
            ),
          ),
        ),
      ),
    );
  }

// bottom  Nav Bar
  buildBottomnavigation(
      HomeController controller, SongController audioController) {
    return Obx(
      () {
        return SizedBox(
          height: (homeController.isShowPlayingSong.value )
              ? 60.h
              : 0.h,
          child: Stack(
            children: [
              if (homeController.isShowPlayingSong.value)
                Positioned(
                  top: 0.h,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        MusicPlayer(),
                        transition: Transition.downToUp,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(6.h),
                      margin: EdgeInsets.only(bottom: 10.h),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.75),
                        // borderRadius: BorderRadius.circular(22.h),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          getHorSpace(12.h),
                          Container(
                            height: 50.h,
                            width: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11.h),
                            ),
                            child: QueryArtworkWidget(
                              artworkBorder: BorderRadius.circular(22.h),
                              id: playerController.playingSong.value?.id ?? 0,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: ClipRRect(
                                borderRadius: BorderRadius.circular(22.h),
                                child: Image.asset(
                                  'assets/images/headphones.png', // Path to your asset imageA
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
                                getCustomFont(
                                    playerController.playingSong.value?.title ??
                                        '',
                                    10.sp,
                                    Colors.white,
                                    1,
                                    fontWeight: FontWeight.w700),
                                getVerSpace(6.h),
                                getCustomFont(
                                  "${playerController.playingSong.value?.artist ?? ''}  ",
                                  8.sp,
                                  searchHint,
                                  1,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                          getHorSpace(12.h),
                          // SizedBox(width: 20.h),

                          Obx(() => IconButton(
                                icon: Icon(
                                  playerController.isPlaying.value
                                      ? CupertinoIcons.pause
                                      : CupertinoIcons.play_arrow,
                                  // size: 72.h,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  await playerController.togglePlayPause();
                                },
                              )),
                          IconButton(
                              onPressed: () {
                                homeController.setIsShowPlayingData(false);
                              },
                              icon: Icon(CupertinoIcons.clear,
                                  color: Colors.white, size: 18)),
                          getHorSpace(5.h),
                        ],
                      ),
                    ),
                  ),
                ),

              //   //Bottom Tab BAr
              // Positioned(
              //   bottom: 0.h,
              //   left: 0,
              //   right: 0,
              //   child: Container(
              //     height: 60.h,
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       color: Colors.black, // Adjusted color
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black.withOpacity(0.1),
              //           offset: const Offset(0, -1),
              //           blurRadius: 10,
              //         ),
              //       ],
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: List.generate(bottomLists.length, (index) {
              //         ModelBottom modelBottom = bottomLists[index];
              //         return GestureDetector(
              //           onTap: () {
              //             controller.onChange(index.obs);
              //           },
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Icon(
              //                 controller.index.value == index
              //                     ? modelBottom.selectImage
              //                     : modelBottom.image,
              //                 size: 24.h,
              //                 color: controller.index.value == index
              //                     ? Colors.blue
              //                     : Colors.grey,
              //               ),
              //               Visibility(
              //                 visible: controller.index.value == index,
              //                 child: getCustomFont(
              //                   modelBottom.title,
              //                   12.sp,
              //                   accentColor,
              //                   1,
              //                   fontWeight: FontWeight.w700,
              //                   txtHeight: 1.5.h,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         );
              //       }),
              //     ).paddingSymmetric(horizontal: 30.h),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
