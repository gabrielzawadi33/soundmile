import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/audio_controller.dart';
import '../controllers/home_conroller.dart';
import '../model/bottom_model.dart';
import '../util/color_category.dart';
import '../util/constant.dart';
import '../util/constant_widget.dart';
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

  // void backClick() {
  //   Constant.closeApp();
  // }

  @override
  void initState() {
    super.initState();
    // print(userControroller.user.value);
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

  buildBottomnavigation(
      HomeController controller, SongController audioController) {
    return Obx(
      () {
        return SizedBox(
          // height: (audioController.isPlaying.value) ? 120.h : 60.h,
          height: 160.h,
          child: Stack(
            children: [
              // if (audioController
              //     .isPlaying.value) // Show only if isPlaying is true
              //   Positioned(
              //     top: 0.h,
              //     left: 0,
              //     right: 0,
              //     child: Container(
              //       decoration: BoxDecoration(
              //         color: accentColor.withOpacity(0.1)
              //             .withOpacity(0.8), // Adjusted color and opacity
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.black.withOpacity(0.1),
              //             offset: const Offset(0, -1),
              //             blurRadius: 10,
              //           ),
              //         ],
              //       ),
              //       child: ListTile(
              //         onTap: () {
              //           Constant.sendToNext(
              //             context,
              //             Routes.musicDetailRoute,
              //             arguments: {
              //               'songs': songController.popularSongs,
              //               'currentIndex': audioController.currentIndex.value,
              //             },
              //           );
              //         },
              //         leading: Container(
              //           height: 46.h,
              //           width: 46.h,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(12.h),
              //             image: DecorationImage(
              //                 image: NetworkImage(
              //                     audioController.playingSong.value?.photo ??
              //                         ''),
              //                 fit: BoxFit.fill),
              //           ),
              //         ),
              //         title: Text(
              //           audioController.playingSong.value?.artistName ??
              //               'Unknown',
              //           style: const TextStyle(
              //               fontSize: 10,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.white),
              //         ),
              //         subtitle: Text(
              //             audioController.playingSong.value?.title ?? 'Unknown',
              //             style: TextStyle(fontSize: 12, color: Colors.white)),
              //         trailing: IconButton(
              //           icon: Icon(Icons.play_arrow, color: Colors.white),
              //           onPressed: () {
              //             audioController.togglePlayPause();
              //           },
              //         ),
              //       ),
              //     ),
              //   ),
              Positioned(
                bottom: 0.h,
                left: 0,
                right: 0,
                child: Container(
                  height: 60.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black, // Adjusted color
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, -1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(bottomLists.length, (index) {
                      ModelBottom modelBottom = bottomLists[index];
                      return GestureDetector(
                        onTap: () {
                          controller.onChange(index.obs);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              controller.index.value == index
                                  ? modelBottom.selectImage
                                  : modelBottom.image,
                              size: 24.h,
                              color: controller.index.value == index
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            Visibility(
                              visible: controller.index.value == index,
                              child: getCustomFont(
                                modelBottom.title,
                                12.sp,
                                accentColor,
                                1,
                                fontWeight: FontWeight.w700,
                                txtHeight: 1.5.h,
                              ),
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
      },
    );
  }
}
