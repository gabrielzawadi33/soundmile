import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sound_mile/controllers/player_controller.dart';
import 'package:sound_mile/pages/search/search_screen.dart';
import 'package:sound_mile/pages/tab/tab_library.dart';

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
    Key? key,
  }) : super(key: key);
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

  int selectedIndex = 0;

  void backClick() {
    Constant.backToPrev(context);
  }

  // List of widget options for each tab
  static final List<Widget> _widgetOptions = <Widget>[
    const TabHome(),
    const SearchScreen(),
    const TabLibrary(),
  ];

  // Update selected tab
  void _onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(bgDark);
    Constant.setupSize(context);

    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex != 0) {
          // If not on TabHome, navigate back to it
          setState(() {
            selectedIndex = 0;
          });
          return false; // Prevent closing the app
        } else {
          // If already on TabHome, exit the app
          SystemNavigator.pop();
          return false;
        }
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: bgDark,
          bottomNavigationBar: buildBottomNavigation(),
          body: SafeArea(
            child: _widgetOptions[selectedIndex],
          ),
        ),
      ),
    );
  }

  // Bottom Tab Navigation Bar
  buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent, // Set container to be fully transparent
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -1),
            blurRadius: 10,
          ),
        ],
      ),
      height: (homeController.isShowPlayingSong.value) ? 130.h : 61.h,
      child: Stack(
        children: [
          if (homeController.isShowPlayingSong.value)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Get.to(
                    MusicPlayer(),
                    transition: Transition.downToUp,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: secondaryColor,
                      width: 0.3.w,
                    ),
                  ),
                  color: accentColor,
                  child: Row(
                    children: [
                      Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.horizontal,
                        confirmDismiss: (direction) async {
                          bool isNext = direction == DismissDirection.endToStart;
                          bool noNext = !playerController.audioPlayer.hasNext &&
                              playerController.loopMode.value == LoopMode.one;
                          bool noPrevious = !playerController.audioPlayer.hasPrevious;

                          if ((isNext && noNext) || (!isNext && noPrevious)) {
                            showToast('Repeat', context);
                            playerController.audioPlayer.seek(Duration.zero);
                            playerController.audioPlayer.play();
                            return false;
                          }

                          isNext
                              ? playerController.playNextSong()
                              : playerController.playPreviousSong();
                        },
                        background: Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Icon(
                              (playerController.audioPlayer.hasNext &&
                                      playerController.loopMode.value != LoopMode.one)
                                  ? Icons.arrow_back
                                  : Icons.loop,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        secondaryBackground: Container(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Icon(
                              (playerController.audioPlayer.hasNext &&
                                      playerController.loopMode.value != LoopMode.one)
                                  ? Icons.arrow_forward
                                  : Icons.loop,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            getHorSpace(12.h),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              height: 50.h,
                              width: 50.w,
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
                                    'assets/images/headphones.png',
                                    fit: BoxFit.cover,
                                    height: 60.h,
                                    width: 60.w,
                                  ),
                                ),
                              ),
                            ),
                            getHorSpace(12.h),
                            SizedBox(
                              width: 270.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getCustomFont(
                                    playerController.playingSong.value?.title ?? '',
                                    10.sp,
                                    Colors.white,
                                    1,
                                    fontWeight: FontWeight.w700,
                                  ),
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
                          ],
                        ),
                      ),
                      Obx(
                        () => IconButton(
                          icon: Icon(
                            (playerController.isPlaying.value)
                                ? CupertinoIcons.pause_circle
                                : CupertinoIcons.play_circle,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            playerController.togglePlayPause();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          getHorSpace(5.h),
          Positioned(
            bottom: 0.h,
            left: 0,
            right: 0,
            child: Container(
              height: 65.h,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(bottomLists.length, (index) {
                  ModelBottom modelBottom = bottomLists[index];
                  return IconButton(
                    onPressed: () {
                      _onTabTapped(index);
                    },
                    icon: Column(
                      children: [
                        Icon(
                          selectedIndex == index
                              ? modelBottom.selectImage
                              : modelBottom.image,
                          size: 25.h,
                          color: selectedIndex == index
                              ? secondaryColor
                              : Colors.white,
                        ),
                        getCustomFont(
                          modelBottom.title,
                          10.sp,
                          selectedIndex == index
                              ? secondaryColor
                              : Colors.white,
                          1,
                          fontWeight: FontWeight.w700,
                          txtHeight: 1.5.h,
                        ),
                      ],
                    ),
                  );
                }),
              ).paddingSymmetric(horizontal: 30.h),
            ),
          ),
        ],
      ),
    );
  }
}
