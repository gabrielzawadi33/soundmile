import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_mile/controllers/player_controller.dart';
import 'package:sound_mile/util/color_category.dart';
import 'package:sound_mile/util/pref_data.dart';

import 'pages/home_screen.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  requestPermission() async {
    Permission.storage.request();
    if (await Permission.storage.isGranted) {
      await PrefData.setIsPermitted(true);
      PlayerController().fetchSongs();

      // ignore: use_build_context_synchronously
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Permission Granted'),
            content: Text('Storage permission has been granted.'),
            actions: [
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Get.to(() => HomeScreen());
                },
              )
            ],
          );
        },
      );
    } else {
      requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                requestPermission();
              },
              child: Text('Allow'),
            ),
            SizedBox(height: 20),
            const Text('Loading...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
