
import 'package:app/pages/start_page.dart';
import 'package:app/services/user_service.dart';
import 'package:flutter/material.dart';

import 'navigation.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void checkUserHasToken()async{
    String token = await getToken();
    if(token == ''){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StartPage(),
          ));
    }else{
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                NavBar(selectedPage: 0),
          ));
    }

  }
  @override
  void initState() {
    super.initState();
    checkUserHasToken();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.cyan,
      ),

    );
  }
}
