import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/model/video_model.dart';
import 'package:tiktok/provider/upload_provider.dart';

import 'package:tiktok/view/screen/auth/widget/circular_animation.dart';
import 'package:tiktok/view/screen/auth/widget/video_player_screen.dart';
import 'package:tiktok/view/screen/comment_screen.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  builProfile(String profilePhoto) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Stack(children: [
        Positioned(
            left: 5,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Image.network(
                  profilePhoto,
                  fit: BoxFit.cover,
                ),
              ),
            ))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("videos").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                List<Video> videoList = [];
                for (var element in snapshot.data!.docs) {
                  videoList.add(Video.fromsnap(element));
                }
                return PageView.builder(
                    itemCount: videoList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          VideoPlayerScreen(
                              videoUrl: videoList[index].videoUrl),
                          Column(
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              videoList[index]
                                                  .username
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              videoList[index]
                                                  .caption
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.music_note,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                                Text(
                                                  videoList[index]
                                                      .songName
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      margin: EdgeInsets.only(
                                          top: MediaQuery.sizeOf(context)
                                                  .height /
                                              5),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // builProfile(""),
                                            Column(
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      context
                                                          .read<
                                                              UploadProvider>()
                                                          .likeVideo(
                                                              videoList[index]
                                                                  .id
                                                                  .toString());
                                                    },
                                                    child: videoList[index]
                                                            .likes!
                                                            .contains(
                                                                videoList[index]
                                                                    .uid
                                                                    .toString())
                                                        ? const Icon(
                                                            Icons.favorite,
                                                            size: 40,
                                                            color: Colors.red,
                                                          )
                                                        : const Icon(
                                                            Icons.favorite,
                                                            size: 40,
                                                            color: Colors.white,
                                                          )),
                                                const SizedBox(
                                                  height: 7,
                                                ),
                                                Text(
                                                  videoList[index]
                                                      .likes!
                                                      .length
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CommentScreen(
                                                                  model:
                                                                      videoList[
                                                                          index],
                                                                )));
                                                  },
                                                  child: const Icon(
                                                    Icons.comment,
                                                    size: 40,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 7,
                                                ),
                                                Text(
                                                  videoList[index]
                                                      .commentCount
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                const Icon(
                                                  Icons.reply,
                                                  size: 40,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(
                                                  height: 7,
                                                ),
                                                Text(
                                                  videoList[index]
                                                      .commentCount
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ),
                                            CircularAnimation(
                                                widget: SizedBox(
                                              width: 60,
                                              height: 60,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            11),
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                        gradient:
                                                            const LinearGradient(
                                                                colors: [
                                                              Colors.grey,
                                                              Colors.white,
                                                            ]),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      child: Image.network(
                                                        videoList[index]
                                                            .profilePhoto
                                                            .toString(),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                          ]),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    });
              }
            }));
  }
}
