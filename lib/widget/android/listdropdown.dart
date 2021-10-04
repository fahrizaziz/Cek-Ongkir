import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:providerthekingofpost/model/kota.dart';
import 'package:providerthekingofpost/model/kurir.dart';
import 'package:providerthekingofpost/model/provinsi.dart';
import 'package:providerthekingofpost/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:providerthekingofpost/widget/android/berat.dart';

class DropDown extends StatefulWidget {
  const DropDown({Key? key}) : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  TextEditingController _weightController = TextEditingController();
  // late TextEditingController _weightController;
  @override
  void initState() {
    _weightController = TextEditingController();
    super.initState();
  }

  var enableKabupatenAsal = true;
  var enableKabupatenTujuan = true;
  var provAsalId = 0;
  var provTujuanId = 0;
  var kotaAsalId = 0;
  var kotaTujuanId = 0;
  var provId = 0;
  var hiddenButton = true;
  var kurir = "";
  showButton() {
    if (kotaAsalId != 0 && kotaTujuanId != 0 && kurir != "") {
      hiddenButton = false;
    } else {
      hiddenButton = true;
    }
  }

  ongkir() async {
    Uri url = Uri.parse(Api.cost);
    try {
      final response = await http.post(
        url,
        body: {
          'origin': '$kotaAsalId',
          'destination': '$kotaTujuanId',
          'weight': _weightController.text,
          'courier': kurir,
        },
        headers: {
          'key': Api.key,
          'content-type': 'application/x-www-form-urlencoded',
        },
      );
      var data = json.decode(response.body) as Map<String, dynamic>;
      var results = data["rajaongkir"]["results"] as List<dynamic>;
      print(results);
      var listAllCourier = Courier.fromJsonList(results);
      var courier = listAllCourier[0];
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(courier.name!),
          children: [
            Column(
              children: courier.costs!
                  .map(
                    (e) => ListTile(
                      title: Text('${e.service}'),
                      subtitle: Text('Rp ${e.cost![0].value}'),
                      trailing: Text(
                        courier.code == 'pos'
                            ? '${e.cost![0].etd}'
                            : '${e.cost![0].etd} Hari',
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          // content:
        ),
      );
      // AlertDialog(
      //   title: Text(courier.name!),
      //   content: Column(
      //     children: courier.costs!
      //         .map(
      //           (e) => ListTile(
      //             title: Text('${e.service}'),
      //             subtitle: Text('Rp ${e.cost![0].value}'),
      //             trailing: Text(
      //               courier.code == 'pos'
      //                   ? '${e.cost![0].etd}'
      //                   : '${e.cost![0].etd} Hari',
      //             ),
      //           ),
      //         )
      //         .toList(),
      //   ),
      // );
    } catch (e) {
      log(e.toString());
      AlertDialog(
        title: Text('Terjadi kesalahan'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget provi() {
      return DropdownSearch<Provinsi>(
        // enabled: (prov) {
        //   if (prov != null) {
        //     enableKabupaten = false;
        //   } else {
        //     enableKabupaten = true;
        //   }
        // },
        showClearButton: true,
        hint: 'Pilih Provinsi',
        onFind: (String filter) async {
          final response = await http.get(
            Uri.parse(Api.province),
            headers: {
              'key': Api.key,
            },
          );
          try {
            var data = jsonDecode(response.body) as Map<String, dynamic>;
            var status = data['rajaongkir']['status']['code'];
            if (status != 200) {
              throw data['rajaongkir']['status']['description'];
            }

            var listAllProvince =
                data['rajaongkir']['results'] as List<dynamic>;

            var models = Provinsi.fromJsonList(listAllProvince);
            return models;
          } catch (e) {
            return List<Provinsi>.empty();
          }
        },
        onChanged: (prov) {
          setState(
            () {
              if (prov != null) {
                enableKabupatenAsal = false;
                provAsalId = int.parse(prov.provinceId!);
                print(prov.province);
              } else {
                enableKabupatenAsal = true;
                provAsalId = 0;
              }
              showButton();
            },
          );
        },
        popupItemBuilder: (context, item, isSelected) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              '${item.province}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          );
        },
        itemAsString: (item) => item.province!,
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 25,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          hintText: 'Cari Provinsi ...',
        ),
      );
    }

    Widget provitujuan() {
      return DropdownSearch<Provinsi>(
        // enabled: (prov) {
        //   if (prov != null) {
        //     enableKabupaten = false;
        //   } else {
        //     enableKabupaten = true;
        //   }
        // },
        showClearButton: true,
        hint: 'Pilih Provinsi',
        onFind: (String filter) async {
          final response = await http.get(
            Uri.parse(Api.province),
            headers: {
              'key': Api.key,
            },
          );
          try {
            var data = jsonDecode(response.body) as Map<String, dynamic>;
            var status = data['rajaongkir']['status']['code'];
            if (status != 200) {
              throw data['rajaongkir']['status']['description'];
            }

            var listAllProvince =
                data['rajaongkir']['results'] as List<dynamic>;

            var models = Provinsi.fromJsonList(listAllProvince);
            return models;
          } catch (e) {
            return List<Provinsi>.empty();
          }
        },
        onChanged: (prov) {
          setState(
            () {
              if (prov != null) {
                enableKabupatenTujuan = false;
                provTujuanId = int.parse(prov.provinceId!);
                print(prov.province);
              } else {
                enableKabupatenTujuan = true;
                provTujuanId = 0;
              }
              showButton();
            },
          );
        },
        popupItemBuilder: (context, item, isSelected) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              '${item.province}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          );
        },
        itemAsString: (item) => item.province!,
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 25,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          hintText: 'Cari Provinsi ...',
        ),
      );
    }

    Widget kotaasal() {
      return DropdownSearch<Kota>(
        hint: 'Kabupaten / Kota',
        onFind: (String filter) async {
          final response = await http.get(
            Uri.parse(Api.city + '$provAsalId'),
            headers: {
              'key': Api.key,
            },
          );
          try {
            var data = jsonDecode(response.body) as Map<String, dynamic>;
            var status = data['rajaongkir']['status']['code'];
            if (status != 200) {
              throw data['rajaongkir']['status']['description'];
            }

            var listAllCity = data['rajaongkir']['results'] as List<dynamic>;

            var models = Kota.fromJsonList(listAllCity);
            return models;
          } catch (e) {
            return List<Kota>.empty();
          }
        },
        popupItemBuilder: (context, item, isSelected) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              '${item.type} ${item.cityName}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          );
        },
        itemAsString: (item) => item.cityName!,
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 25,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          hintText: 'Cari Kota / Kabupaten ...',
        ),
        showClearButton: true,
        onChanged: (city) {
          if (city != null) {
            kotaAsalId = int.parse(city.cityId!);
            print(city.cityName);
            // kotaTujuanId = int.parse(city.cityId!);
          } else {
            provAsalId = 0;
            // provTujuanId = 0;
          }
          showButton();
        },
      );
    }

    Widget kotaTujuan() {
      return DropdownSearch<Kota>(
        hint: 'Kabupaten / Kota',
        onFind: (String filter) async {
          final response = await http.get(
            Uri.parse(Api.city + '$provTujuanId'),
            headers: {
              'key': Api.key,
            },
          );
          try {
            var data = jsonDecode(response.body) as Map<String, dynamic>;
            var status = data['rajaongkir']['status']['code'];
            if (status != 200) {
              throw data['rajaongkir']['status']['description'];
            }

            var listAllCity = data['rajaongkir']['results'] as List<dynamic>;

            var models = Kota.fromJsonList(listAllCity);
            return models;
          } catch (e) {
            return List<Kota>.empty();
          }
        },
        popupItemBuilder: (context, item, isSelected) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              '${item.type} ${item.cityName}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          );
        },
        itemAsString: (item) => item.cityName!,
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 25,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          hintText: 'Cari Kota / Kabupaten ...',
        ),
        showClearButton: true,
        onChanged: (city) {
          if (city != null) {
            // kotaAsalId = int.parse(city.cityId!);
            kotaTujuanId = int.parse(city.cityId!);
            print(city.cityName);
          } else {
            // provAsalId = 0;
            provTujuanId = 0;
          }
          showButton();
        },
      );
    }

    Widget enableAsal() {
      return DropdownSearch(
        enabled: false,
        hint: 'Kabupaten / Kota',
      );
    }

    Widget enableTujuan() {
      return DropdownSearch(
        enabled: false,
        hint: 'Kabupaten / Kota',
      );
    }

    Widget courier() {
      return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: DropdownSearch<Map<String, dynamic>>(
          mode: Mode.MENU,
          showClearButton: true,
          items: [
            {
              "code": "jne",
              "name": "Jalur Nugraha Ekakurir (JNE)",
            },
            {
              "code": "tiki",
              "name": "Titipan Kilat (TIKI)",
            },
            {
              "code": "pos",
              "name": "Perusahaan Opsional Surat (POS)",
            },
          ],
          label: "Tipe Kurir",
          hint: "pilih tipe kurir...",
          onChanged: (value) {
            setState(() {
              if (value != null) {
                kurir = value['code'];
                print(value);
                showButton();
              } else {
                hiddenButton = true;
                kurir = "";
              }
            });
          },
          itemAsString: (item) => "${item['name']}",
          popupItemBuilder: (context, item, isSelected) => Container(
            padding: EdgeInsets.all(20),
            child: Text(
              "${item['name']}",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: 5,
          ),
          child: Text('Provinsi Asal'),
        ),
        provi(),
        SizedBox(
          height: 15,
        ),
        enableKabupatenAsal == true ? enableAsal() : kotaasal(),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: 5,
          ),
          child: Text('Provinsi Tujuan'),
        ),
        provitujuan(),
        SizedBox(
          height: 15,
        ),
        enableKabupatenTujuan == true ? enableTujuan() : kotaTujuan(),
        SizedBox(
          height: 10,
        ),
        Weight(
          weightController: _weightController,
        ),
        SizedBox(
          height: 15,
        ),
        // FloatingActionButton(
        //   // When the user presses the button, show an alert dialog containing the
        //   // text that the user has entered into the text field.
        //   onPressed: () {
        //     showDialog(
        //       context: context,
        //       builder: (context) {
        //         return AlertDialog(
        //           // Retrieve the text the user has entered by using the
        //           // TextEditingController.
        //           content: Text(_weightController.text),
        //         );
        //       },
        //     );
        //   },
        //   tooltip: 'Show me the value!',
        //   child: Icon(Icons.text_fields),
        // ),
        courier(),
        hiddenButton == true
            ? SizedBox()
            : Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () => ongkir(),
                  child: Text('Cek Ongkos Kirim'),
                  style: ElevatedButton.styleFrom(),
                ),
              ),
      ],
    );
  }
}
