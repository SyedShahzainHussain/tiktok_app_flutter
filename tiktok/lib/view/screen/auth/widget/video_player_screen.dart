import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String? videoUrl;
  const VideoPlayerScreen({super.key, this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController videoPlayerController;
  late bool isPlaying;
  @override
  void initState() {
    super.initState();
    isPlaying = false;
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!))
          ..initialize().then((value) {
            videoPlayerController.play();
            videoPlayerController.setVolume(1);
          });
          setState(() {
            
          });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return InkWell(
      onTap: () {
        if (isPlaying) {
            videoPlayerController.pause();
          } else {
            videoPlayerController.play();
          }
          isPlaying = !isPlaying;
      },
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(color: Colors.black),
        child: VideoPlayer(videoPlayerController),
      ),
    );
  }
}
