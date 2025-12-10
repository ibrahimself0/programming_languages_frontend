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
  bool state = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            centerTitle: true,
            title: Text("Application",style: TextStyle(color: AppColors.cyan),),
            bottom: TabBar(
              dividerColor: AppColors.primaryColor,
              labelColor: AppColors.cyan,
              indicatorColor: AppColors.cyan,
              tabs: const [
                Tab(icon: Icon(Icons.home), text: "Home"),
                Tab(icon: Icon(Icons.email), text: "Message"),
                Tab(icon: Icon(Icons.history), text: "Booking"),
                Tab(icon: Icon(Icons.person), text: "Profile"),
              ],
            ),
          ),
          body: TabBarView(
            children: const [
              HomeView(),
              HomeSecondaryView(),
              HomeTertiaryView(),
              ProfileView(),
            ],
          ),
          drawer: Drawer(
            elevation: 100,
            //If we want to make the drawer color more cyanny
            //surfaceTintColor: AppColors.cyan,
            shadowColor: AppColors.cyan,
            backgroundColor: AppColors.primaryColor,
            child: Column(
              children: [
                SwitchListTile(
                  inactiveTrackColor: AppColors.cyan,
                  activeTrackColor: AppColors.darkCyan,
                  secondary: const Icon(Icons.dark_mode),
                  title: Text(
                    "Dark Mode",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.cyan,
                    ),
                  ),
                  value: state,
                  onChanged: (val) {
                    setState(() {
                      state = val;
                      if (state) {
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
                              style: TextStyle(
                                color: AppColors.cyan,
                              ),
                            ),
                            content: Text(
                              "Are You Sure?",
                              style: TextStyle(
                                color: AppColors.cyan,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  AppColors.primaryColor = Colors.white;
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const StartPage(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                    color: AppColors.cyan,
                                  ),
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
                          "LogOut",
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
        ),
      ),
    );
  }
}
