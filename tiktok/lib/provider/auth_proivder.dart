import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok/model/user_model.dart';
import 'package:tiktok/utils/utils.dart';
import 'package:tiktok/view/screen/auth/login_screen.dart';
import 'package:tiktok/view/screen/home_screen.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  bool _isLoginLoading = false;
  bool get isLoginLoading => _isLoginLoading;

  setLoginLoading(bool loading) {
    _isLoginLoading = loading;
    notifyListeners();
  }

  File? image;
  File? get imagePath => image;
  void pickImage(context) async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
      Utils.flushBarErrorMessage(
          "You have successfully seleted your profile picture", context);
      notifyListeners();
    }
  }

  Future<String> _uploadStorage(File image) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("ProfilePic")
        .child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> register(
    String usernamme,
    String email,
    String password,
    File? image,
    context,
  ) async {
    try {
      setLoading(true);
      if (usernamme.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential cred =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String downloadUrl = await _uploadStorage(image);
        UserModel userModel = UserModel(
          email: email,
          username: usernamme,
          uuid: cred.user!.uid,
          photosUrl: downloadUrl,
        );

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(cred.user!.uid)
            .set(userModel.toJson())
            .then((value) {
          setLoading(false);
          Utils.flushBarErrorMessage(
              "You have successfully registered with us", context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        });
      } else {
        setLoading(false);
        Utils.flushBarErrorMessage("Error Creating Account", context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        setLoading(false);
        Utils.flushBarErrorMessage(
            "This email is already registered with us", context);
      } else if (e.code == "invalid-email") {
        setLoading(false);
        Utils.flushBarErrorMessage("Invalid Email", context);
      } else if (e.code == "weak-password") {
        setLoading(false);
        Utils.flushBarErrorMessage("Weak Password", context);
      }
    } catch (e) {
      setLoading(false);
      Utils.flushBarErrorMessage(e.toString(), context);
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  Future<void> login(
    String username,
    String password,
    context,
  ) async {
    try {
      setLoginLoading(true);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      setLoginLoading(false);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
      Utils.flushBarErrorMessage(
          "You have successfully logged in with us", context);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        setLoginLoading(false);
        Utils.flushBarErrorMessage("Invalid Email", context);
      } else if (e.code == "wrong-password") {
        setLoginLoading(false);
        Utils.flushBarErrorMessage("Wrong Password", context);
      }
    } catch (e) {
      setLoginLoading(false);
      Utils.flushBarErrorMessage(e.toString(), context);
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  Future<void> signOut(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
  }
}
