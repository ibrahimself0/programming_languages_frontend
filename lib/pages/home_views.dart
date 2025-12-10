import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
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
