import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_mile/pages/home_screen.dart';
import 'package:sound_mile/permission_screen.dart';
import 'package:sound_mile/util/color_category.dart';
import 'package:sound_mile/util/constant_widget.dart';
import 'package:sound_mile/util/pref_data.dart';

import 'controllers/player_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
    late bool isPermitted;

  @override
  void initState() {
    super.initState();
    getIsFirst();
  }

  void getIsFirst() async {
    await Future.delayed(const Duration(seconds:1));
     isPermitted = (await PrefData.getIsPermitted())!;

    // ignore: unnecessary_null_comparison
    if (!isPermitted || isPermitted == null) {
      Get.to(const PermissionPage()); 
      
      
    } else {
      await Future.delayed(const Duration(seconds:1));
      await PlayerController().fetchSongs();
      Get.to(HomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: bgDark,
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 150,
              width: 150,
              child: getSvgImage('mile.svg')),
            // getCustomFont('Sound Mile', 12, textColor, 1),
          ],
        ),
      ),
    );
  }
}