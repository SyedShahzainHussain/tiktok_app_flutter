import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  String? _uid;
  String? get ui => _uid;
  Future<void> updateUserId(uid) async {
    _uid = uid;
    await getUserData();

    notifyListeners();
  }

  Map<String, dynamic> _user = {};
  Map<String, dynamic> get user => _user;

  Future<void> getUserData() async {
    List<String> thumnails = [];

    final myVideos = await FirebaseFirestore.instance
        .collection("videos")
        .where("uid", isEqualTo: ui)
        .get();

    for (int i = 0; i < myVideos.docs.length; i++) {
      thumnails.add(myVideos.docs[i]["thumbnail"]);
    }

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection("Users").doc(ui).get();

    final userData = userDoc.data() as dynamic;
    String name = userData['username'];
    String profilePhoto = userData['photosUrl'];
    int likes = 0;
    int following = 0;
    int followers = 0;
    bool isFollowing = false;
    for (var element in myVideos.docs) {
      likes += (element.data()['likes'] as List).length;
    }

    var followerDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(ui)
        .collection('followers')
        .get();

    var followingDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(ui)
        .collection('following')
        .get();

    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;
    FirebaseFirestore.instance
        .collection("Users")
        .doc(ui)
        .collection("followers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });
    _user = {
      "followers": followers.toString(),
      "following": following.toString(),
      "likes": likes.toString(),
      "name": name,
      "profilePhoto": profilePhoto,
      "thumnails": thumnails, 
      "isFollowing": isFollowing,
    };
    notifyListeners();
  }

  followUser() async {
    final docs = await FirebaseFirestore.instance
        .collection("Users")
        .doc(ui)
        .collection("followers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (!docs.exists) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(ui)
          .collection("followers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({});

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("following")
          .doc(ui)
          .set({});
      user.update('followers', (value) => (int.parse(value) + 1).toString());
    } else {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(ui)
          .collection("followers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("following")
          .doc(ui)
          .delete();
      user.update('followers', (value) => (int.parse(value) - 1).toString());
    }
    user.update("isFollowing", (value) => !value);
    notifyListeners();
  }
}
