import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sound_mile/controllers/home_conroller.dart';
import 'package:sound_mile/controllers/player_controller.dart';
import 'package:sound_mile/model/extended_song_model.dart';
import 'package:sound_mile/pages/home_screen.dart';
import 'package:sound_mile/pages/playlist/playlist_tab.dart';

import '../../../model/release_model.dart';
import '../../../util/constant.dart';
import '../../controllers/Llibrary_controller.dart';
import '../../util/color_category.dart';
import '../../util/constant_widget.dart';
import '../play_list/playList_Songs.dart';

class TabLibrary extends StatefulWidget {
  const TabLibrary({Key? key}) : super(key: key);

  @override
  State<TabLibrary> createState() => _TabLibraryState();
}

class _TabLibraryState extends State<TabLibrary>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void backClick() {
    final homeController = Get.find<HomeController>();
    homeController.index.value = 0; // Navigates back to TabHome
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getVerSpace(30.h),
        SizedBox(
          height: 51.h,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              getHorSpace(10.h),
              getCustomFont(
                'My Library',
                20.sp,
                textColor,
                1,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w700,
              ),
            ],
          ).paddingSymmetric(horizontal: 10),
        ),
        TabBar(
          controller: _tabController,
          tabs: [
            Container(child: Tab(text: 'Recent')),
            Tab(text: 'Artist'),
            Tab(text: 'Albums'),
            Tab(text: 'PlayList'),
          ],
          labelColor: secondaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: secondaryColor,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              buildLibraryList(), // Replace with your Recent tab content
              buildArtistList(), // Replace with your Artist tab content
              buildAlbumList(), // Replace with your Albums tab content
              const PlaylistScreen(),
            ],
          ),
        ),
        getVerSpace(40.h)
      ],
    );
  }

  Expanded buildLibraryList() {
    return Expanded(
        flex: 1,
        child: GetBuilder<LibraryController>(
          init: LibraryController(),
          builder: (controller) => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            primary: true,
            shrinkWrap: false,
            itemCount: controller.libraryLists.length,
            itemBuilder: (context, index) {
              ModelRelease modelRelease = controller.libraryLists[index];

              return GestureDetector(
                onTap: () {},
                child: Container(
                  height: 60,
                  padding: EdgeInsets.all(12.h),
                  decoration: BoxDecoration(
                      color: containerBg,
                      borderRadius: BorderRadius.circular(22.h)),
                  child: Row(
                    children: [
                      getSvgImage(modelRelease.image,
                          width: 30.h, height: 30.h),
                      getHorSpace(12.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getCustomFont(
                                modelRelease.name, 16.sp, Colors.white, 1,
                                fontWeight: FontWeight.w700),
                            getVerSpace(6.h),
                          ],
                        ),
                      ),
                      GestureDetector(
                          onTap: () {},
                          child: getSvgImage("more.svg",
                              height: 24.h, width: 24.h))
                    ],
                  ),
                ).marginOnly(bottom: 20.h),
              );
            },
          ),
        ));
  }

  Expanded buildArtistList() {
    PlayerController playerController = PlayerController();
    return Expanded(
      flex: 1,
      child: GetBuilder<LibraryController>(
        init: LibraryController(),
        builder: (controller) {
          // Group songs by artist
          Map<String, List<ExtendedSongModel>> artistMap = {};
          for (var song in playerController.allSongs) {
            String artist = song.artist ?? 'Unknown';
            if (!artistMap.containsKey(artist)) {
              artistMap[artist] = [];
            }
            artistMap[artist]!.add(song);
          }

          // Create a list of widgets for each artist and their songs
          List<Widget> artistWidgets = [];
          artistMap.forEach((artist, releases) {
            artistWidgets.add(
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaylistSongs(
                        title: artist,
                        songs: releases,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30.h,
                        child: FutureBuilder<Uint8List?>(
                          future: getArtwork(releases.first.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10.h),
                                child: Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              );
                            } else {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10.h),
                                child: Image.asset(
                                  'assets/images/headphones.png', // Path to your asset image
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      getHorSpace(12.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getCustomFont(artist, 12.sp, Colors.white, 1,
                                fontWeight: FontWeight.w700),
                            getVerSpace(6.h),
                            getCustomFont('${releases.length} songs', 10.sp,
                                Colors.grey, 1),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            children: artistWidgets,
          );
        },
      ),
    );
  }

  Expanded buildAlbumList() {
    PlayerController playerController = PlayerController();
    return Expanded(
      flex: 1,
      child: GetBuilder<LibraryController>(
        init: LibraryController(),
        builder: (controller) {
          // Group songs by album using album
          Map<String, List<ExtendedSongModel>> albumMap = {};
          for (var song in playerController.allSongs) {
            if (!albumMap.containsKey(song.album)) {
              albumMap[song.album!] = [];
            }
            albumMap[song.album]!.add(song);
          }

          // Sort the albums by album name
          var sortedAlbums = albumMap.keys.toList()..sort();

          // Create a list of widgets for each album and their songs
          List<Widget> albumWidgets = [];
          for (var album in sortedAlbums) {
            List<ExtendedSongModel> releases = albumMap[album]!;
            String albumName = album ?? 'Unknown';

            albumWidgets.add(
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaylistSongs(
                        title: albumName,
                        songs: releases,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(10.h),
                  child: Column(
                    children: [
                      Expanded(
                        child: FutureBuilder<Uint8List?>(
                          future: getArtwork(releases.first.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10.h),
                                child: Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              );
                            } else {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10.h),
                                child: Image.asset(
                                  'assets/images/headphones.png', // Path to your asset image
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getCustomFont(albumName, 1.sp, Colors.white, 1,
                                fontWeight: FontWeight.w700),
                            getVerSpace(1.h),
                            getCustomFont('${releases.length} songs', 10.sp,
                                Colors.grey, 1),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            children: albumWidgets,
            childAspectRatio: 0.8, // Ensures the grid items are square
          );
        },
      ),
    );
  }
}
