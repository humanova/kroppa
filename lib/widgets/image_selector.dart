// (c) 2020 Emir Erbasan (humanova)
// MIT License, see LICENSE for more details

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:kroppa_app/models/history_model.dart';
import 'package:kroppa_app/utils.dart';
import 'package:kroppa_app/globals.dart' as globals;

class ImageSelector extends StatefulWidget {
  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  File _image;
  Image _croppedImage;
  bool waitingRequest = false;
  History myHistory;

  @override
  void initState() {
    myHistory = context.read<History>();
    super.initState();
  }

  Future<http.Response> sendCropRequest() {
    dynamic data = {
      'img': base64Encode(_image.readAsBytesSync()),
      'settings': {
        'is_url': false,
        'preprocessing': globals.preprocessing,
        'postprocessing': globals.postprocessing,
        'model': globals.model
      }
    };
    return http.post('http://bruh.uno:5010/cropping-api/crop',
        body: jsonEncode(data),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
        });
  }

  _cropImageAndSave() async {
    final imgDir =
        Directory('${(await getApplicationDocumentsDirectory()).path}/images');
    final tempDir = await getTemporaryDirectory();
    setState(() {
      waitingRequest = true;
    });
    var response = await sendCropRequest();
    if (response.statusCode == 200) {
      _croppedImage = Image.memory(response.bodyBytes);
      // create and save croppedImage to temporary directory
      String filename =
          '${DateTime.now().millisecondsSinceEpoch}${p.extension(_image.path)}';
      try {
        File fileDoc = new File('${imgDir.path}/$filename');
        File fileTemp = new File('${tempDir.path}/$filename');
        fileDoc.writeAsBytesSync(response.bodyBytes);
        fileTemp.writeAsBytesSync(response.bodyBytes);

        // then, save it to the gallery
        //GallerySaver.saveImage(fileTemp.path);
        String locale = Localizations.localeOf(context).toLanguageTag();
        myHistory.add(CroppedImage(
            date: DateFormat.yMd(locale)
                .format(new DateTime.now())
                .replaceAll('/', '.'),
            size: '${roundDouble(response.bodyBytes.length / 1000000, 1)} MB',
            imageUrl: fileDoc.path));
      } on Exception catch (e) {
        await _showDialog('An error happened while saving cropped image.');
        print(e);
      }
    } else {
      await _showDialog("Couldn't send request to the API.");
      print('request returned with error ${response.statusCode}');
    }
    setState(() {
      waitingRequest = false;
    });
  }

  Future<void> _showDialog(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cropping Info'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showImagePickerDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Select source of the image you want to crop."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('From camera'),
              onPressed: () {
                selectImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('From gallery'),
              onPressed: () {
                selectImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future selectImage(ImageSource src) async {
    ImagePicker impick = new ImagePicker();
    var image = await impick.getImage(source: src);

    setState(() {
      if (image != null) {
        _image = File(image.path);
        _croppedImage = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return !waitingRequest
        ? Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'New image',
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(19.0),
                    child: GestureDetector(
                      onTap: _showImagePickerDialog,
                      child: Container(
                        child: _image == null
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(FontAwesomeIcons.solidImage,
                                    color: Colors.black12, size: 200),
                              )
                            : Image.file(_image, width: 250),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0.0, 2.0),
                                blurRadius: 6.0)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _image != null,
                    child: OutlineButton(
                        onPressed: _cropImageAndSave,
                        child: Text(
                          'Crop this image!',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16.0),
                        ),
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ],
          )
        : SpinKitFadingFour(color: Colors.black38, size: 160);
  }
}
