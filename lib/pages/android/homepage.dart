import 'package:flutter/material.dart';
import 'package:providerthekingofpost/widget/android/listdropdown.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<dynamic> _dataP = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropDown(),
                // Padding(
                //   padding: EdgeInsets.only(
                //     bottom: 5,
                //   ),
                //   child: Text('Provinsi Asal'),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(
                //     bottom: 20,
                //   ),
                //   child: DropDown(),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(
                //     bottom: 20,
                //   ),
                //   child: enableKabupaten == true
                //       ? SizedBox()
                //       : DropDownKabupaten(
                //           tipe: 'asal',
                //           provId: provId,
                //         ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(
                //     bottom: 5,
                //   ),
                //   child: Text('Tujuan'),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(
                //     bottom: 20,
                //   ),
                //   child: DropDown(),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
