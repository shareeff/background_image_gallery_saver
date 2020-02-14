import 'package:flutter/material.dart';
import 'image_provider_view_model.dart';

class ProgressDialog extends StatefulWidget {
  final ImageProviderViewModel imageProviderViewModel;
  ProgressDialog({Key key, @required this.imageProviderViewModel})
      : super(key: key);
  @override
  _ProgressDialogState createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<ProgressDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Stream<String> _saveImage() {
    /* 
    ***Never compute/invoke async function from build function 
    ***As imageProviderViewModel.saveImage() async function
    ***It invokes outside of widget build
    */
    return Stream.fromFuture(Future<String>.delayed(
      Duration(milliseconds: 250),
      () => widget.imageProviderViewModel.saveImage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height * 0.3;
    final screenWidth = MediaQuery.of(context).size.width * 0.8;
    return Center(
      child: Container(
        width: screenWidth,
        height: screenHeight,
        child: Opacity(
          opacity: 0.8,
          child: Card(
            color: Colors.black54,
            elevation: 2,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: StreamBuilder(
                    stream: _saveImage(),
                    //initialData: null,
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        print(snapshot.data);
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          Navigator.of(context).pop(true);
                        });

                        return Center(
                            child: Text(
                          snapshot.data,
                          style: TextStyle(color: Colors.blueAccent),
                        ));
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Please Wait....",
                              style: TextStyle(color: Colors.blueAccent),
                            )
                          ],
                        );
                      }
                    })),
          ),
        ),
      ),
    );
  }
}
