// (c) 2020 Emir Erbasan (humanova)
// MIT License, see LICENSE for more details

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:kroppa_app/models/history_model.dart';
import 'package:kroppa_app/screens/image_screen.dart';

double roundDouble(double value, int places) {
  double mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

class HistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myHistory = context.watch<History>();
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: myHistory.croppedImages.length,
      itemBuilder: (BuildContext context, int index) {
        CroppedImage image = myHistory.croppedImages[index];
        return Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImageScreen(image: image),
                ),
              ),
              child: Container(
                margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
                height: 170.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: image.isAsset != true
                            ? Image.file(File(image.imageUrl)).image
                            : AssetImage(image.imageUrl)),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        BorderedText(
                          strokeWidth: 1.5,
                          strokeColor: Colors.white,
                          child: Text(image.date,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  decorationColor: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600)),
                        ),
                        BorderedText(
                          strokeWidth: 1.5,
                          strokeColor: Colors.white,
                          child: Text(
                            image.size,
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                decorationColor: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
