import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

Future<String?> getProfilePicUrl(String name) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc('profile')
        .collection('admin')
        .where('name', isEqualTo: name)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data()['url'] as String?;
    } else {
      debugPrint('No profile pic found for $name');
      return null;
    }
  } catch (error) {
    debugPrint('Error retrieving profile pic: $error');
    return null;
  }
}

void addProfilePic(String name, String url) {
  FirebaseFirestore.instance
      .collection('users')
      .doc("profile")
      .collection("admin")
      .where('name', isEqualTo: name)
      .get()
      .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({'url': url}).then((_) {
          Fluttertoast.showToast(
              msg: "Profile pic for $name updated",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          debugPrint("Profile pic for $name updated");
          return getProfilePicUrl(name);
        }).catchError((error) {
          Fluttertoast.showToast(
              msg: "Failed to update profile pic: $error",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          debugPrint("Failed to update profile pic: $error");
          throw ("Failed to update profile pic: $error");
        });
      }
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc("profile")
          .collection("admin")
          .add({
        'name': name,
        'url': url,
      }).then((DocumentReference docRef) {
        debugPrint("Profile pic for $name added @: ${docRef.id}");
        return getProfilePicUrl(name);
      }).catchError((error) {
        Fluttertoast.showToast(
            msg: "Failed to add profile pic for $name, retry. . .",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        throw ("Failed to add profile pic: $error");
      });
    }
  }).catchError((error) {
    Fluttertoast.showToast(
        msg: "Some error occured, chek your internet connection and try again!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    debugPrint("Error fetching document: $error");
  });
}

Future<void> pickAndUploadImage(profileName) async {
  final picker = ImagePicker();
  String? imageUrl;
  try {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    Fluttertoast.showToast(
        msg: "Profile pic setting for $profileName",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    if (pickedFile != null) {
      final imageRef =
          FirebaseStorage.instance.ref().child('images/$profileName.jpg');
      await imageRef.putFile(File(pickedFile.path));
      imageUrl = await imageRef.getDownloadURL();

      return addProfilePic(profileName, imageUrl);
    }
  } on FirebaseException catch (e) {
    debugPrint('Firebase error: $e');
  } catch (e) {
    debugPrint('Other error: $e');
  }
}
