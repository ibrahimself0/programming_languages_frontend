import 'package:flutter/material.dart';
import 'start_page.dart';

import '../constants/app_colors.dart';
import '../data/notifiers.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("assets/images/err.png"),
              ),
              const Text(
                "Shrek",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Spacer(flex: 5),

              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: AppColors.primaryColor,
                        title: Text(
                          "Warning",
                          style: TextStyle(color: AppColors.cyan),
                        ),
                        content: Text(
                          "Are You Sure?",
                          style: TextStyle(color: AppColors.cyan),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const StartPage(),
                                ),
                                    (route) => false,
                              );
                            },
                            child: Text(
                              "Yes",
                              style: TextStyle(color: AppColors.cyan),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Log Out",
                      style: TextStyle(color: AppColors.cyan, fontSize: 20),
                    ),
                    Icon(
                      Icons.logout_outlined,
                      color: AppColors.cyan,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//edit
