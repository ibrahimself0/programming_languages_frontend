import 'package:flutter/material.dart';
import 'package:programming_languages_frontend/pages/start_page.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const AppEntry());
}

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  String? inputText;
  bool isActive = true;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartPage(),
      // https://bored-api.appbrewery.com/random
    );
  }
}
