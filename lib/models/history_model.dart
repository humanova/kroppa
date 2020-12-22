// (c) 2020 Emir Erbasan (humanova)
// MIT License, see LICENSE for more details

import 'package:flutter/foundation.dart';

class CroppedImage {
  String imageUrl;
  String size;
  String date;
  bool isAsset=false;

  CroppedImage({
    this.imageUrl,
    this.size,
    this.date,
    this.isAsset,
  });
}

class History extends ChangeNotifier {
  List<CroppedImage> croppedImages;

  void add(CroppedImage img) {
    this.croppedImages.insert(0, img);
    notifyListeners();
  }
  
  History(List<CroppedImage> croppedImages){
    this.croppedImages = [...croppedImages, ...assetImages];
  }
  
}

List<CroppedImage> assetImages = [
  CroppedImage(
    imageUrl : 'assets/images/img3.png',
    size : '2.6 MB',
    date : '13.12.2020',
    isAsset: true,
  ),
  CroppedImage(
    imageUrl : 'assets/images/img4.png',
    size : '1.5 MB',
    date : '13.12.2020',
    isAsset: true,
  ),
    CroppedImage(
    imageUrl : 'assets/images/img2.png',
    size : '2.4 MB',
    date : '13.12.2020',
    isAsset: true,
  ),
  CroppedImage(
    imageUrl : 'assets/images/img1.png',
    size : '3.6 MB',
    date : '13.12.2020',
    isAsset: true,
  )
];