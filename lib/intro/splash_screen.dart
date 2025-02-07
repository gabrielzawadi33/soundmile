import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_mile/pages/home_screen.dart';
import 'package:sound_mile/intro/permission_screen.dart';
import 'package:sound_mile/util/color_category.dart';
import 'package:sound_mile/util/constant_widget.dart';
import 'package:sound_mile/util/pref_data.dart';

import '../controllers/home_conroller.dart';
import '../controllers/player_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  HomeController homeController = Get.put(HomeController());
  late bool isPermitted;

  @override
  void initState() {
    super.initState();
    getIsFirst();
  }

  void getIsFirst() async {
    homeController.getIsShowPlayingData();
    isPermitted = (await PrefData.getIsPermitted())!;
    await Future.delayed(const Duration(milliseconds: 50));
    

    // ignore: unnecessary_null_comparison
    if (!isPermitted || isPermitted == null) {
      Get.to(const PermissionPage());
    } else {
      await Future.delayed(const Duration(milliseconds: 50));
      await PlayerController().fetchSongs();
      Get.to(HomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 300,
            ),
            // SizedBox(
            //   height: 150,
            //   width: 150,
            //   child: getSvgImage('mile.svg')),
//  getCustomFont('Sound Mile', 30, textColor, 1),
            SizedBox(
              height: 100,
              width: 100,
              child: ClipOval(
                child: getAssetImage(
                  'mile.png',
                ),
              ),
            ),
            SizedBox(
              height: 280,
            ),
            
           
           
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
            ),
             SizedBox(
              height: 10,
            ),
            getCustomFont('Loading Data...', 12, textColor, 1),

            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
