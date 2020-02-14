# background_image_gallery_saver

It will save image to the gallery. It uses Kotlin coroutines default thead for saving images. So user willn't experience UI blocking situation. 

# How to Use
You need to include kotlin coroutines for your app build.gradle file

```
implementation "org.jetbrains.kotlinx:kotlinx-coroutines-core:$coroutines_version"
implementation "org.jetbrains.kotlinx:kotlinx-coroutines-android:$coroutines_version"
```



From Uint8List image
```dart
Uint8List pickedImage;
pickedImage = pickedImageMethod() //your method for picking Uint8List file
final result = await BackgroundImageGallerySaver.saveImage(pickedImage);

```
From file

```dart
String file;
file = pickedFileMethod() //your method for picking file url as string
final result = await BackgroundImageGallerySaver.saveFile(file);

```


## Special Notes

** Only Android Support
** The plugin is based on [hui-z
/
image_gallery_saver](https://github.com/hui-z/image_gallery_saver) and [CarnegieTechnologies
/
gallery_saver](https://github.com/CarnegieTechnologies/gallery_saver)

