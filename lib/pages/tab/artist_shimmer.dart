import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../util/color_category.dart';
import '../../../util/constant_widget.dart';

class ShimmerArtistList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      scrollDirection: Axis.horizontal,
      primary: false,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: hintColor,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.only(
              left: 20.w,
              top: 20.h,
            ),
            height: 207.h,
            width: 107.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.h),
              color: Colors.grey[300],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 107.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.h),
                    color: Colors.grey[300],
                  ),
                ),
                getVerSpace(5.h),
                Center(
                  child: Container(
                    width: 80.w,
                    height: 10.h,
                    color: Colors.grey[300],
                  ),
                ),
                getVerSpace(2.h),
                Center(
                  child: Container(
                    width: 60.w,
                    height: 8.h,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}