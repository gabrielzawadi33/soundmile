import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_mile/controllers/player_controller.dart';
import 'package:sound_mile/util/color_category.dart';
import 'package:sound_mile/util/constant_widget.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        
          getAssetImage('permission.png'),
          SizedBox(height: 20),
          Text(
            'Sound Mile requires storage permission to access and play music.',
            style: TextStyle(fontSize: 16, color: textColor),textAlign: TextAlign.center,
          ),
        const SizedBox(height:90),
          FloatingActionButton.extended(
            onPressed: () async {
              requestPermission();
            },
            label: Text('Allow', style: TextStyle(color: accentColor
            ),), 
            icon: Icon(Icons.perm_media, color: accentColor,), 
          ),
          SizedBox(height: 20),],
      ),
    );
  }
}
