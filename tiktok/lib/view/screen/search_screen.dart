import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok/model/user_model.dart';
import 'package:tiktok/view/screen/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController userController = TextEditingController();
  @override
  void dispose() {
    userController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: TextFormField(
          controller: userController,
          onChanged: (val) {
            userController.text = val;
            setState(() {});
          },
          decoration: const InputDecoration(
              labelText: "Search", labelStyle: TextStyle(color: Colors.black)),
          cursorColor: Colors.black,
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("Users")
            .where("username", isGreaterThanOrEqualTo: userController.text)
            .get(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Data Found"),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfileScreen(uid: snapshot.data!.docs[index]['uuid'],);
                  }));
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(snapshot.data!.docs[index]['photosUrl']),
                  ),
                  title: Text(snapshot.data!.docs[index]['username']),
                ),
              );
            },
            itemCount: snapshot.data!.docs.length,
          );
        },
      ),
    );
  }
}
