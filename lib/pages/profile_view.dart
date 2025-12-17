import 'package:flutter/material.dart';
import 'package:programming_languages_frontend/pages/edit_profile_view.dart';

import '../constants/app_colors.dart';
import '../data/notifiers.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

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
                const SizedBox(height: 40.0,),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage("assets/images/err.png"),
                ),
                const SizedBox(height: 10.0,),
                const Text(
                  "Shrek",
                  style: TextStyle(fontSize: 16, color: AppColors.cyan),
                ),
                const SizedBox(height: 10.0,),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: AppColors.cyan),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage(),));
                  },
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
