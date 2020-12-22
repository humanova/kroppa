// (c) 2020 Emir Erbasan (humanova)
// MIT License, see LICENSE for more details

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kroppa_app/models/history_model.dart';
import 'package:kroppa_app/screens/image_screen.dart';
import 'package:kroppa_app/screens/history_screen.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class HistoryCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myHistory = context.watch<History>();
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'History',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HistoryScreen(),
                  ),
                ),
                child: Text(
                  'See All',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 276.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: myHistory.croppedImages.length,
            itemBuilder: (BuildContext context, int index) {
              CroppedImage image = myHistory.croppedImages[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImageScreen(image: image),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  width: 200.0,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Positioned(
                        bottom: 15.0,
                        child: Container(
                          height: 120.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.calendar,
                                    size: 10.0, color: Colors.black45),
                                Text(
                                  '${image.date}',
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2),
                                ),
                                Text(
                                  image.size,
                                  style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 6.0)
                            ]),
                        child: Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image(
                                  height: 180.0,
                                  width: 180.0,
                                  image: image.isAsset != true
                                      ? Image.file(File(image.imageUrl)).image
                                      : AssetImage(image.imageUrl),
                                  fit: BoxFit.cover),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
