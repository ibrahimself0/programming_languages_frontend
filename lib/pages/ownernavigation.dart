import 'package:app/pages/main_pages.dart';
import 'package:flutter/material.dart';

class OwnerNavBar extends StatefulWidget {
  const OwnerNavBar({super.key , required this.selectedPage});
  final int selectedPage;
  @override
  State<OwnerNavBar> createState() => _OwnerNavBarState();
}

class _OwnerNavBarState extends State<OwnerNavBar> {
  //  List<Widget> listWidget = [
  //   // HomeView(),
  //   // HomeSecondaryView(),
  //   // HomeTertiaryView(),
  //   ProfileView(),
  // ];
  @override
  Widget build(BuildContext context) {
  return Scaffold();
  }
}