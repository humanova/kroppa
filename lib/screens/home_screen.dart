// (c) 2020 Emir Erbasan (humanova)
// MIT License, see LICENSE for more details

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kroppa_app/widgets/history_carousel.dart';
import 'package:kroppa_app/widgets/image_selector.dart';
import 'package:kroppa_app/screens/history_screen.dart';
import 'package:kroppa_app/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 70.0),
              child: Text('Kroppa: magically crop images',
                  style:
                      TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20.0),
            ImageSelector(), 
            HistoryCarousel()
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentTab,
        color: Colors.black87,
        backgroundColor: Colors.transparent,
        height: 55,
        items: <Widget> [
          Icon(FontAwesomeIcons.cropAlt, size: 25, color: Theme.of(context).primaryColor),
          Icon(FontAwesomeIcons.images, size: 25, color: Theme.of(context).primaryColor),
          Icon(FontAwesomeIcons.cog, size: 25, color: Theme.of(context).primaryColor),
        ],
        animationDuration: Duration(milliseconds: 220),
        animationCurve: Curves.easeInOutSine,
        onTap: (index){
          if (_currentTab != index)
          {
            switch (index) {
              case 0:
                Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryScreen()));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()));
                break;
              default:
                break;
            }
          }
          _currentTab = index;
        },
        ),
    );
  }
}
