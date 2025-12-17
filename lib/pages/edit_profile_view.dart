import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'navigation.dart';
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController pictureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.cyan,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: AppColors.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: firstNameController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: AppColors.cyan),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person, color: AppColors.cyan),
                filled: true,
                fillColor: AppColors.primaryColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.cyan),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.cyan, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: TextStyle(color: AppColors.cyan),
                hintText: "First Name",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: lastNameController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: AppColors.cyan),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person, color: AppColors.cyan),
                filled: true,
                fillColor: AppColors.primaryColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.cyan),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.cyan, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: TextStyle(color: AppColors.cyan),
                hintText: "Last Name",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dobController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: AppColors.cyan),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.calendar_today, color: AppColors.cyan),
                filled: true,
                fillColor: AppColors.primaryColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.cyan),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.cyan, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: TextStyle(color: AppColors.cyan),
                hintText: "Date OF Birth",
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return NavBar(selectedPage: 3);
                  }
                ));
              },
              color: AppColors.cyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Confirm",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
