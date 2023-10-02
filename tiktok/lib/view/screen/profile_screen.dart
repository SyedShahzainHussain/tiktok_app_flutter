import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/provider/auth_proivder.dart';
import 'package:tiktok/provider/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  final uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _updateUserData();
  }

  void _updateUserData() async {
    try {
      await context.read<ProfileProvider>().updateUserId(widget.uid);
      setState(() {
        _isLoading = false; // Update is complete
      });
    } catch (error) {
      // Handle any errors here
      setState(() {
        _isLoading = false; // Update is complete (even if it failed)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        leading: const Icon(Icons.person_add_alt_1_outlined),
        actions: const [Icon(Icons.more_horiz)],
        centerTitle: true,
        title: _isLoading // Check if the update is in progress
            ? const Text(
                "Loading",
              )
            : Consumer<ProfileProvider>(builder: (context, pro, _) {
                if (pro.user.isEmpty) {
                  return const Text(
                    "Loading",
                  );
                } else {
                  return Text(
                    pro.user['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }
              }),
      ),
      body: _isLoading // Check if the update is in progress
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Consumer<ProfileProvider>(
              builder: (context, profile, _) {
                if (profile.user.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    child: SafeArea(
                        child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                    imageUrl: profile.user['profilePhoto'],
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(
                                            color: Colors.black),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      profile.user['following'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      "Following",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      profile.user['followers'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      "Followers",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      profile.user['likes'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      "likes",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 15),
                            InkWell(
                              onTap: () {
                                if (widget.uid ==
                                    FirebaseAuth.instance.currentUser!.uid) {
                                  context.read<AuthProvider>().signOut(context);
                                } else {
                                  profile.followUser();
                                }
                              },
                              child: Container(
                                width: 140,
                                height: 47,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: Colors.black12,
                                )),
                                child: Center(
                                  child: Text(
                                    widget.uid ==
                                            FirebaseAuth.instance.currentUser!.uid
                                        ? "Sign Out"
                                        : profile.user['isFollowing']
                                            ? "UnFollow"
                                            : "Follow",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: profile.user['thumnails'].length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                          ),
                          itemBuilder: (context, index) => CachedNetworkImage(
                            imageUrl: profile.user['thumnails'][index],
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    )),
                  );
                }
              },
            ),
    );
  }
}
