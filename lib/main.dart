
import 'package:app/pages/providers.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/start_page.dart';
import 'package:provider/provider.dart';




void main() {
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApartmentProvider()),
       
      ],
      child:const AppEntry()));
}


class AppEntry extends StatefulWidget {
  const AppEntry({super.key});
  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  // String? inputText;
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
