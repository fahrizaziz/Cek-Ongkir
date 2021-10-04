import 'package:flutter/material.dart';
import 'package:providerthekingofpost/pages/android/homepage.dart';
import 'package:providerthekingofpost/pages/web/homewebpage.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth <= 768) {
            return HomePage();
          } else if (constraints.maxWidth <= 1200) {
            return HomeWebPage();
          } else {
            return HomeWebPage();
          }
        }),
      );
    });
  }
}
