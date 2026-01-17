import 'package:app/constants/app_colors.dart';
import 'package:app/data/notifiers.dart';
import 'package:flutter/material.dart';
import '../profile_page.dart';



import 'bookings_page.dart';
import 'messages_page.dart' ;
import 'home_page.dart';
class TenantNavBar extends StatefulWidget {
  const TenantNavBar({super.key , required this.selectedPage});
  final int selectedPage;
  @override
  State<TenantNavBar> createState() => _TenantNavBarState();
}

class _TenantNavBarState extends State<TenantNavBar> {
  List<Widget> listWidget = [
    HomePage(),
    //MessagesPage(),
    BookingPage(),
    ProfilePage(),
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
