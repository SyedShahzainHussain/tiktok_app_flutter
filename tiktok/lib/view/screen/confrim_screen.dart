import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/provider/upload_provider.dart';
import 'package:tiktok/view/screen/auth/widget/text_form_fields.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File? video;
  final String? videoPath;
  const ConfirmScreen({super.key, this.video, this.videoPath});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  TextEditingController musicController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    setState(() {
      _controller = VideoPlayerController.file(widget.video!);
    });
    _controller.initialize();
    _controller.play();
    _controller.setVolume(1);
    _controller.setLooping(true);
  }
@override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height / 1.5,
              child: VideoPlayer(_controller),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width - 20,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: TextInputForm(
                          controller: musicController,
                          labelText: "Song Name",
                          icon: Icons.music_note),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width - 20,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: TextInputForm(
                          controller: captionController,
                          labelText: "Captions",
                          icon: Icons.closed_caption),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          context.read<UploadProvider>().uploadVideo(
                              musicController.text,
                              captionController.text,
                              widget.videoPath!,
                              context,
                              );
                        },
                        child: const Text(
                          "Share!",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ))
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
