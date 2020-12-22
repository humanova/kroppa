// (c) 2020 Emir Erbasan (humanova)
// MIT License, see LICENSE for more details

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:kroppa_app/models/history_model.dart';

class ImageScreen extends StatefulWidget {
  final CroppedImage image;

  ImageScreen({this.image});
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    CroppedImage img = widget.image;
    return Container(
      child: PhotoView(
        imageProvider: img.isAsset != true
            ? Image.file(File(img.imageUrl)).image
            : AssetImage(img.imageUrl),
      ),
    );
  }
}
