import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_mile/controllers/player_controller.dart';
import 'package:sound_mile/splash_screen.dart';
import 'package:sound_mile/util/color_category.dart';
import 'package:sound_mile/util/constant_widget.dart';
import 'package:sound_mile/util/pref_data.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  Future<void> requestPermission() async {
    try {
      print('Requesting permission...');
      if (Platform.isAndroid) {
        // Extract the major version number correctly
        String versionString = Platform.version.split(' ')[0];
        int androidVersion = int.parse(versionString.split('.')[0]);
        print('Android version: $androidVersion');

        if (androidVersion >= 13) {
          // For Android 13 and above
          final permissions = [
            Permission.photos,
            Permission.videos,
            Permission.audio,
          ];

          final statuses = await permissions.request();
          print('Permission statuses: $statuses');

          if (statuses.values.every((status) => status.isGranted)) {
            onPermissionGranted();
          } else {
            showPermissionDeniedDialog();
          }
        } else {
          // For Android versions below 13
          final status = await Permission.storage.status;
          print('Storage permission status: $status');

          if (status.isGranted) {
            onPermissionGranted();
          } else if (status.isDenied || status.isPermanentlyDenied) {
            final requestStatus = await Permission.storage.request();
            print('Requested storage permission status: $requestStatus');
            if (requestStatus.isGranted) {
              onPermissionGranted();
            } else {
              showPermissionDeniedDialog();
            }
          } else {
            showPermissionDeniedDialog();
          }
        }
      } else {
        // Handle permissions for other platforms if required
        onPermissionGranted();
      }
    } catch (e) {
      print('Error: $e');
      showErrorDialog('An error occurred while requesting permissions.');
    }
  }

  void onPermissionGranted() async {
    await PrefData.setIsPermitted(true);
    PlayerController().fetchSongs();

    // Show success dialog
    if (mounted) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Permission Granted'),
            content: Text('Required permissions have been granted.'),
            actions: [
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Get.to(() => const SplashScreen());
                },
              )
            ],
          );
        },
      );
    }
  }

  void showPermissionDeniedDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Permission Denied'),
          content: Text('Permission is required to access and play music.'),
          actions: [
            CupertinoDialogAction(
              child: Text('Retry'),
              onPressed: () {
                Navigator.pop(context);
                requestPermission();
              },
            ),
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          getAssetImage('permission.png'),
          const SizedBox(height: 20),
          Text(
            'Sound Mile requires storage permission to access and play music.',
            style: TextStyle(fontSize: 16, color: textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 90),
          FloatingActionButton.extended(
            onPressed: requestPermission,
            label: Text(
              'Allow',
              style: TextStyle(color: accentColor),
            ),
            icon: Icon(Icons.perm_media, color: accentColor),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}