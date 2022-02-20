import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:factbook_info/country_code_model.dart';
import 'package:factbook_info/increment_provider.dart';
import 'package:factbook_info/timer_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:factbook_info/detail_page.dart';
import 'package:http/http.dart' as http;
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int numsum = 122;
  var countryList = [];
  dynamic data;
  List<CountryCodes> countryCodeData = [];
  var searchQuery = '';
  var connection = false;

  Future<List> getJson() async {
    var jsonData = await rootBundle.loadString('assets/country_list.json');
    var convert = json.decode(jsonData);
    countryList = convert;

    if (connection == true) {
      var newresponse = await http.get(
          // Encode Url to JSON
          Uri.parse(
              'https://www.cia.gov/the-world-factbook/page-data/references/country-data-codes/page-data.json'),
          // accept JSON
          headers: {"Accept": "application/json"});
      var newconvert = await json.decode(newresponse.body);
      var newjson =
          await json.decode(newconvert['result']['data']['page']['json']);
      countryCodeData = [];
      await newjson['country_codes'].forEach((e) {
        countryCodeData.add(CountryCodes.fromJson(e)); // adding json to list
      });
    }
    // print(countryCodeData);
    return countryCodeData;
  }

  // https://flagpedia.net/data/flags/h160/np.png
  var shouldNotBeOnTheList = [
    'Baker Island',
    'Bassas da India',
    "Cote d'lvoire",
    'Europa Island',
    'France, Metropolitan',
    'French Guiana',
    'French Southern and Antarctic Lands',
    'Glorioso Islands',
    'Guadeloupe',
    'Howland Island',
    'Jarvis Island',
    'Johnston Atoll',
    'Juan de Nova Island',
    'Kingman Reef',
    'Martinique',
    'Mayotte',
    'Midway Islands',
    'Netherlands Antilles',
    'Palmyra Atoll',
    'Reunion',
    'South Georgia and the Islands',
    'Timor-Leste',
    'Tromelin Island',
    'United States Minor Outlying Islands',
    'Virgin Islands (UK)',
    'Virgin Islands (US)',
    'Western Samoa',
    'Zaire',
    'Myanmar',
    'Akrotiri',
    'Ashmore and Cartier Islands',
    'Clipperton Island',
    'Coral Sea Islands',
    'Dhekelia',
    'Jan Mayen',
    'Navassa Island',
    'Paracel Islands',
    'Spratly Islands',
    'Wake Island',
  ];
  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        connection = true;
      });
      // print('Connected to a Wi-Fi network');
    } else if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        connection = true;
      });
      // print('Connected to a mobile network');
    } else {
      setState(() {
        connection = false;
      });
      // print('Not connected to any network');
    }
    return connection;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              connection == false
                  ? const Center(
                      child: Text('No internet connection',
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'Montserrat')),
                    )
                  : FutureBuilder<List>(
                      future: getJson(),
                      builder: (context, snapshot) {
                        // print(countryCodeData.length);
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.black,
                          ));
                        } else if (snapshot.hasError) {
                          return const Text('Error...');
                        } else {
                          return CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                // pinned: true,
                                // stretch: true,
                                expandedHeight: 100,
                                // snap: true,
                                elevation: 10,
                                // shape: ShapeBorder(),
                                floating: true,
                                flexibleSpace: FlexibleSpaceBar(
                                    centerTitle: true,
                                    title: const Text('World FactBook',
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontFamily: 'Montserrat')),
                                    background: Image.asset(
                                      'images/worldglow.png',
                                      fit: BoxFit.cover,
                                    )),
                                backgroundColor: Colors.black,
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    if (shouldNotBeOnTheList.contains(
                                        countryCodeData[index].entity)) {
                                      return const SizedBox();
                                    } else {
                                      if (searchQuery != '') {
                                        searchQuery = searchQuery.toLowerCase();
                                        if (countryCodeData[index]
                                            .entity!
                                            .toLowerCase()
                                            .contains(searchQuery)) {
                                          return listTile(
                                            index,
                                            countryCodeData[index].entity,
                                            countryCodeData[index].isoCode1 ==
                                                    null
                                                ? ''
                                                : countryCodeData[index]
                                                    .isoCode1!
                                                    .toLowerCase(),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      } else {
                                        return listTile(
                                          index,
                                          countryCodeData[index].entity,
                                          countryCodeData[index].isoCode1 ==
                                                  null
                                              ? ''
                                              : countryCodeData[index]
                                                  .isoCode1!
                                                  .toLowerCase(),
                                        );
                                      }
                                    }
                                  },
                                  childCount: countryCodeData.length,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
              // buildFloatingSearchBar()
            ],
          )),
    );
  }

  Container listTile(index, name, code) {
    return Container(
      margin: index == 0
          ? const EdgeInsets.fromLTRB(10, 20, 10, 10)
          : const EdgeInsets.fromLTRB(10, 0, 10, 10),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        // border: Border.all(width: 0.5, color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 0)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0),
        child: TextButton(
          style: TextButton.styleFrom(primary: Colors.grey.shade700),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => TimerInfo(),
                    ),
                    ChangeNotifierProvider(
                        create: (context) => IncrementProvider())
                  ],
                  child: Detail(name: name, code: code),
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              name != "World"
                  ? SizedBox(
                      width: 50,
                      height: 50,
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://flagpedia.net/data/flags/h160/$code.png",
                        placeholder: (context, url) =>
                            Image.asset('images/loader.gif', fit: BoxFit.cover),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    )
                  : const SizedBox(
                      width: 50, height: 50, child: Icon(Icons.error)),
              const SizedBox(width: 30),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600),
                  // textScaleFactor: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      hintStyle: const TextStyle(fontFamily: 'Montserrat'),
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      backdropColor: Colors.grey.shade300,
      onFocusChanged: (active) {
        setState(() {
          // isActiveSearchBar = active;
        });
      },
      onQueryChanged: (query) {
        setState(() {
          searchQuery = query;
        });
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return Container();
      },
    );
  }
}
