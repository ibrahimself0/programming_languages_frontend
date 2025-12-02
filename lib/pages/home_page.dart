import 'package:flutter/material.dart';
import 'package:programming_languages_frontend/pages/start_page.dart';

import '../constants/app_colors.dart';
import '../data/notifiers.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, value, child) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            foregroundColor: AppColors.cyan,
            backgroundColor: AppColors.primaryColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("APP", style: TextStyle(color: AppColors.cyan)),
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
                  secondary: const Icon(Icons.dark_mode),
                  title: Text(
                    "Dark Mode",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.cyan,
                    ),
                  ),
                  value: isDarkModeNotifier.value,
                  onChanged: (val) {
                    setState(() {
                      isDarkModeNotifier.value = val;
                      if (isDarkModeNotifier.value) {
                        AppColors.primaryColor = Colors.black;
                      } else {
                        AppColors.primaryColor = Colors.white;
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
                          style: TextStyle(
                            color: AppColors.cyan,
                            fontSize: 20,
                          ),
                        ),
                        Icon(
                          Icons.logout_outlined,
                          color: AppColors.cyan,
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
            selectedItemColor: AppColors.cyan,
            unselectedItemColor: AppColors.cyan,
            selectedFontSize: 20,
            backgroundColor: AppColors.primaryColor,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                backgroundColor: AppColors.cyan,
                icon: Icon(Icons.home, color: AppColors.cyan),
                label: "Home",
              ),
              BottomNavigationBarItem(
                backgroundColor: AppColors.primaryColor,
                icon: Icon(Icons.email, color: AppColors.cyan),
                label: "Message",
              ),
              BottomNavigationBarItem(
                backgroundColor: AppColors.primaryColor,
                icon: Icon(Icons.history, color: AppColors.cyan),
                label: "Bookings",
              ),
              BottomNavigationBarItem(
                backgroundColor: AppColors.cyan,
                icon: Icon(Icons.person, color: AppColors.cyan),
                label: "Profile",
              ),
            ],
          ),
        );
      }
    );
  }
}
