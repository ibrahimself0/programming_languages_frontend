import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'start_page.dart';
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.cyan,
        backgroundColor: AppColors.primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Home", style: TextStyle(color: AppColors.cyan)),
            SizedBox(
              width: 150,
              height: 40,
              child: SearchBar(hintText: "Search"),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        elevation: 100,
        surfaceTintColor: AppColors.cyan,
        shadowColor: AppColors.cyan,
        backgroundColor: AppColors.primaryColor,
        child: Column(
          children: [
            SwitchListTile(
              inactiveTrackColor: AppColors.cyan,
              activeThumbColor: AppColors.cyan,
              secondary: Icon(Icons.dark_mode),
              title: Text(
                "Dark Mode",
                style: TextStyle(fontSize: 20, color: AppColors.cyan),
              ),
              value: isDarkMode,
              onChanged: (val) {
                setState(() {
                  isDarkMode = val;
                  if (isDarkMode) {
                    AppColors.primaryColor = Colors.black;
                    AppColors.cyan = Colors.red;
                  } else {
                    AppColors.primaryColor = Colors.white;
                    AppColors.cyan = Colors.blue;
                  }
                });
              },
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: AppColors.primaryColor,
                        title: Text("Warning", style: TextStyle(color: AppColors.cyan)),
                        content: Text("Are You Sure?", style: TextStyle(color: AppColors.cyan)),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => StartPage()),
                                    (route) => false,
                              );
                            },
                            child: Text("Yes", style: TextStyle(color: AppColors.cyan)),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("LogOut", style: TextStyle(color: AppColors.cyan, fontSize: 20)),
                    Icon(Icons.logout_outlined, color: AppColors.cyan, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeSecondaryView extends StatefulWidget {
  const HomeSecondaryView({super.key});

  @override
  State<HomeSecondaryView> createState() => _HomeSecondaryViewState();
}

class _HomeSecondaryViewState extends State<HomeSecondaryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class HomeTertiaryView extends StatefulWidget {
  const HomeTertiaryView({super.key});

  @override
  State<HomeTertiaryView> createState() => _HomeTertiaryViewState();
}

class _HomeTertiaryViewState extends State<HomeTertiaryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
    );
  }
}
