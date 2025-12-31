import 'package:app/constants/app_colors.dart';
import 'package:app/data/notifiers.dart';
import 'package:app/pages/Tenant/favorite_page.dart';
import 'package:app/pages/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/general_service.dart';
import 'edit_profile_page.dart';
import 'launch/start_page.dart';







class ProfilePage extends StatelessWidget {
  void initState() {

  }
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40.0),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage("assets/images/err.png"),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  "Shrek",
                  style: TextStyle(fontSize: 16, color: AppColors.cyan),
                ),
                const SizedBox(height: 10.0),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.cyan,
                    ),
                  ),
                  trailing: const Icon(
                    color: AppColors.cyan,
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    "Favorite",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.cyan,
                    ),
                  ),
                  trailing: const Icon(
                    color: AppColors.cyan,
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoritePage(),
                      ),
                    );
                  },
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: AppColors.cyan,
                            title: Text(
                              "Warning",
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                            content: Text(
                              "Are You Sure?",
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  if(await logout()){
                                     Provider.of<ApartmentProvider>((context), listen: false).clear();
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => StartPage(),
                                      ),
                                          (route) => false,
                                    );
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 5),
                                          content: Text("Some Thin Went Wrong"),
                                          behavior: SnackBarBehavior.floating,
                                        ));
                                  }

                                },
                                child: Text(
                                  "yes",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
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
                          style: TextStyle(color: AppColors.cyan, fontSize: 20),
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
        );
      },
    );
  }
}

//edit
