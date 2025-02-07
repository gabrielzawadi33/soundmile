import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../controllers/home_conroller.dart';
import '../controllers/player_controller.dart';
import '../pages/player/music_player.dart';
import 'color_category.dart';
import 'constant.dart';

final OnAudioQuery audioQuery = OnAudioQuery();
PlayerController playerController = Get.put(PlayerController());
HomeController homeController = Get.put(HomeController());

showToast(String s, BuildContext context) {
  if (s.isNotEmpty) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        // timeInSecForIosWeb: 1,

        backgroundColor: secondaryColor,
        textColor: textColor,
        fontSize: 12);

    // Toast.show(s, context,
    //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }
}

Widget getAssetImage(String image,
    {double? width,
    double? height,
    Color? color,
    BoxFit boxFit = BoxFit.contain}) {
  return Image.asset(
    Constant.assetImagePath + image,
    color: color,
    width: width,
    height: height,
    fit: boxFit,
  );
}

Widget buildRecentImage(BuildContext context, int id) {
  return FutureBuilder<Uint8List?>(
    future: getArtwork(id),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasData && snapshot.data != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Image.asset(
            'assets/images/headphones.png', // Path to your asset image

            height: double.infinity,
            width: double.infinity,
          ),
        );
      }
    },
  );
}

Widget buildMusicImage(BuildContext context, double? borderRadius) {
  PlayerController playerController = Get.put(PlayerController());

  return Obx(() {
    return FutureBuilder<Uint8List?>(
      future: getArtwork(playerController.playingSong.value?.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          return _buildDynamicImage(snapshot.data!, borderRadius);
        } else {
          return _buildPlaceholderImage(borderRadius);
        }
      },
    );
  });
}

Widget _buildDynamicImage(Uint8List imageData, double? borderRadius) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10.h),
        child: Image.memory(
          imageData,
          fit: _getBoxFit(
              imageData, constraints.maxWidth, constraints.maxHeight),
          height: double.infinity,
          width: double.infinity, 
        ),
      );
    },
  );
}

Widget _buildPlaceholderImage(double? borderRadius) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius ?? 0),
    child: Image.asset(
      'assets/images/headphones.png',
      fit: BoxFit.contain,
      height: double.infinity,
      width: double.infinity,
    ),
  );
}

BoxFit _getBoxFit(Uint8List imageData, double maxWidth, double maxHeight) {
  final image = Image.memory(imageData);

  BoxFit fit = BoxFit.cover; // Default BoxFit

  final Completer<BoxFit> completer = Completer<BoxFit>();

  image.image.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener((ImageInfo info, bool _) {
      double aspectRatio = info.image.width / info.image.height;

      if (aspectRatio > maxWidth / maxHeight) {
        fit = BoxFit.fitWidth;
      } else {
        fit = BoxFit.fitHeight;
      }
      completer.complete(fit);
    }),
  );

  return fit;
}

buildBottomMusicBar() {
  return Obx(
    () {
      return SizedBox(
        height: (homeController.isShowPlayingSong.value) ? 61.h : 0.h,
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
                        width: 0.3,
                      ),
                    ),
                    color: accentColor,
                    child: Row(
                      children: [
                        Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.horizontal,
                          confirmDismiss: (direction) async {
                            bool isNext =
                                direction == DismissDirection.endToStart;
                            bool noNext = !playerController
                                    .audioPlayer.hasNext &&
                                playerController.loopMode.value == LoopMode.one;
                            bool noPrevious =
                                !playerController.audioPlayer.hasPrevious;

                            if ((isNext && noNext) || (!isNext && noPrevious)) {
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
                                        playerController.loopMode.value !=
                                            LoopMode.one)
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
                                        playerController.loopMode.value !=
                                            LoopMode.one)
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
                                width: 50.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11.h),
                                ),
                                child: QueryArtworkWidget(
                                  artworkBorder: BorderRadius.circular(22.h),
                                  id: playerController.playingSong.value?.id ??
                                      0,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: ClipRRect(
                                    borderRadius: BorderRadius.circular(22.h),
                                    child: Image.asset(
                                      'assets/images/headphones.png',
                                      fit: BoxFit.cover,
                                      height: 60.h,
                                      width: 60.h,
                                    ),
                                  ),
                                ),
                              ),
                              getHorSpace(12.h),
                              SizedBox(
                                width: 270,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getCustomFont(
                                      playerController
                                              .playingSong.value?.title ??
                                          '',
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
          ],
        ),
      );
    },
  );
}

Future<Uint8List?> getArtwork(int? id) async {
  if (id == null) return null;
  return await audioQuery.queryArtwork(id, ArtworkType.AUDIO,
      size: 1000, quality: 100);
}

Widget getSvgImage(String image,
    {double? width,
    double? height,
    Color? color,
    BoxFit boxFit = BoxFit.contain}) {
  return SvgPicture.asset(
    Constant.assetImagePath + image,
    color: color,
    width: width,
    height: height,
    fit: boxFit,
  );
}

Widget getVerSpace(double verSpace) {
  return SizedBox(
    height: verSpace,
  );
}

Widget getHorSpace(double verSpace) {
  return SizedBox(
    width: verSpace,
  );
}

Widget getRichText(
    String firstText,
    Color firstColor,
    FontWeight firstWeight,
    double firstSize,
    String secondText,
    Color secondColor,
    FontWeight secondWeight,
    double secondSize,
    String thirdText,
    Color thirdColor,
    FontWeight thirdWeight,
    double thirdSize,
    {TextAlign textAlign = TextAlign.center,
    double? txtHeight}) {
  return RichText(
    textAlign: textAlign,
    text: TextSpan(
        text: firstText,
        style: TextStyle(
          color: firstColor,
          fontWeight: firstWeight,
          fontFamily: Constant.fontsFamily,
          fontSize: firstSize,
          height: txtHeight,
        ),
        children: [
          TextSpan(
              text: secondText,
              style: TextStyle(
                  color: secondColor,
                  fontWeight: secondWeight,
                  fontFamily: Constant.fontsFamily,
                  fontSize: secondSize,
                  height: txtHeight)),
          TextSpan(
              text: thirdText,
              style: TextStyle(
                color: thirdColor,
                fontWeight: thirdWeight,
                fontFamily: Constant.fontsFamily,
                fontSize: thirdSize,
                height: txtHeight,
              ))
        ]),
  );
}

Widget getSearchWidget(
    BuildContext context, String s, TextEditingController textEditingController,
    {bool withSufix = false,
    bool minLines = false,
    bool isPass = false,
    bool isEnable = true,
    bool isprefix = false,
    Widget? prefix,
    double? height,
    String? suffiximage,
    Function? imagefunction,
    List<TextInputFormatter>? inputFormatters,
    FormFieldValidator<String>? validator,
    BoxConstraints? constraint,
    ValueChanged<String>? onChanged,
    double vertical = 17,
    double horizontal = 20,
    int? length,
    String obscuringCharacter = '•',
    GestureTapCallback? onTap,
    bool isReadonly = false,
    ValueChanged<String>? onSubmit}) {
  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        height: 60.h,
        decoration: BoxDecoration(
            color: lightBg, borderRadius: BorderRadius.circular(22.h)),
        alignment: Alignment.centerLeft,
        child: CupertinoTextField(
          onSubmitted: onSubmit,
          readOnly: isReadonly,
          onTap: onTap,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          maxLines: (minLines) ? null : 1,
          controller: textEditingController,
          obscureText: isPass,
          cursorColor: accentColor,
          maxLength: length,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              fontFamily: Constant.fontsFamily),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.h), color: lightBg),
          padding: EdgeInsets.symmetric(
              vertical: vertical.h, horizontal: horizontal.h),
          suffix: withSufix == true
              ? GestureDetector(
                  onTap: () {
                    imagefunction!();
                  },
                  child: getSvgImage(suffiximage.toString(),
                          width: 24.h, height: 24.h)
                      .paddingOnly(right: 18.h))
              : null,
          prefix: isprefix == true ? prefix : null,
          placeholder: s,
          placeholderStyle: TextStyle(
              color: searchHint,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              fontFamily: Constant.fontsFamily),
        ),
      );
    },
  );
}

Widget getTwoRichText(
    String firstText,
    Color firstColor,
    FontWeight firstWeight,
    double firstSize,
    String secondText,
    Color secondColor,
    FontWeight secondWeight,
    double secondSize,
    {TextAlign textAlign = TextAlign.center,
    double? txtHeight,
    Function? function}) {
  return RichText(
    textAlign: textAlign,
    text: TextSpan(
        text: firstText,
        style: TextStyle(
          color: firstColor,
          fontWeight: firstWeight,
          fontFamily: Constant.fontsFamily,
          fontSize: firstSize,
          height: txtHeight,
        ),
        children: [
          TextSpan(
              text: secondText,
              style: TextStyle(
                  color: secondColor,
                  fontWeight: secondWeight,
                  fontFamily: Constant.fontsFamily,
                  fontSize: secondSize,
                  height: txtHeight),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  function!();
                }),
        ]),
  );
}

Widget getButton(BuildContext context, Color bgColor, String text,
    Color textColor, Function function, double fontsize,
    {bool isBorder = false,
    EdgeInsetsGeometry? insetsGeometry,
    borderColor = Colors.transparent,
    FontWeight weight = FontWeight.bold,
    bool isIcon = false,
    String? image,
    Color? imageColor,
    double? imageWidth,
    double? imageHeight,
    bool smallFont = false,
    double? buttonHeight,
    double? buttonWidth,
    List<BoxShadow> boxShadow = const [],
    EdgeInsetsGeometry? insetsGeometrypadding,
    BorderRadius? borderRadius,
    double? borderWidth}) {
  return InkWell(
    onTap: () {
      function();
    },
    child: Container(
      margin: insetsGeometry,
      padding: insetsGeometrypadding,
      width: buttonWidth,
      height: buttonHeight,
      decoration: getButtonDecoration(
        bgColor,
        borderRadius: borderRadius,
        shadow: boxShadow,
        border: (isBorder)
            ? Border.all(color: borderColor, width: borderWidth!)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (isIcon) ? getSvgImage(image!) : getHorSpace(0),
          (isIcon) ? getHorSpace(15.h) : getHorSpace(0),
          getCustomFont(text, fontsize, textColor, 1,
              textAlign: TextAlign.center,
              fontWeight: weight,
              fontFamily: Constant.fontsFamily)
        ],
      ),
    ),
  );
}

Widget getCustomFont(String text, double fontSize, Color fontColor, int maxLine,
    {String fontFamily = Constant.fontsFamily,
    TextOverflow overflow = TextOverflow.ellipsis,
    TextDecoration decoration = TextDecoration.none,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.start,
    txtHeight}) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        decoration: decoration,
        fontSize: fontSize,
        fontStyle: FontStyle.normal,
        color: fontColor,
        fontFamily: fontFamily,
        height: txtHeight,
        fontWeight: fontWeight),
    maxLines: maxLine,
    softWrap: true,
    textAlign: textAlign,
  );
}

BoxDecoration getButtonDecoration(Color bgColor,
    {BorderRadius? borderRadius,
    Border? border,
    List<BoxShadow> shadow = const [],
    DecorationImage? image}) {
  return BoxDecoration(
      color: bgColor,
      borderRadius: borderRadius,
      border: border,
      boxShadow: shadow,
      image: image);
}

Widget defaultTextField(
  BuildContext context,
  TextEditingController controller,
  String hint,
  IconData prefixIcon, {
  bool isPass = false,
  bool showPassword = false,
  VoidCallback? togglePasswordVisibility,
  FormFieldValidator<String>? validator,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  bool isEnable = true,
  bool isReadonly = false,
}) {
  return TextFormField(
    enabled: isEnable,
    readOnly: isReadonly,
    validator: validator,
    obscureText: isPass && !showPassword,
    controller: controller,
    style: TextStyle(
        color: hintColor, fontSize: 16.sp, fontWeight: FontWeight.w400),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          color: hintColor, fontSize: 16.sp, fontWeight: FontWeight.w400),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: dividerColor, width: 1.h),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: dividerColor, width: 1.h),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: accentColor, width: 1.h),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: errorColor, width: 1.h),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: errorColor, width: 1.h),
      ),
      errorStyle: TextStyle(
          color: errorColor, fontSize: 12.sp, fontWeight: FontWeight.w400),
      prefixIcon: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.h),
        child: Icon(
          prefixIcon,
          size: 24.h,
        ),
      ),
      prefixIconConstraints: BoxConstraints(maxHeight: 24.h, maxWidth: 60.h),
      filled: true,
      suffixIcon: isPass
          ? IconButton(
              icon: Icon(
                showPassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: togglePasswordVisibility,
            )
          : null,
    ),
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
  );
}

Widget getProfileTextField(
  BuildContext context,
  TextEditingController controller,
  String hint,
  String prefixImage, {
  bool isPass = false,
  FormFieldValidator<String>? validator,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  bool isEnable = true,
  bool isReadonly = false,
}) {
  return TextFormField(
    enabled: isEnable,
    readOnly: isReadonly,
    validator: validator,
    obscureText: isPass,
    controller: controller,
    style: TextStyle(
        color: isReadonly == true ? searchHint : Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          color: searchHint, fontSize: 16.sp, fontWeight: FontWeight.w400),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: dividerColor, width: 1.h),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: dividerColor, width: 1.h),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: accentColor, width: 1.h),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: errorColor, width: 1.h),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: errorColor, width: 1.h),
      ),
      errorStyle: TextStyle(
          color: errorColor, fontSize: 12.sp, fontWeight: FontWeight.w400),
      prefixIcon: getSvgImage(prefixImage, width: 24.h, height: 24.h)
          .paddingSymmetric(horizontal: 18.h),
      prefixIconConstraints: BoxConstraints(maxHeight: 24.h, maxWidth: 60.h),
      filled: true,
    ),
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
  );
}

// Widget getCountryTextFiled(BuildContext context,
//     TextEditingController controller, String hint, IconData prefixIcon,
//     {bool isPass = false, FormFieldValidator<String>? validator}) {
//   return TextFormField(
//     validator: validator,
//     obscureText: isPass,
//     controller: controller,
//     keyboardType: TextInputType.number,
//     inputFormatters: <TextInputFormatter>[
//       FilteringTextInputFormatter.digitsOnly
//     ],
//     style: TextStyle(
//         color: hintColor, fontSize: 16.sp, fontWeight: FontWeight.w400),
//     decoration: InputDecoration(
//       hintText: hint,
//       hintStyle: TextStyle(
//           color: hintColor, fontSize: 16.sp, fontWeight: FontWeight.w400),
//       border: UnderlineInputBorder(
//         borderSide: BorderSide(color: dividerColor, width: 1.h),
//       ),
//       enabledBorder: UnderlineInputBorder(
//         borderSide: BorderSide(color: dividerColor, width: 1.h),
//       ),
//       focusedBorder: UnderlineInputBorder(
//         borderSide: BorderSide(color: accentColor, width: 1.h),
//       ),
//       errorBorder: UnderlineInputBorder(
//         borderSide: BorderSide(color: errorColor, width: 1.h),
//       ),
//       focusedErrorBorder: UnderlineInputBorder(
//         borderSide: BorderSide(color: errorColor, width: 1.h),
//       ),
//       errorStyle: TextStyle(
//           color: errorColor, fontSize: 12.sp, fontWeight: FontWeight.w400),
//       prefixIcon: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(prefixIcon, size: 24.h).paddingOnly(right: 18.h),
//           Expanded(
//             child: CountryCodePicker(
//               onChanged: print,
//               initialSelection: 'TZ',
//               flagWidth: 24.h,
//               padding: EdgeInsets.zero,
//               textStyle: TextStyle(
//                   color: hintColor,
//                   fontSize: 11.sp,
//                   fontWeight: FontWeight.w400),
//               favorite: const ['+255', 'TZ'],
//               showCountryOnly: true,
//               showDropDownButton: true,
//               showOnlyCountryWhenClosed: false,
//               alignLeft: false,
//             ),
//           )
//         ],
//       ).paddingSymmetric(horizontal: 18.h),
//       prefixIconConstraints: BoxConstraints(maxHeight: 24.h, maxWidth: 160.h),
//       filled: true,
//     ),
//   );
// }

// Widget getCountryTextFiled(
//   BuildContext context,
//   TextEditingController controller,
//   String hint,
//   IconData prefixIcon, {
//   bool isPass = false,
//   FormFieldValidator<String>? validator,
//   required Function(CountryCode) onCountryChange,
//   required Function(String) onFieldSubmitted,
// }) {
//   return TextFormField(
//     validator: validator,
//     obscureText: isPass,
//     controller: controller,
//     keyboardType: TextInputType.number,
//     inputFormatters: <TextInputFormatter>[
//       FilteringTextInputFormatter.digitsOnly
//     ],
//     style: TextStyle(
//       color: Colors.grey,
//       fontSize: 16,
//       fontWeight: FontWeight.w400,
//     ),
//     decoration: InputDecoration(
//       hintText: hint,
//       hintStyle: TextStyle(
//         color: Colors.grey,
//         fontSize: 16,
//         fontWeight: FontWeight.w400,
//       ),
//       border: UnderlineInputBorder(
//         borderSide: BorderSide(color: Colors.grey, width: 1),
//       ),
//       enabledBorder: UnderlineInputBorder(
//         borderSide: BorderSide(color: Colors.grey, width: 1),
//       ),
//       focusedBorder: UnderlineInputBorder(
//         borderSide: BorderSide(color: Colors.blue, width: 1),
//       ),
//       errorBorder: UnderlineInputBorder(
//         borderSide: BorderSide(color: Colors.red, width: 1),
//       ),
//       focusedErrorBorder: UnderlineInputBorder(
//         borderSide: BorderSide(color: Colors.red, width: 1),
//       ),
//       errorStyle: TextStyle(
//         color: Colors.red,
//         fontSize: 12,
//         fontWeight: FontWeight.w400,
//       ),
//       prefixIcon: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(prefixIcon, size: 24).paddingOnly(right: 18),
//           Expanded(
//             child: CountryCodePicker(
//               onChanged: onCountryChange,
//               initialSelection: 'TZ',
//               flagWidth: 24,
//               padding: EdgeInsets.zero,
//               textStyle: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//               ),
//               favorite: const ['+255', 'TZ'],
//               showCountryOnly: false,
//               showDropDownButton: true,
//               showOnlyCountryWhenClosed: false,
//               alignLeft: false,
//             ),
//           )
//         ],
//       ).paddingSymmetric(horizontal: 18),
//       prefixIconConstraints: BoxConstraints(maxHeight: 24, maxWidth: 160),
//       filled: true,
//     ),
//     onFieldSubmitted: onFieldSubmitted,
//   );
// }

Widget getDivider(
    {double dividerHeight = 0,
    Color setColor = Colors.grey,
    double endIndent = 0,
    double indent = 0,
    double thickness = 1}) {
  return Divider(
    height: dividerHeight.h,
    color: setColor,
    endIndent: endIndent.w,
    indent: indent.w,
    thickness: thickness,
  );
}

Widget getMultilineCustomFont(String text, double fontSize, Color fontColor,
    {String fontFamily = Constant.fontsFamily,
    TextOverflow overflow = TextOverflow.ellipsis,
    TextDecoration decoration = TextDecoration.none,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.start,
    txtHeight = 1.0}) {
  return Text(
    text,
    style: TextStyle(
        decoration: decoration,
        fontSize: fontSize,
        fontStyle: FontStyle.normal,
        color: fontColor,
        fontFamily: fontFamily,
        height: txtHeight,
        fontWeight: fontWeight),
    textAlign: textAlign,
  );
}

Widget getToolbarWithIcon(Function function) {
  return Stack(alignment: Alignment.topCenter, children: [
    getSvgImage("mfariji.svg", width: 60.h, height: 80.h),
    // getAssetImage("splash_logo.png", height: 88.h, width: 68.h),
    // getSvgImage(image)
    Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
            onTap: () {
              function();
            },
            child: getSvgImage("arrow_back.svg", width: 24.h, height: 24.h)))
  ]);
}

Widget getAppBar(Function function, String title, {int? height}) {
  return Container(
    height: (height ?? 150).h, // Use default height if not provided
    // color: secondaryColor,

    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () {
              function();
            },
            icon: Icon(
              CupertinoIcons.arrow_left,
              size: 30.h,
              color: textColor,
            ),
          ),
        ),
        getVerSpace(10.h),
        Row(
          children: [
            getHorSpace(10.h),
            Expanded(
              child: getCustomFont(
                title,
                20.sp,
                textColor,
                1,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Divider(
          color: secondaryColor,
          thickness: 0.3,
        ),
      ],
    ),
  );
}

Widget getProfileWidget(Function function, String image, String name) {
  return GestureDetector(
    onTap: () {
      function();
    },
    child: Column(
      children: [
        Row(
          children: [
            getSvgImage(image, width: 24.h, height: 24.h)
                .marginOnly(left: 18.h),
            getHorSpace(18.h),
            Expanded(
              flex: 1,
              child: getCustomFont(name, 16.sp, hintColor, 1,
                  fontWeight: FontWeight.w400),
            ),
            getSvgImage("arrow_right.svg", height: 16.h, width: 16.h)
          ],
        ).paddingOnly(top: 20.h, bottom: 16.h),
        getDivider(setColor: dividerColor)
      ],
    ),
  );
}
