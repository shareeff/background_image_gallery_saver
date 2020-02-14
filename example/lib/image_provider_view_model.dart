import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:background_image_gallery_saver/background_image_gallery_saver.dart';

class ImageProviderViewModel extends ChangeNotifier {
  Uint8List _pickedImage;
  ImageProviderViewModel() {
    PermissionHandler().requestPermissions(<PermissionGroup>[
      PermissionGroup.camera,
      PermissionGroup.storage,
    ]);
  }

  Uint8List get pickedImage => _pickedImage;
  set pickedImage(Uint8List image) {
    _pickedImage = image;
    notifyListeners();
  }

  Future pickCameraImage() async {
    ImagePicker.pickImage(source: ImageSource.camera)
        .then((File recordedImage) {
      if (recordedImage != null && recordedImage.path != null) {
        pickedImage = recordedImage.readAsBytesSync();
      }
    });
  }

  Future pickGalleryImage() async {
    ImagePicker.pickImage(source: ImageSource.gallery)
        .then((File recordedImage) {
      if (recordedImage != null && recordedImage.path != null) {
        pickedImage = recordedImage.readAsBytesSync();
      }
    });
  }

  Future<String> saveImage() async {
    if (pickedImage.isNotEmpty) {
      final result = await BackgroundImageGallerySaver.saveImage(pickedImage);
      print(result);
      return "Image Saved";
    } else {
      return "No Image Selected";
    }
  }
}
