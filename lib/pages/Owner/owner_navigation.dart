import 'package:app/constants/app_colors.dart';
import 'package:app/data/notifiers.dart';
import 'package:app/pages/profile_page.dart';
import 'package:flutter/material.dart';

import 'ReservationsPage.dart';
import 'my_apartment.dart';

class OwnerNavBar extends StatefulWidget {
  const OwnerNavBar({super.key, required this.ownerSelectedPage});
  final int ownerSelectedPage;
  @override
  State<OwnerNavBar> createState() => _OwnerNavBarState();
}

class _OwnerNavBarState extends State<OwnerNavBar> {
  List<Widget> listWidget = [
    MyApartments(),
    ReservationsPage(),
    ProfilePage(),
  ];
  late int ownersSelectedIndex = widget.ownerSelectedPage;
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
              children: [Text("APP", style: TextStyle(color: AppColors.cyan))],
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(5),
            child: listWidget.elementAt(ownersSelectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: ownersSelectedIndex,
            onTap: (value) {
              setState(() {
                ownersSelectedIndex = value;
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
                backgroundColor: AppColors.cyan,
                icon: Icon(Icons.data_thresholding, color: AppColors.cyan),
                label: "Reservations",
              ),
              BottomNavigationBarItem(
                backgroundColor: AppColors.primaryColor,
                icon: Icon(Icons.person, color: AppColors.cyan),
                label: "Profile",
              ),
            ],
          ),
        );
      },
    );
  }
}
