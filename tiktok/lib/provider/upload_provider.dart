import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktok/model/comment_model.dart';
import 'package:tiktok/model/video_model.dart';
import 'package:tiktok/utils/utils.dart';
import 'package:tiktok/view/screen/home_screen.dart';
import 'package:video_compress/video_compress.dart';

class UploadProvider extends ChangeNotifier {
  _compressVideo(String videoPath) async {
    final compressVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);
    return compressVideo!.file;
  }

  _getThumnail(String videoPath) async {
    final thumnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumnail;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = FirebaseStorage.instance.ref().child("videos").child(id);
    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot taskSnapshot = await uploadTask;
    final String dowunloadUrl = await taskSnapshot.ref.getDownloadURL();
    return dowunloadUrl;
  }

  Future<String> _uploadImageToStorage(
    String id,
    String videoPath,
  ) async {
    Reference ref = FirebaseStorage.instance.ref().child("thumnails").child(id);
    UploadTask uploadTask = ref.putFile(await _getThumnail(videoPath));
    TaskSnapshot taskSnapshot = await uploadTask;
    final String dowunloadUrl = await taskSnapshot.ref.getDownloadURL();
    return dowunloadUrl;
  }

  uploadVideo(String songName, String captions, String videoPath,
      BuildContext context) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDocs =
          await FirebaseFirestore.instance.collection("Users").doc(uid).get();
      var allDocs = await FirebaseFirestore.instance.collection("videos").get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumnailUrl = await _uploadImageToStorage("Video $len", videoPath);
      Video video = Video(
        username: (userDocs.data()! as Map<String, dynamic>)['username'],
        songName: songName,
        caption: captions,
        videoUrl: videoUrl,
        thumbnail: thumnailUrl,
        commentCount: 0,
        shareCount: 0,
        likes: [],
        uid: uid,
        id: "Video $len",
        profilePhoto: (userDocs.data()! as Map<String, dynamic>)['photosUrl'],
      );

      await FirebaseFirestore.instance
          .collection("videos")
          .doc('Video $len')
          .set(video.toJson());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    } catch (e) {
      Utils.flushBarErrorMessage(e.toString(), context);
    }
    notifyListeners();
  }

  likeVideo(String id) async {
    DocumentSnapshot docs =
        await FirebaseFirestore.instance.collection("videos").doc(id).get();

    final uid = FirebaseAuth.instance.currentUser!.uid;
    if ((docs.data()! as dynamic)['likes'].contains(uid)) {
      await FirebaseFirestore.instance.collection("videos").doc(id).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await FirebaseFirestore.instance.collection("videos").doc(id).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
    notifyListeners();
  }

  commentVideo(String id, String uid, TextEditingController commentController,
      context) async {
    if (commentController.text.isNotEmpty) {
      DocumentSnapshot docs =
          await FirebaseFirestore.instance.collection("Users").doc(uid).get();

      final allDocs = await FirebaseFirestore.instance
          .collection("videos")
          .doc(id)
          .collection("comments")
          .get();
      final length = allDocs.docs.length;

      final commentModel = Comments(
        username: (docs.data() as dynamic)['username'],
        comment: commentController.text,
        uid: uid,
        date: DateTime.now(),
        likes: [],
        profilePic: (docs.data() as dynamic)['photosUrl'],
        id: 'comments ${length.toString()}',
      );

      await FirebaseFirestore.instance
          .collection("videos")
          .doc(id)
          .collection("comments")
          .doc('comments ${length.toString()}')
          .set(commentModel.toJson());

      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection("videos").doc(id).get();
      await FirebaseFirestore.instance.collection("videos").doc(id).update({
        "commentCount": (doc.data()! as dynamic)['commentCount'] + 1,
      });
      commentController.text = "";
    } else {
      Utils.flushBarErrorMessage("Please enter comment", context);
    }

    notifyListeners();
  }

  likeComments(String videoid, String commentId) async {
    DocumentSnapshot docs = await FirebaseFirestore.instance
        .collection("videos")
        .doc(videoid)
        .collection("comments")
        .doc(commentId)
        .get();

    final uid = FirebaseAuth.instance.currentUser!.uid;
    if ((docs.data()! as dynamic)['likes'].contains(uid)) {
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(videoid)
          .collection("comments")
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(videoid)
          .collection("comments")
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
    notifyListeners();
  }
}
