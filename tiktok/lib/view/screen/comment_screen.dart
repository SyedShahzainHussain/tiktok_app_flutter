import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/model/comment_model.dart';
import 'package:tiktok/model/video_model.dart';
import 'package:tiktok/provider/upload_provider.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentScreen extends StatefulWidget {
  final Video model;
  const CommentScreen({super.key, required this.model});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("videos")
              .doc(widget.model.id)
              .collection("comments")
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
              // Handle the case where data is not available yet.
              return  const Center(
                child:  Text(
                  "No Comments...",
                  style: TextStyle(color: Colors.white),
                ),
              ); // You can replace this with your preferred loading indicator or message.
            }

            List<Comments> comments = [];
            for (var element in snapshot.data!.docs) {
              comments.add(Comments.fromSnap(element));
            }
            return SafeArea(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  // Timestamp? timestamp = comments[index].date as Timestamp?;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(comments[index].profilePic),
                    ),
                    title: Row(
                      children: [
                        Flexible(
                          child: FittedBox(
                            child: Text(
                              comments[index].username,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Flexible(
                          child: FittedBox(
                            child: Text(
                              comments[index].comment,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Flexible(
                          child: FittedBox(
                            child: Text(
                              // DateFormat.yMMMd()
                              //     .format(timestamp!.toDate())
                              //     .toString(),
                              'HE',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Flexible(
                          child: FittedBox(
                            child: Text(
                              comments[index].likes.length.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          context.read<UploadProvider>().likeComments(
                              widget.model.id.toString(), comments[index].id);
                        },
                        icon: comments[index].likes.contains(
                                FirebaseAuth.instance.currentUser!.uid)
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite,
                                color: Colors.white,
                              )),
                  );
                },
                itemCount: comments.length,
              ),
            );
          }),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8.0),
            child: TextField(
              controller: commentController,
              decoration: const InputDecoration(
                  hintText: "Comment",
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2),
                  )),
            ),
          )),
          InkWell(
            onTap: () {
              context.read<UploadProvider>().commentVideo(
                    widget.model.id.toString(),
                    widget.model.uid.toString(),
                    commentController,
                    context,
                  );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              child: const Text(
                "Comments",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ]),
      )),
    );
  }
}
