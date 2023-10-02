import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok/repository/app_colors.dart';
import 'package:tiktok/view/screen/confrim_screen.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  pickVideo(ImageSource source, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: source);
    if (video != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmScreen(
                    video: File(video.path),
                    videoPath: video.path,
                  )));
    }
  }

  showOptionDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () {
              pickVideo(ImageSource.gallery, context);
            },
            child: const Row(
              children: [
                Icon(Icons.image),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text("Gallery"),
                )
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              pickVideo(ImageSource.camera, context);
            },
            child: const Row(
              children: [
                Icon(Icons.camera),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text("Camera"),
                )
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Row(
              children: [
                Icon(Icons.cancel),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text("Cancel"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: InkWell(
          onTap: () {
            showOptionDialog(context);
          },
          child: Container(
            width: 190,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.buttonColor,
            ),
            child: const Center(
                child: Text(
              "Add Video",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            )),
          )),
    ));
  }
}
