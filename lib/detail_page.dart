import 'dart:convert';

import 'package:factbook_info/increment_provider.dart';
import 'package:factbook_info/providerTest.dart';
import 'package:factbook_info/timer_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Detail extends StatefulWidget {
  const Detail({Key? key, required this.name, required this.code})
      : super(key: key);
  final String name;
  final String code;

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  var countryName = '';
  var data = {};
  var newdata = {};
  var textStyle = const TextStyle(
      fontFamily: 'Montserrat',
      wordSpacing: 0.6,
      letterSpacing: 0.2,
      height: 1.5,
      fontWeight: FontWeight.bold);
  @override
  void initState() {
    super.initState();
    countryName = widget.name
        .replaceAll(" ", "_")
        .toLowerCase()
        .replaceAll("(", '')
        .replaceAll(")", "")
        .replaceAll(',', '')
        .replaceAll('-', '_');
  }

  Future<Object> getJsonData() async {
    var response = await http.get(
        // Encode Url to JSON
        Uri.parse(
            'https://raw.githubusercontent.com/iancoleman/cia_world_factbook_api/master/data/factbook.json'),
        // accept JSON
        headers: {"Accept": "application/json"});
    var convert = json.decode(response.body);
    data = convert;
    return data;
  }

  // https://www.cia.gov/the-world-factbook/page-data/countries/$countryName/page-data.json

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.name, style: const TextStyle(fontFamily: 'Montserrat')),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider(create: (context) => TimerInfo()),
                      ChangeNotifierProvider(
                          create: (context) => IncrementProvider())
                    ],
                    child: const Test(),
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: ListView(
        children: [
          FutureBuilder<Object>(
            future: getJsonData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const Center(
                      child: CircularProgressIndicator(color: Colors.black)),
                );
              } else if (snapshot.hasError) {
                return const Text('Error...');
              } else {
                // print(data['countries'][countryName]['data'].keys);
                return Column(
                    children: child(data['countries'][countryName], 'data'));
              }
            },
          ),
        ],
      ),
    );
  }

  child(data, e) {
    return data[e].runtimeType != String &&
            data[e].runtimeType != List &&
            data[e].runtimeType != int &&
            data[e].runtimeType != double &&
            data[e].runtimeType != bool &&
            data[e].runtimeType != Null
        ? data[e]
            .keys
            .map<Widget>(
              (newKey) => Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ExpansionTile(
                  title: Text(
                    "${newKey[0].toUpperCase()}${newKey.substring(1)}",
                    style: const TextStyle(fontFamily: 'Montserrat'),
                  ),
                  children: child(data[e], newKey),
                ),
              ),
            )
            .toList()
        : [
            data[e].runtimeType != List
                ? Container(
                    padding:
                        const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: data[e].runtimeType == String
                        ? Text(
                            '${data[e].length != 0 ? data[e][0].toUpperCase() : ''}${data[e].length != 0 ? data[e].substring(1) : ''}',
                            style: textStyle)
                        : Text(data[e].toString(), style: textStyle),
                  )
                : data[e].length > 0
                    ? Column(
                        children: data[e]
                            .map<Widget>((columnData) => (columnData.length ==
                                        3 ||
                                    columnData.length == 2 ||
                                    columnData.length == 1
                                ? columnData.runtimeType == String
                                    ? Text('$columnData')
                                    : repeat(columnData)
                                : Text(
                                    '${columnData[0].toString().toUpperCase()}${columnData.toString().substring(1)}',
                                    style: textStyle)))
                            .toList())
                    : Text('${data[e][0]}', style: textStyle)
          ];
  }

  Text repeat(columnData) {
    var set = [];
    columnData.keys.forEach((data) => set.add(data));
    // print(set);
    if (set.length == 1) {
      return Text(
        '${set[0][0].toUpperCase()}${set[0].substring(1)} : ${columnData[set[0]]}',
        style: textStyle,
      );
    } else if (set.length == 2) {
      return Text(
        '${set[0][0].toUpperCase()}${set[0].substring(1)} : ${columnData[set[0]]} ; ${set[1][0].toUpperCase()}${set[1].substring(1)} : ${columnData[set[1]]}',
        style: textStyle,
      );
    } else if (set.length == 3) {
      return Text(
        '${set[0][0].toUpperCase()}${set[0].substring(1)} : ${columnData[set[0]]} ; ${set[1][0].toUpperCase()}${set[1].substring(1)} : ${columnData[set[1]]} ; ${set[2][0].toUpperCase()}${set[2].substring(1)} : ${columnData[set[2]] != int && columnData[set[2]] != String && columnData[set[2]] != bool ? columnData[set[2]].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('{', '(').replaceAll('}', ')') : columnData[set[2]]}',
        style: textStyle,
      );
    } else {
      return Text(
        '$columnData',
        style: textStyle,
      );
    }
  }
}
