import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:programming_languages_frontend/constants/app_colors.dart';
import 'package:programming_languages_frontend/pages/user_selection_page.dart';

import '../data/notifiers.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();

    isDarkModeNotifier.value = false;
    AppColors.primaryColor = Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lotties/BlueHouse.json'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 18,
                ),
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color:Colors.white,
                ),
                backgroundColor: AppColors.cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                shadowColor: AppColors.darkCyan,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserSelectionPage(),
                  ),
                );
              },
              child: Text(
                "Get Started",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppColors.fontSize / 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}