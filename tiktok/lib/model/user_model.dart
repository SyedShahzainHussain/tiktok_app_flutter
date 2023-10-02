class UserModel {
  final String? email;
  final String? username;
  final String? uuid;
  final String? photosUrl;

  UserModel({
    this.email,
    this.username,
    this.uuid,
    this.photosUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'uuid': uuid,
      'photosUrl': photosUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> snapshot) => UserModel(
      email: snapshot['email'],
      username: snapshot['username'],
      uuid: snapshot['uuid'],
      photosUrl: snapshot['photosUrl']);
}
