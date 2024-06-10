// ignore_for_file: unnecessary_set_literal

import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:eserlerproject/imageLook.dart';
import 'package:eserlerproject/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class apiPage extends StatefulWidget {
  @override
  State<apiPage> createState() => _apiPageState();
}

class _apiPageState extends State<apiPage> {
  List<dynamic> _jsonData = [];
  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://api.npoint.io/37ae95fba394760493b1'));
    if (response.statusCode == 200) {
      setState(() {
        _jsonData = jsonDecode(response.body);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLanguage().whenComplete(() {
      fetchData();
      _checkDarkMode();
    });
  }

  bool darkMode = false;
  Future<void> _checkDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('darkModeControl') ?? false;

    if (seen) {
      setState(() {
        darkMode = true;
      });
    } else {
      // await prefs.setBool('darkModeControl', false);
      setState(() {
        darkMode = false;
      });
    }
  }

  Future<void> _changeDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('darkModeControl') ?? false;

    if (seen) {
      setState(() {
        darkMode = false;
      });
      await prefs.setBool('darkModeControl', false);
    } else {
      await prefs.setBool('darkModeControl', true);
      setState(() {
        darkMode = true;
      });
    }
  }

  bool languageTr = true;
  Future<void> _checkLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('languageControl') ?? true;
    if (seen) {
      setState(() {
        languageTr = true;
      });
    } else {
      setState(() {
        languageTr = false;
      });
    }
    print("DİL=" + languageTr.toString());
  }

  Future<void> _changedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('languageControl') ?? true;
    if (seen) {
      await prefs.setBool('languageControl', false);
      setState(() {
        languageTr = false;
      });
    } else {
      await prefs.setBool('languageControl', true);
      setState(() {
        languageTr = true;
      });
    }
    print("DİL=" + languageTr.toString());
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          darkMode ? ThemeData.dark().primaryColorLight : Colors.white,
      appBar: AppBar(
        //255,37, 150, 190
        backgroundColor: darkMode
            ? ThemeData.dark().primaryColorDark
            : Color.fromARGB(255, 96, 215, 236),
        title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  languageTr
                      ? "DÜNYADAN ESERLER"
                      : "WORKS OF ART FROM THE WORLD",
                  style: GoogleFonts.cinzel(
                      fontSize: 25, color: Color.fromARGB(255, 239, 255, 222)),
                ),
                SizedBox(
                  width: 30,
                ),
                InkWell(
                  onTap: () {
                    _changedLanguage();
                  },
                  child: languageTr
                      ? Image.asset(
                          "assets/images/enFlag.png",
                          height: 30,
                          width: 30,
                        )
                      : Image.asset(
                          "assets/images/trFlag.png",
                          height: 30,
                          width: 30,
                        ),
                ),
                  SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    _changeDarkMode();
                  },
                  child: Icon(Icons.dark_mode),
                )
              ],
            )),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: _jsonData.length,
          itemBuilder: (context, index) {
            return FadeInRight(
                duration: Duration(milliseconds: 1500),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      //color: Color.fromARGB(255, 241, 236, 222),
                      color: darkMode
                          ? ThemeData.dark().primaryColorDark
                          : Color.fromARGB(255, 241, 236, 222)),
                  margin:
                      EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 340,
                  child: Column(children: [
                    BounceInLeft(
                        from: 100,
                        // duration: Duration(milliseconds: 1500),
                        child: Text(
                            languageTr
                                ? _jsonData[index]["name"]
                                : _jsonData[index]["nameEn"],
                            style: GoogleFonts.pacifico(
                                color: darkMode
                                    ? ThemeData.dark().primaryColor
                                    : Color.fromARGB(255, 53, 131, 142),
                                fontSize: 23))),
                    Column(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  //Sayfa yönlendirme(Resme tıkladıgında büyük boyutlu görünmesi için diğer sayfaya resmin url sini parametre olarak gönderir )
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => pageImage(
                                          _jsonData[index]["imageURL"])));
                            },
                            child: Container(
                              color: Colors.amber,
                              margin: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              height: 170,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: FutureBuilder(
                                    future: DefaultCacheManager().getSingleFile(
                                        _jsonData[index]["imageURL"]),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (snapshot.hasData) {
                                          return Image.file(
                                            snapshot.data as File,
                                            fit: BoxFit.fill,
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              "Error: ${snapshot.error}");
                                        }
                                      }
                                      return CircularProgressIndicator();
                                    },
                                  )),
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //bura
                            Container(
                                //Http apiden gelen her verinin açıklama kısmı
                                width: MediaQuery.of(context).size.width - 15,
                                height: 90,
                                child: Text(
                                    languageTr
                                        ? _jsonData[index]["explane"]
                                        : _jsonData[index]["explaneEn"],
                                    style: GoogleFonts.asap(
                                        color: darkMode
                                            ? ThemeData.dark().primaryColor
                                            : Color.fromARGB(255, 40, 55, 68),
                                        fontSize: 17))),
                          ],
                        )
                      ],
                    )
                  ]),
                ));
          },
        ),
      ),
    );
  }
}
