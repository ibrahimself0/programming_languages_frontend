import 'package:flutter/material.dart';
import 'profile_view.dart';


import '../constants/app_colors.dart';
import '../data/notifiers.dart';
import 'bookings_view.dart';
import 'home_second_view.dart';
import 'home_view.dart';
class NavBar extends StatefulWidget {
  const NavBar({super.key , required this.selectedPage});
  final int selectedPage;
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List<Widget> listWidget = [
    HomeView(),
    HomeSecondaryView(),
    HomeTertiaryView(),
    ProfileView(),
  ];

  late int selectedIndex = widget.selectedPage;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
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
