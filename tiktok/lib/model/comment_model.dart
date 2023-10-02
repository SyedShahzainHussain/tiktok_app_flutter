import 'package:cloud_firestore/cloud_firestore.dart';

class Comments {
  String username;
  String comment;
  final date;
  List likes;
  String profilePic;
  String uid;
  String id;
  Comments({
    required this.username,
    required this.comment,
    required this.uid,
    required this.date,
    required this.likes,
    required this.profilePic,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "comment": comment,
        "uid": uid,
        "date": date,
        "likes": likes,
        "profilePic": profilePic,
        "id": id,
      };

  static Comments fromSnap(DocumentSnapshot snap) {
    final snaps = snap.data() as Map<String, dynamic>;
    return Comments(
      username: snaps['username'],
      comment: snaps['comment'],
      uid: snaps['uid'],
      date: snaps['date'],
      likes: snaps['likes'],
      profilePic: snaps['profilePic'],
      id: snaps['id'],
    ); 
  }
}
