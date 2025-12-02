import 'package:flutter/material.dart';
import 'package:programming_languages_frontend/pages/start_page.dart';

import '../constants/app_colors.dart';
import 'home_views.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Widget> listWidget = [
    HomeView(),
    HomeSecondaryView(),
    HomeTertiaryView(),
    ProfileView(),
  ];

  int selectedIndex = 0;
  bool isDarkMode = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        foregroundColor: AppColors.fontColorPrimary,
        backgroundColor: AppColors.primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("APP", style: TextStyle(color: AppColors.fontColorPrimary)),
          ],
        ),
      ),
      drawer: Drawer(
        elevation: 100,
        surfaceTintColor: AppColors.fontColorPrimary,
        shadowColor: AppColors.fontColorPrimary,
        backgroundColor: AppColors.primaryColor,
        child: Column(
          children: [
            SwitchListTile(
              inactiveTrackColor: AppColors.fontColorPrimary,
              activeThumbColor: AppColors.fontColorPrimary,
              secondary: const Icon(Icons.dark_mode),
              title: Text(
                "Dark Mode",
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.fontColorPrimary,
                ),
              ),
              value: isDarkMode,
              onChanged: (val) {
                setState(() {
                  isDarkMode = val;
                  if (isDarkMode) {
                    AppColors.primaryColor = Colors.black;
                    AppColors.fontColorPrimary = Colors.red;
                  } else {
                    AppColors.primaryColor = Colors.white;
                    AppColors.fontColorPrimary = Colors.blue;
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
                        title: Text(
                          "Warning",
                          style: TextStyle(color: AppColors.fontColorPrimary),
                        ),
                        content: Text(
                          "Are You Sure?",
                          style: TextStyle(color: AppColors.fontColorPrimary),
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
                              style: TextStyle(color: AppColors.fontColorPrimary),
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
                      style: TextStyle(
                        color: AppColors.fontColorPrimary,
                        fontSize: 20,
                      ),
                    ),
                    Icon(
                      Icons.logout_outlined,
                      color: AppColors.fontColorPrimary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: listWidget.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        selectedItemColor: AppColors.fontColorPrimary,
        unselectedItemColor: AppColors.fontColorPrimary,
        selectedFontSize: 20,
        backgroundColor: AppColors.primaryColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: AppColors.fontColorPrimary,
            icon: Icon(Icons.home, color: AppColors.fontColorPrimary),
            label: "Home",
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColors.primaryColor,
            icon: Icon(Icons.email, color: AppColors.fontColorPrimary),
            label: "Message",
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColors.primaryColor,
            icon: Icon(Icons.history, color: AppColors.fontColorPrimary),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColors.fontColorPrimary,
            icon: Icon(Icons.person, color: AppColors.fontColorPrimary),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
