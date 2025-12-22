// import 'main_pages.dart';
import 'package:app/constants/app_colors.dart';
import 'package:app/data/notifiers.dart';
import 'package:app/pages/profile_page.dart';
import 'package:flutter/material.dart';


import 'my_apartment.dart';


class OwnerNavBar extends StatefulWidget {
  const OwnerNavBar({super.key , required this.ownerselectedPage});
  final int ownerselectedPage;
  @override
  State<OwnerNavBar> createState() => _OwnerNavBarState();
}

class _OwnerNavBarState extends State<OwnerNavBar> {
   List<Widget> listWidget = [
    // HomeView(),
    // HomeSecondaryView(),
    MyApartments(),
    ProfilePage(),
  ];
   late int ownerselectedIndex = widget.ownerselectedPage;
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
            child: listWidget.elementAt(ownerselectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: ownerselectedIndex,
            onTap: (value) {
              setState(() {
                ownerselectedIndex = value;
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
                label: "MyApartment",
              ),
              BottomNavigationBarItem(
                backgroundColor: AppColors.primaryColor,
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