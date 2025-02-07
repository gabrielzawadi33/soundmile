import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../util/color_category.dart';
import '../../../util/constant_widget.dart';

class ShimmerListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
    Shimmer.fromColors(
    baseColor: containerBg,
    highlightColor: hintColor,
    child: Container(
      padding: EdgeInsets.all(12.h),
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
          color: containerBg,
          borderRadius: BorderRadius.circular(22.h)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 76.h,
            width: 76.w,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(22.h),
            ),
          ),
          getHorSpace(12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16.h,
                  width: double.infinity,
                  color: Colors.grey,
                ),
                getVerSpace(6.h),
                Container(
                  height: 12.h,
                  width: 150.w,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          Container(
            height: 34.h,
            width: 34.w,
            color: Colors.grey,
          ),
        ],
      ),
    ),
  );
    // Shimmer.fromColors(
    //   baseColor: Colors.grey[300]!,
    //   highlightColor: Colors.grey[100]!,
    //   child: ListView.builder(
    //     padding: EdgeInsets.symmetric(horizontal: 20.h),
    //     primary: false,
    //     shrinkWrap: true,
    //     itemCount: 2, // Number of shimmer items
    //     itemBuilder: (context, index) {
    //       return Container(
    //         padding: EdgeInsets.all(12.h),
    //         margin: EdgeInsets.only(bottom: 20.h),
    //         decoration: BoxDecoration(
    //           color: Colors.grey[300],
    //           borderRadius: BorderRadius.circular(22.h),
    //         ),
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Shimmer.fromColors(
    //               baseColor: Colors.grey[300]!,
    //               highlightColor: Colors.grey[100]!,
    //               child: Container(
    //                 height: 76.h,
    //                 width: 76.h,
    //                 decoration: BoxDecoration(
    //                   color: Colors.grey[300],
    //                   borderRadius: BorderRadius.circular(22.h),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(width: 12.h),
    //             Expanded(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Shimmer.fromColors(
    //                     baseColor: Colors.grey[300]!,
    //                     highlightColor: Colors.grey[100]!,
    //                     child: Container(
    //                       width: double.infinity,
    //                       height: 16.sp,
    //                       color: Colors.grey[300],
    //                     ),
    //                   ),
    //                   SizedBox(height: 6.h),
    //                   Shimmer.fromColors(
    //                     baseColor: Colors.grey[300]!,
    //                     highlightColor: Colors.grey[100]!,
    //                     child: Container(
    //                       width: double.infinity,
    //                       height: 12.sp,
    //                       color: Colors.grey[300],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             SizedBox(width: 12.h),
    //             Shimmer.fromColors(
    //               baseColor: Colors.grey[300]!,
    //               highlightColor: Colors.grey[100]!,
    //               child: Container(
    //                 height: 34.h,
    //                 width: 34.h,
    //                 color: Colors.grey[300],
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}