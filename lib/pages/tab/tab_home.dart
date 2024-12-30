import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sound_mile/controllers/audio_controller.dart';
import 'package:sound_mile/controllers/player_controller.dart';
import 'package:sound_mile/model/extended_song_model.dart';
import 'package:sound_mile/pages/player/music_player.dart';

import '../../controllers/home_conroller.dart';
import '../../util/color_category.dart';
import '../../util/constant_widget.dart';

class TabHome extends StatefulWidget {
  const TabHome({
    Key? key,
  });

  @override
  State<TabHome> createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> {
  TextEditingController searchController = TextEditingController();
  HomeScreenController controller = Get.put(HomeScreenController());
  SongController songController = Get.find<SongController>();
  PlayerController playerController = Get.put(PlayerController());
  bool isGranted = false;

  @override
  void initState() {
    super.initState();
    // requestPermissions();
  }

  // // ignore: non_constant_identifier_names
  // Future<List<SongModel>> requestPermissions() async {
  //   PermissionStatus status = await Permission.storage.request();
  //   if (status.isGranted) {
  //     return songController.audioQuery.querySongs(
  //       ignoreCase: true,
  //       orderType: OrderType.ASC_OR_SMALLER,
  //       sortType: null,
  //       uriType: UriType.EXTERNAL,
  //     );
  //   } else {
  //     // Handle the case when permission is denied
  //     // You can show a dialog or a message to the user
  //     return [];
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getVerSpace(30.h),
        buildAppBar(),
        getVerSpace(30.h),
        buildSearchWidget(context),
        getVerSpace(30.h),
        Expanded(
          flex: 1,
          child: ListView(
            primary: true,
            shrinkWrap: false,
            children: [
              // buildSliderWidget(),
              getVerSpace(20.h),
              buildRecentMusicList(),
              getVerSpace(30.h),
              buildAllMusicList(),
              getVerSpace(10.h),
              // buildArtistList(),
              getVerSpace(40.h),
            ],
          ),
        )
        // : SizedBox(
        //     height: 100,
        //     child: Center(
        //       child: TextButton(
        //           onPressed: () {
        //             Permission.storage.request();
        //             setState(() {
        //               songController.isGranted.value = true;
        //             });
        //             print('permission granted');
        //           },
        //           child: const Text(
        //             'Request Permission',
        //             style: TextStyle(color: Colors.white),
        //           )),
        //     ),
        //   ),
      ],
    );
  }

  // Column buildArtistList() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           getCustomFont("Artists", 18.sp, Colors.white, 1,
  //               fontWeight: FontWeight.w700, txtHeight: 1.5.h),
  //           GestureDetector(
  //             onTap: () {
  //               // Constant.sendToNext(context, Routes.allArtistsPageRoute,
  //               //     arguments: artistController);
  //             },
  //             child: getCustomFont("View All", 12.sp, accentColor, 1,
  //                 fontWeight: FontWeight.w700),
  //           ),
  //         ],
  //       ).paddingSymmetric(horizontal: 20.h),
  //       getVerSpace(20.h),
  //       SizedBox(
  //         height: 181.h,
  //         child: Obx(() {
  //           if (artistController.isLoading.value) {
  //             return ShimmerArtistList();
  //           } else if (artistController.artistList.isEmpty) {
  //             return const Center(child: Text('No data available'));
  //           } else {
  //             return ListView.builder(
  //               itemCount: artistController.artistList.length,
  //               scrollDirection: Axis.horizontal,
  //               primary: false,
  //               shrinkWrap: true,
  //               itemBuilder: (context, index) {
  //                 Artist artist = artistController.artistList[index];

  //                 return GestureDetector(
  //                   onTap: () async {
  //                     artistController.isLoading.value = true;
  //                     await artistController.fetchArtistSongs(
  //                         context, artist.id!, artist.name!);
  //                     artistController.isLoading.value = false;
  //                   },
  //                   child: Container(
  //                     padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(25),
  //                       border: Border.all(
  //                         color: hintColor, // Set the border color
  //                         width: 1.0, // Set the border width
  //                       ),
  //                     ),
  //                     width: 120.h,
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Container(
  //                           height: 107.h,
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(22.h),
  //                             image: artist.profilePicture != null
  //                                 ? DecorationImage(
  //                                     image:
  //                                         NetworkImage(artist.profilePicture!),
  //                                     fit: BoxFit.fill,
  //                                   )
  //                                 : null,
  //                           ),
  //                           child: artist.profilePicture == null
  //                               ? Center(
  //                                   child: Icon(
  //                                     Icons.person, // Use any icon you prefer
  //                                     size: 50.h,
  //                                   ),
  //                                 )
  //                               : null,
  //                         ),
  //                         getVerSpace(5.h),
  //                         Center(
  //                           child: getCustomFont(
  //                               artist.name!, 10.sp, Colors.white, 2,
  //                               fontWeight: FontWeight.w400),
  //                         ),
  //                         getVerSpace(2.h),
  //                         Center(
  //                           child: getCustomFont(
  //                               '${artist.songcout.toString()} songs',
  //                               8.sp,
  //                               searchHint,
  //                               1,
  //                               fontWeight: FontWeight.w400),
  //                         ),
  //                       ],
  //                     ),
  //                   ).paddingOnly(left: index == 0 ? 20.h : 0, right: 20.h),
  //                 );
  //               },
  //             );
  //           }
  //         }),
  //       ),
  //     ],
  //   );
  // }

  Column buildAllMusicList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getCustomFont("All Music", 18.sp, textColor, 1,
                fontWeight: FontWeight.w700),
            GestureDetector(
              onTap: () {},
              child: getCustomFont("View All", 12.sp, textColor, 1,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ).paddingSymmetric(horizontal: 20.h),
        getVerSpace(20.h),
        Obx(
          () {
            if (playerController.allSongs.isEmpty) {
              return const Text('No Songs available');
            } else {
              // return ListView.builder(
              //   padding: EdgeInsets.symmetric(horizontal: 20.h),
              //   primary: false,
              //   shrinkWrap: true,
              //   itemCount:
              //       snapshot.data!.length > 40 ? 40 : snapshot.data!.length,
              //   itemBuilder: (context, index) {
              //     SongModel song = snapshot.data![index];

              //     List<SongModel> songs = snapshot.data!;
              //     playerController.songs.value = songs;
              //     playerController.currentIndex.value = 0;
              //     return GestureDetector(
              //       onTap: () {
              //         playerController.currentIndex.value = index;
              //         Get.to(
              //           () => MusicPlayer(songs: songs, index: index),
              //         );
              //       },
              return ListView.builder(
                padding: EdgeInsets.only(right: 20.h, left: 6.h),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                primary: false,
                itemCount: playerController.allSongs.length > 40
                    ? 40
                    : playerController.allSongs.length,
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
                      // Get.to(() => MusicPlayer());
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
      ],
    );
  }

  Column buildRecentMusicList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getCustomFont("Recently Added Music", 18.sp, textColor, 1,
                fontWeight: FontWeight.w700),
            GestureDetector(
              onTap: () {
                // Constant.sendToNext(context, Routes.popularMusicListRoute,
                //     arguments: songController);
              },
              child: getCustomFont("View All", 12.sp, textColor, 1,
                  fontWeight: FontWeight.w700),
            )
          ],
        ).paddingSymmetric(horizontal: 20.h),
        getVerSpace(20.h),
        SizedBox(
          height: 188.h,
          child: Obx(
            () {
              if (playerController.allSongs.isEmpty) {
                return const Text('No Songs available');
              } else {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
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
                        // Get.to(() => MusicPlayer());
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
                                      getCustomFont(popularSong.title!, 16.sp,
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
                                getSvgImage("video_circle.svg",
                                    height: 34.h, width: 34.h)
                              ],
                            ).paddingSymmetric(horizontal: 10.h),
                          )
                        ],
                      ).paddingOnly(left: index == 0 ? 20.h : 0, right: 10.h),
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
  // Column buildSliderWidget() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       CarouselSlider.builder(
  //           itemCount: homeSliderLists.length,
  //           itemBuilder:
  //               (BuildContext context, int itemIndex, int pageViewIndex) {
  //             ModelHomeSlider modelHome = homeSliderLists[itemIndex];
  //             return Container(
  //               height: 140.h,
  //               width: 374.w,
  //               decoration: BoxDecoration(
  //                   color: modelHome.color.toColor(),
  //                   borderRadius: BorderRadius.circular(22.h),
  //                   image: DecorationImage(
  //                       image: AssetImage(
  //                           Constant.assetImagePath + modelHome.image),
  //                       fit: BoxFit.fill)),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   modelHome.title == ""
  //                       ? Container()
  //                       : Column(
  //                           children: [
  //                             getCustomFont(
  //                                 modelHome.title, 20.sp, Colors.black, 1,
  //                                 fontWeight: FontWeight.w700,
  //                                 txtHeight: 1.5.h,
  //                                 textAlign: TextAlign.start),
  //                             getVerSpace(2.h),
  //                           ],
  //                         ),
  //                   getMultilineCustomFont(
  //                       modelHome.discription, 16.sp, Colors.black,
  //                       fontWeight: FontWeight.w400,
  //                       textAlign: TextAlign.start,
  //                       txtHeight: 1.5.h),
  //                   getVerSpace(12.h),
  //                   Row(
  //                     children: [
  //                       getCustomFont("Get Started ", 12.sp, Colors.black, 1,
  //                           fontWeight: FontWeight.w800,
  //                           decoration: TextDecoration.underline),
  //                       getHorSpace(6.h),
  //                       getSvgImage("arrow-right.svg",
  //                           width: 16.h, height: 16.h)
  //                     ],
  //                   )
  //                 ],
  //               ).paddingOnly(left: 190.w, right: 14.h),
  //             ).paddingOnly(right: 14.h);
  //           },
  //           options: CarouselOptions(
  //               height: 140.h,
  //               viewportFraction: 1.06.h,
  //               initialPage: 0,
  //               enableInfiniteScroll: true,
  //               scrollDirection: Axis.horizontal,
  //               onPageChanged: (index, reason) {
  //                 controller.indexChange(index.obs);
  //               })),
  //       getVerSpace(16.h),
  //       GetBuilder<HomeScreenController>(
  //         init: HomeScreenController(),
  //         builder: (controller) => Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: List.generate(
  //             homeSliderLists.length,
  //             (position) {
  //               return getSvgImage(
  //                       position == controller.index.value
  //                           ? "select_dot.svg"
  //                           : "unselect_dot.svg",
  //                       height: 7.h,
  //                       width: 7.h)
  //                   .paddingOnly(left: position == 0 ? 0 : 3.h, right: 3.h);
  //             },
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget buildSearchWidget(BuildContext context) {
    return getSearchWidget(context, "Search...", searchController,
            isEnable: false,
            isprefix: true,
            prefix: Row(
              children: [
                getHorSpace(18.h),
                getSvgImage("search.svg", height: 24.h, width: 24.h),
              ],
            ),
            constraint: BoxConstraints(maxHeight: 24.h, maxWidth: 55.h),
            withSufix: true,
            suffiximage: "filter.svg", imagefunction: () {
      // Get.bottomSheet(const FilterDialog(), isScrollControlled: true);
    }, onTap: () {
      // Constant.sendToNext(context, Routes.searchScreenRoute);
    }, isReadonly: true)
        .paddingSymmetric(horizontal: 20.h);
  }

  Widget buildAppBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getTwoRichText(
          "",
          accentColor,
          FontWeight.w700,
          22.sp,
          "Sound Mile",
          textColor,
          FontWeight.w700,
          22.sp,
        ),
        Icon(
          Icons.notifications_none,
          color: textColor,
        )

        // GestureDetector(
        //     onTap: () {
        //       // Constant.sendToNext(context, Routes.myProfileScreenRoute);
        //     },
        //     child:
        //         getAssetImage("profile_image.png", height: 50.h, width: 50.h))
      ],
    ).paddingSymmetric(horizontal: 20.h);
  }
}
