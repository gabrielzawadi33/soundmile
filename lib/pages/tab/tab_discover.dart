
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:get/genstant.dart';
// import 'package:get/get.dart';

// import '../../../util/constant_widget.dart';

// class TabDiscover extends StatefulWidget {
//   const TabDiscover({Key? key}) : super(key: key);

//   @override
//   State<TabDiscover> createState() => _TabDiscoverState();
// }

// class _TabDiscoverState extends State<TabDiscover> {
//   TextEditingController searchController = TextEditingController();
//   List<ModelRelease> releaseLists = DataFile.releaseList;
//   List<String> recommendedLists = DataFile.recommendedList;
//   List<String> trendingMusicLists = DataFile.trendingMusicList;
//   final CategoryController categoryController = Get.put(CategoryController());
//   final SongController songController = Get.put(SongController());

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         getVerSpace(30.h),
//         buildSearchWidget(context),
//         getVerSpace(30.h),
//         Expanded(
//             flex: 1,
//             child: ListView(
//               primary: true,
//               shrinkWrap: false,
//               children: [
//                 buildCategoriesList(),
//                 getVerSpace(30.h),
//                 // buildRecommendedList(),
//                 // getVerSpace(30.h),
//                 buildTrendingList(),
//                 getVerSpace(46.h)
//               ],
//             ))
//       ],
//     );
//   }

//   Column buildTrendingList() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             getCustomFont('Trending Music', 18.sp, Colors.white, 1,
//                 fontWeight: FontWeight.w700),
//             GestureDetector(
//               onTap: () {
//                 Constant.sendToNext(context, Routes.trendingListRoute,
//                     arguments: SongController);
//               },
//               child: getCustomFont("View All", 12.sp, accentColor, 1,
//                   fontWeight: FontWeight.w700),
//             )
//           ],
//         ).paddingSymmetric(horizontal: 20.h),
//         getVerSpace(20.h),
//         SizedBox(
//           height: 500.h,
//           child: Obx(() {
//             if (songController.isLoading.value) {
//               return Center(child: CircularProgressIndicator());
//             } else if (songController.songList.isEmpty) {
//               return Center(child: Text('No data available'));
//             } else {
//               return ListView.builder(
//                 primary: false,
//                 shrinkWrap: true,
//                 itemCount: songController.trendingSongs.length,
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (context, index) {
//                   Song song = songController.trendingSongs[index];
//                   final list = songController.trendingSongs;
//                   return GestureDetector(
//                     onTap: () {
//                       Constant.sendToNext(
//                         context,
//                         Routes.musicDetailRoute,
//                         arguments: {
//                           'songs': list,
//                           'currentIndex': index,
//                         },
//                       );
//                     },
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: 120.h,
//                           height: 150.h,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(22.h),
//                             color: hintColor,
//                             image: song.photo != null
//                                 ? DecorationImage(
//                                     image: NetworkImage(song.photo!),
//                                     fit: BoxFit.fill,
//                                   )
//                                 : null,
//                           ),
//                           child: song.photo == null
//                               ? Center(
//                                   child: Icon(
//                                     Icons.person, // Use any icon you prefer
//                                     size: 50.h,
//                                   ),
//                                 )
//                               : null,
//                         ),
//                         getVerSpace(10.h),
//                         getCustomFont(song.title!, 10, Colors.white, 1)
//                       ],
//                     ).marginOnly(left: index == 0 ? 20.h : 0, right: 20.h),
//                   );
//                 },
//               );
//             }
//           }),
//         )
//       ],
//     );
//   }

//   Column buildRecommendedList() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             getCustomFont('Recommended', 18.sp, Colors.white, 1,
//                 fontWeight: FontWeight.w700),
//             GestureDetector(
//               onTap: () {
//                 Constant.sendToNext(context, Routes.recommendedListRoute);
//               },
//               child: getCustomFont("View All", 12.sp, accentColor, 1,
//                   fontWeight: FontWeight.w700),
//             )
//           ],
//         ).paddingSymmetric(horizontal: 20.h),
//         getVerSpace(20.h),
//         SizedBox(
//           height: 107.h,
//           child: ListView.builder(
//             primary: false,
//             shrinkWrap: true,
//             itemCount: recommendedLists.length,
//             scrollDirection: Axis.horizontal,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   Constant.sendToNext(context, Routes.musicDetailRoute);
//                 },
//                 child: Container(
//                   width: 111.h,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(22.h),
//                       image: DecorationImage(
//                           image: AssetImage(Constant.assetImagePath +
//                               recommendedLists[index]),
//                           fit: BoxFit.fill)),
//                 ).marginOnly(left: index == 0 ? 20.h : 0, right: 20.h),
//               );
//             },
//           ),
//         )
//       ],
//     );
//   }

//   Column buildCategoriesList() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             getCustomFont('Categories', 18.sp, Colors.white, 1,
//                 fontWeight: FontWeight.w700),
//             GestureDetector(
//               onTap: () {
//                 Constant.sendToNext(context, Routes.categoriesListRoute,
//                     arguments: categoryController);
//               },
//               child: getCustomFont("View All", 12.sp, accentColor, 1,
//                   fontWeight: FontWeight.w700),
//             )
//           ],
//         ).paddingSymmetric(horizontal: 20.h),
//         getVerSpace(20.h),
//         SizedBox(
//           height: 180.h,
//           child: Obx(
//             () {
//               if (categoryController.isLoading.value) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (categoryController.categoriesList.isEmpty) {
//                 return Center(child: Text('No data available'));
//               } else {
//                 return ListView.builder(
//                   itemCount: categoryController.categoriesList.length,
//                   scrollDirection: Axis.horizontal,
//                   primary: false,
//                   shrinkWrap: true,
//                   itemBuilder: (context, index) {
                 
//                     String image = 'categories.jpg';
//                     Categories category =
//                         categoryController.categoriesList[index];
//                     return GestureDetector(
//                       onTap: () async {
//                         var id = category.id;
//                         var categoryName = category.name;
//                         await categoryController.fetchCategorySongs(
//                             id!); // Just await the method without assigning
//                         List<Song> categorySongs =
//                             categoryController.categorySongList.toList();
//                         print(categorySongs);

//                         // ignore: use_build_context_synchronously
//                         Constant.sendToNext(
//                           context,
//                           Routes.songsList,
//                           arguments: {
//                             'songs': categorySongs,
//                             'artistName': categoryName,
//                           }, // Wrap artistSongs in a map
//                         );
//                       },
//                       child: Container(
//                         margin: EdgeInsets.only(
//                             left: index == 0 ? 20.h : 0, right: 20.h),
//                         width: 177.h,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               height: 117.h,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(22.h),
//                                   image: DecorationImage(
//                                       image: AssetImage(
//                                           Constant.assetImagePath + image),
//                                       fit: BoxFit.fill)),
//                             ),
//                             getVerSpace(10.h),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                               child: getCustomFont(
//                                   category.name!, 14.sp, Colors.white, 1,
//                                   fontWeight: FontWeight.w400),
//                             ),
//                             getVerSpace(2.h),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                               child: getCustomFont(
//                                   category.totalSongs.toString(),
//                                   12.sp,
//                                   searchHint,
//                                   1,
//                                   fontWeight: FontWeight.w400),
//                             )
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }
//             },
//           ),
//         )
//       ],
//     );
//   }

//   Widget buildSearchWidget(BuildContext context) {
//     return getSearchWidget(context, "Search anything...", searchController,
//             isEnable: true,
//             isprefix: true,
//             prefix: Row(
//               children: [
//                 getHorSpace(18.h),
//                 getSvgImage("search.svg", height: 24.h, width: 24.h),
//               ],
//             ),
//             constraint: BoxConstraints(maxHeight: 24.h, maxWidth: 55.h),
//             withSufix: true,
//             suffiximage: "filter.svg", imagefunction: () {
//       Get.bottomSheet(const FilterDialog(), isScrollControlled: true);
//     }, onTap: () {
//       // Constant.sendToNext(context, Routes.searchScreenRoute);
//     }, isReadonly: false)
//         .paddingSymmetric(horizontal: 20.h);
//   }
// }
