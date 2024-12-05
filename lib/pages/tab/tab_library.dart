// import 'package:bosco/controller/controller.dart';
// import 'package:bosco/dialog/library_dialog.dart';
// import 'package:bosco/util/color_category.dart';
// import 'package:bosco/util/constant_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../../../model/release_model.dart';
// import '../../../routes/app_routes.dart';
// import '../../../util/constant.dart';

// class TabLibrary extends StatefulWidget {
//   const TabLibrary({Key? key}) : super(key: key);

//   @override
//   State<TabLibrary> createState() => _TabLibraryState();
// }

// class _TabLibraryState extends State<TabLibrary> {
//   void backClick() {
//     Constant.closeApp();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         getVerSpace(30.h),
//         getAppBar(() {
//           backClick();
//         }, "My Library")
//             .paddingSymmetric(horizontal: 20.h),
//         getVerSpace(30.h),
//         buildLibraryList(),

//         // buildAddStoriesButton(context),

//         // buildAddStoriesButton(context),

//         getVerSpace(40.h)
//       ],
//     );
//   }

//   // Widget buildAddStoriesButton(BuildContext context) {
//   //   return getButton(context, accentColor, "Add More Stories", Colors.black,
//   //           () {}, 18.sp,
//   //           weight: FontWeight.w700,
//   //           borderRadius: BorderRadius.circular(12.h),
//   //           buttonHeight: 60.h)
//   //       .marginSymmetric(horizontal: 20.h);
//   // }

//   Expanded buildLibraryList() {
//     return Expanded(
//         flex: 1,
//         child: GetBuilder<LibraryController>(
//           init: LibraryController(),
//           builder: (controller) => ListView.builder(
//             padding: EdgeInsets.symmetric(horizontal: 20.h),
//             primary: true,
//             shrinkWrap: false,
//             itemCount: controller.libraryLists.length,
//             itemBuilder: (context, index) {
//               ModelRelease modelRelease = controller.libraryLists[index];

//               return GestureDetector(
//                 onTap: () {
//                   if (modelRelease.name == 'Playlists')
//                     Constant.sendToNext(context, Routes.playListOverview);
//                   else if (modelRelease.name == 'Favourite Music') {
//                     Constant.sendToNext(context, Routes.favouriteListRoute);
//                   } else if (modelRelease.name == 'Downloads') {
//                     Constant.sendToNext(context, Routes.downloadRoute);
//                   }
//                 },
//                 child: Container(
//                   height: 60,
//                   padding: EdgeInsets.all(12.h),
//                   decoration: BoxDecoration(
//                       color: containerBg,
//                       borderRadius: BorderRadius.circular(22.h)),
//                   child: Row(
//                     children: [
//                       getSvgImage(modelRelease.image,
//                           width: 30.h, height: 30.h),
//                       getHorSpace(12.h),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             getCustomFont(
//                                 modelRelease.name, 16.sp, Colors.white, 1,
//                                 fontWeight: FontWeight.w700),
//                             getVerSpace(6.h),
//                           ],
//                         ),
//                       ),
//                       GestureDetector(
//                           onTap: () {
//                             Get.bottomSheet(LibraryDialog(index),
//                                 isScrollControlled: true);
//                           },
//                           child: getSvgImage("more.svg",
//                               height: 24.h, width: 24.h))
//                     ],
//                   ),
//                 ).marginOnly(bottom: 20.h),
//               );
//             },
//           ),
//         ));
//   }
// }
