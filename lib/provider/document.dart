import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;

class documentPicker with ChangeNotifier {
  File? _pickedImage;
  File? _compressedImage;

  File? get pickedImage => _pickedImage;
  File? get compressedImage => _compressedImage;

  bool _uploading = false;

  bool get uploading => _uploading;

  void set uploading(bool value) {
    _uploading = value;
    notifyListeners();
  }

  Future<void> pickImageFromGallery() async {
    print("Picking");
    try {
      final pickedImageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImageFile != null) {
        final bytes = await pickedImageFile.readAsBytes();
        final kb = bytes.length / 1024;
        final mb = kb / 1024;

        if (kDebugMode) {
          print('Original image size: ${mb.toString()} MB');
        }

        final dir = await path_provider.getTemporaryDirectory();
        final targetPath = '${dir.absolute.path}/temp_${mb
            .toString()}--${DateTime.now().microsecondsSinceEpoch.toString()}.jpg';

        // Convert the original image to compress it
        final result = await FlutterImageCompress.compressAndGetFile(
          pickedImageFile.path,
          targetPath,
          minHeight: 720,
          minWidth: 720,
          quality: 20, // Keep this high to get the original quality of the image
        );

        if (result != null) {
          final data = await result.readAsBytes();
          final newKb = data.length / 1024;
          final newMb = newKb / 1024;

          if (kDebugMode) {
            print('Compressed image size: ${newMb.toString()} MB');
          }

          _pickedImage = File(pickedImageFile.path);
          _compressedImage = File(result.path);
          notifyListeners();
        } else {
          print('Compression failed.');
        }
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking or compressing image: $e');
    }
  }

  void removePic() {
    _pickedImage = null;
    _compressedImage = null;
    notifyListeners();
  }

  void storeImage() async {
    try {
      uploading = true;

      final File? pickedImage = _compressedImage;
      if (pickedImage != null) {
        final reference = storage.FirebaseStorage.instance
            .ref("documentUrl/${DateTime.now().microsecondsSinceEpoch.toString()}");

        final task = reference.putFile(pickedImage);
        await task;

        // Fetch the download URL
        final getUrl = await reference.getDownloadURL();
        final imageUrl = getUrl.toString();

        // Store the URL and current time in Firebase Cloud Firestore

        await FirebaseFirestore.instance.collection("userData").doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'documentUrl': imageUrl,
        });

        print("Successfully stored data in Firestore");
        uploading = false;
      } else {
        print('No image to upload.');
        uploading = false;
      }
    } catch (e) {
      // Handle any exceptions that occur during the process
      print('Error storing image and data: $e');
      uploading = false;
    }
  }
}
