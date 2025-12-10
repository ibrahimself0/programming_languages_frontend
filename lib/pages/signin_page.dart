import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController pictureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
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
                fillColor: Colors.white,
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
                fillColor: Colors.white,
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
                fillColor: Colors.white,
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
          ],
        ),
      ),
    );
  }
}
