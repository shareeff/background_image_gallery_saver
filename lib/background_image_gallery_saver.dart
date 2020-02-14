import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class BackgroundImageGallerySaver {
  static const MethodChannel _channel =
      const MethodChannel('background_image_gallery_saver');

  static Future saveImage(Uint8List imageBytes) async {
    assert(imageBytes != null);
    final result =
        await _channel.invokeMethod('saveImageToGallery', imageBytes);
    return result;
  }

  /// Save the PNG，JPG，JPEG image or video located at [file] to the local device media gallery.
  static Future saveFile(String file) async {
    assert(file != null);
    final result = await _channel.invokeMethod('saveFileToGallery', file);
    return result;
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
