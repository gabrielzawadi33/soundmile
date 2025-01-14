import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:bosco/controller/controller.dart';
import 'package:bosco/dataFile/data_file.dart';
import 'package:bosco/util/color_category.dart';
import 'package:bosco/util/constant_widget.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({Key? key}) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<String> timeLists = DataFile.timeList;
  FilterController controller = Get.put(FilterController());
  List<String> subjectLists = DataFile.subjectList;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          decoration: BoxDecoration(
              color: lightBg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22.h))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getVerSpace(20.h),
              buildHeader(),
              getVerSpace(30.h),
              buildTimeList(),
              getVerSpace(10.h),
              buildSubjectList(),
              getVerSpace(30.h),
              buildButtonWidget(context),
              getVerSpace(22.h),
            ],
          ),
        )
      ],
    );
  }

  Row buildButtonWidget(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: getButton(context, lightBg, "Reset", accentColor, () {
          controller.selectChange(0);
          controller.subjectSelect(0);
        }, 18.sp,
                weight: FontWeight.w700,
                borderRadius: BorderRadius.circular(12.h),
                buttonHeight: 60.h,
                borderColor: accentColor,
                isBorder: true,
                borderWidth: 1.h)),
        getHorSpace(20.h),
        Expanded(
            child: getButton(context, accentColor, "Apply", Colors.black, () {
          Get.back();
        }, 18.sp,
                weight: FontWeight.w700,
                borderRadius: BorderRadius.circular(12.h),
                buttonHeight: 60.h))
      ],
    );
  }

  Column buildSubjectList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getCustomFont("Subjects ", 18.sp, Colors.white, 1,
            fontWeight: FontWeight.w700),
        getVerSpace(20.h),
        GetBuilder<FilterController>(
          init: FilterController(),
          builder: (controller) => Wrap(
            alignment: WrapAlignment.start,
            children: [
              for (final i
                  in List.generate(subjectLists.length, (index) => index))
                Wrap(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.subjectChange(i);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 11.h, horizontal: 30.h),
                        decoration: BoxDecoration(
                            color: dividerColor,
                            borderRadius: BorderRadius.circular(12.h),
                            // ignore: unrelated_type_equality_checks
                            border: controller.subjectSelect == i
                                ? Border.all(color: accentColor, width: 1.h)
                                : null),
                        child: getCustomFont(
                            subjectLists[i],
                            18.sp,
                            controller.subjectSelect.value == i
                                ? accentColor
                                : Colors.white,
                            1,
                            fontWeight: FontWeight.w500),
                      ).marginOnly(right: 12.h, bottom: 20.h),
                    ),
                  ],
                )
            ],
          ),
        )
      ],
    );
  }

  Column buildTimeList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getCustomFont("Time ", 18.sp, Colors.white, 1,
            fontWeight: FontWeight.w700),
        getVerSpace(20.h),
        GetBuilder<FilterController>(
          init: FilterController(),
          builder: (controller) => Wrap(
            alignment: WrapAlignment.start,
            children: [
              for (final i in List.generate(timeLists.length, (index) => index))
                Wrap(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.selectChange(i);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 11.h, horizontal: 30.h),
                        decoration: BoxDecoration(
                            color: dividerColor,
                            borderRadius: BorderRadius.circular(12.h),
                            // ignore: unrelated_type_equality_checks
                            border: controller.select == i
                                ? Border.all(color: accentColor, width: 1.h)
                                : null),
                        child: getCustomFont(
                            timeLists[i],
                            18.sp,
                            controller.select.value == i
                                ? accentColor
                                : Colors.white,
                            1,
                            fontWeight: FontWeight.w500),
                      ).marginOnly(right: 12.h, bottom: 20.h),
                    ),
                  ],
                )
            ],
          ),
        )
      ],
    );
  }

  Column buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getCustomFont("Filter", 22.sp, Colors.white, 1,
                fontWeight: FontWeight.w700),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 30.h,
                width: 30.h,
                decoration: BoxDecoration(
                  color: dividerColor,
                  borderRadius: BorderRadius.circular(30.h),
                ),
                child: getSvgImage("close.svg").paddingAll(7.h),
              ),
            )
          ],
        ),
        getVerSpace(18.h),
        getDivider(setColor: dividerColor),
      ],
    );
  }
}