import 'package:app/constants/app_colors.dart';
import 'package:app/data/notifiers.dart';
import 'package:app/models/api_response.dart';
import 'package:app/pages/Tenant/favorite_page.dart';
import 'package:app/pages/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/profile.dart';
import '../services/general_service.dart';
import 'Launch/signin_page.dart';
import 'edit_profile_page.dart';
import 'launch/start_page.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, value, child) {
        return Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
            final profile = profileProvider.profile;
            return Scaffold(
              backgroundColor: AppColors.primaryColor,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40.0),
                    if (profile != null)
                      ClipOval(
                        child: Image.network(
                          profile.profileImageUrl,
                          width: 240,
                          height: 240,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      const CircularProgressIndicator(),
                    const SizedBox(height: 10.0),
                    Text(
                      profile != null
                          ? '${profile.firstName} ${profile.lastName}'
                          : '',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.cyan,
                      ),
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
                        Icons.chevron_right,
                        color: AppColors.cyan,
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
                        Icons.chevron_right,
                        color: AppColors.cyan,
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
                    const Spacer(),
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
                                  style:
                                  TextStyle(color: AppColors.primaryColor),
                                ),
                                content: Text(
                                  "Are You Sure?",
                                  style:
                                  TextStyle(color: AppColors.primaryColor),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      if (await logout()) {
                                        Provider.of<ApartmentProvider>(
                                          context,
                                          listen: false,
                                        ).clear();
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) => StartPage(),
                                          ),
                                              (route) => false,
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration: const Duration(seconds: 5),
                                            content: const Text(
                                                "Something Went Wrong"),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      "Yes",
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
                              style: TextStyle(
                                  color: AppColors.cyan, fontSize: 20),
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
      },
    );
  }
}
