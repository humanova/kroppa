// (c) 2020 Emir Erbasan (humanova)
// MIT License, see LICENSE for more details

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kroppa_app/screens/home_screen.dart';
import 'package:kroppa_app/models/history_model.dart';
import 'package:kroppa_app/widgets/stateful_wrapper.dart';
import 'package:kroppa_app/utils.dart';

List<CroppedImage> _currentImgs = new List<CroppedImage>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {
        _initOnStartup().then((value) {
          print('init done');
          print(_currentImgs);
        });
      },
      child: ChangeNotifierProvider(
        create: (_) => History(_currentImgs),
        child: MaterialApp(
          title: 'Kroppa',
          theme: ThemeData(
            primaryColor: Color(0xFF3EBACE),
            accentColor: Color(0xFFD8ECF1),
            scaffoldBackgroundColor: Color(0xFFF3F5F7),
          ),
          home: HomeScreen(),
        )
      ),
    );
  }
  Future _initOnStartup() async {
    requestPermissions();
    checkAndCreateDataFolder();
    //_currentImgs = await readAndInitializeCroppedImages();
  }
}