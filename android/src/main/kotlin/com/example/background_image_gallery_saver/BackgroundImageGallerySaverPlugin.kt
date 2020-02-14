package com.example.background_image_gallery_saver

import android.content.ContentValues
import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import kotlinx.coroutines.*
import java.io.*
import java.lang.Exception

/** BackgroundImageGallerySaverPlugin */
public class BackgroundImageGallerySaverPlugin: FlutterPlugin, MethodCallHandler, CoroutineScope by MainScope()  {
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "background_image_gallery_saver")
    applicationContext = flutterPluginBinding.applicationContext
    channel.setMethodCallHandler(BackgroundImageGallerySaverPlugin());
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    private var registrar: Registrar? = null
    private var applicationContext: Context? =null
    @JvmStatic
    fun registerWith(reg: Registrar) {
      val channel = MethodChannel(reg.messenger(), "background_image_gallery_saver")
      channel.setMethodCallHandler(BackgroundImageGallerySaverPlugin())
      registrar = reg
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when{
      call.method == "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      call.method == "saveImageToGallery" -> {
        val image = call.arguments as ByteArray
        launch {
          result.success(saveImageToGallery(BitmapFactory.decodeByteArray(image,0,image.size)))
        }

      }
      call.method == "saveFileToGallery" -> {
        val path = call.arguments as String
        launch {
          result.success(saveFileToGallery(path))
        }

      }
      else -> result.notImplemented()

    }
  }


  private suspend fun saveImageToGallery(bmp: Bitmap): Boolean {
    val result = saveImageToGalleryDispatchers(bmp)
    return withContext(Dispatchers.Main) {
      return@withContext result
    }
  }

  private suspend fun saveImageToGalleryDispatchers(bmp: Bitmap): Boolean{
    return withContext(Dispatchers.Default){
      try {
        val source = bitmapToArray(bmp)
        return@withContext saveImage(source, "jpeg")
      } catch (e: IOException) {
        e.printStackTrace()
      }
      return@withContext false
    }

  }

  private suspend fun saveFileToGallery(filePath: String): Boolean {
    val result = saveFileToGalleryDispatchers(filePath)
    return withContext(Dispatchers.Main) {
      return@withContext result
    }
  }

  private suspend fun saveFileToGalleryDispatchers(filePath: String): Boolean {
    return withContext(Dispatchers.Default){
      try {
        val source = getBytesFromFile(File(filePath))
        return@withContext saveImage(source, "jpeg")
      } catch (e: IOException) {
        e.printStackTrace()
      }
      return@withContext false
    }
  }

  private fun saveImage(source: ByteArray?, extension: String = ""): Boolean {

    val applicationName = getApplicationName()

    var fileName = System.currentTimeMillis().toString()
    if (extension.isNotEmpty()) {
      fileName += (".$extension")
    }
    val mimeType = if(extension.isNotEmpty()) "image/$extension" else "image/jpeg"
    val values = ContentValues()
    values.put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
    values.put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q){
      values.put(MediaStore.MediaColumns.RELATIVE_PATH, "DCIM/$applicationName/")

    }else{
      /*val storePath =  applicationContext?.getExternalFilesDir(Environment.DIRECTORY_PICTURES)
              ?.absolutePath + File.separator + getApplicationName() */
      //val storePath =  Environment.getExternalStorageDirectory().absolutePath + File.separator + getApplicationName()
      val storePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM).absolutePath + File.separator + getApplicationName()
      val appDir = File(storePath)
      if (!appDir.exists()) {
        appDir.mkdir()
      }
      val imageFilePath = File(appDir, fileName).absolutePath
      values.put(MediaStore.Images.ImageColumns.DATA, imageFilePath)


    }
    var imageUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI

    try {
      val contentResolver = applicationContext?.contentResolver
      imageUri = contentResolver?.insert(imageUri, values)
      if (source != null){
        var outputStream: OutputStream? = null
        if (imageUri != null) {
          outputStream = contentResolver?.openOutputStream(imageUri)
        }

        outputStream?.use {
          outputStream.write(source)
        }

      } else {
        if (imageUri != null) {
          contentResolver?.delete(imageUri, null, null)
        }
        imageUri = null

      }



    }catch (e: IOException) {

      e.printStackTrace()

      return false
    }



    return true

  }

  private fun bitmapToArray(bmp: Bitmap): ByteArray? {
    val stream = ByteArrayOutputStream()
    bmp.compress(Bitmap.CompressFormat.JPEG, 100, stream)
    val byteArray = stream.toByteArray()
    bmp.recycle()
    return byteArray
  }

  private fun getBytesFromFile(file: File): ByteArray? {
    val size = file.length().toInt()
    val bytes = ByteArray(size)
    val buf = BufferedInputStream(FileInputStream(file) as InputStream)
    buf.use {
      buf.read(bytes, 0, bytes.size)
    }

    return bytes
  }

  private fun getApplicationName(): String {
    //val context = registrar?.activeContext()?.applicationContext
    val context = applicationContext
    var ai: ApplicationInfo? = null
    try {
      ai = context?.packageManager?.getApplicationInfo(context.packageName, 0)
    } catch (e: PackageManager.NameNotFoundException) {
    }
    var appName: String
    appName = if (ai != null) {
      val charSequence = context?.packageManager?.getApplicationLabel(ai)
      StringBuilder(charSequence!!.length).append(charSequence).toString()
    } else {
      "Background_Image_Gallery_Saver"
    }
    return  appName
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }
}
