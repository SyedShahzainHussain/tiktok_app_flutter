import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok/view/screen/add_screen.dart';
import 'package:tiktok/view/screen/profile_screen.dart';
import 'package:tiktok/view/screen/search_screen.dart';
import 'package:tiktok/view/screen/video_screen.dart';

class Utils {
  static Flushbar? _currentFlushbar;
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static flushBarErrorMessage(String message, BuildContext context) {
    if (_currentFlushbar != null) {
      // If a Flushbar is currently showing, hide it
      _currentFlushbar!.dismiss();
    }
    _currentFlushbar = Flushbar(
      icon: const Icon(
        Icons.info,
        color: Colors.red,
      ),
      message: message,
      forwardAnimationCurve: Curves.decelerate,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      duration: const Duration(seconds: 5),
      borderRadius: BorderRadius.circular(10),
      onTap: (Flushbar flushbar) {
        // Handle the tap on the Flushbar, you can add custom logic here
        flushbar.dismiss(); // Dismiss the current Flushbar
        _currentFlushbar = null; // Set the current Flushbar to null
      },
    )..show(context);
  }

  static final pages = [
    VideoScreen(),
    SearchScreen(),
    AddScreen(),
    Text("MessageScreen"),
    ProfileScreen(
      uid: FirebaseAuth.instance.currentUser!.uid,
    )
  ];
}
