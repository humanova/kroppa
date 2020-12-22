// (c) 2020 Emir Erbasan (humanova)
// MIT License, see LICENSE for more details

import 'dart:math';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kroppa_app/models/history_model.dart';

double roundDouble(double value, int places) {
  double mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

Future<void> requestPermissions() async {
    await Permission.mediaLibrary.request();
    await Permission.photos.request();
    await Permission.storage.request();
}

Future checkAndCreateDataFolder() async {
  final imgDir = Directory('${(await getApplicationDocumentsDirectory()).path}/images');
  imgDir.exists().then((isThere) {
    if (!isThere) {
      imgDir.create(recursive: true).then((Directory directory) {
        print('created /images folder under app storage');
      });
    }
  });
}

void readAndInitializeCroppedImages(List<CroppedImage> images) async {
  final imgDir =
      Directory('${(await getApplicationDocumentsDirectory()).path}/images');
  if (await imgDir.exists()) {
    List<FileSystemEntity> _images = imgDir
        .listSync(recursive: true, followLinks: false)
        .reversed
        .toList();
    _images.forEach((FileSystemEntity img) => images.add(CroppedImage(
        imageUrl: img.path,
        size: '${roundDouble(File(img.path).lengthSync() / 1000000, 1)} MB',
        date:
            '${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(img.path.substring(img.path.lastIndexOf('/') + 1, img.path.lastIndexOf('.')))))}')));
  }
}