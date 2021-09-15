import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'image_provider_view_model.dart';
import 'progress_dialog.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height - 16;
    final _screenWidth = MediaQuery.of(context).size.width - 32;
    final _imageProviderViewModel =
        Provider.of<ImageProviderViewModel>(context, listen: true);

    final ButtonStyle btnStyle =
        ElevatedButton.styleFrom(
          textStyle: const TextStyle(
                                fontFamily: 'arial',
                                color: Colors.white,
                                fontSize: 18,
                                letterSpacing: 1.4),
          primary: Colors.lightGreen[800],
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            "Gallery Image Saver",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        body: Material(
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Container(
                width: _screenWidth,
                height: _screenHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 18 / 11,
                      child: _imageProviderViewModel.pickedImage == null
                          ? Center(
                              child: Text("No image selected"),
                            )
                          : Ink.image(
                              image: new MemoryImage(
                                  _imageProviderViewModel.pickedImage!),
                              fit: BoxFit.fitWidth,
                            ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ElevatedButton(
                              style: btnStyle,
                              child: Text("Camera"),
                              onPressed: () =>
                                  _imageProviderViewModel.pickCameraImage(),
                            ),
                            ElevatedButton(
                              style: btnStyle,
                              child: Text("Gallery"),
                              onPressed: () =>
                                  _imageProviderViewModel.pickGalleryImage(),
                            ),
                            ElevatedButton(
                              style: btnStyle,
                              child: Text("Save"),
                              onPressed: () => _buildSaveImageDialog(context),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> _buildSaveImageDialog(BuildContext context) {
    final imageProviderViewModel =
        Provider.of<ImageProviderViewModel>(context, listen: false);
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: ProgressDialog(
                imageProviderViewModel: imageProviderViewModel,
              ));
        });
  }
}
