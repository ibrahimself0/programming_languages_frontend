import 'package:flutter/material.dart';
import 'package:programming_languages_frontend/pages/signin_page.dart';

import '../constants/app_colors.dart';
import 'home_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              controller: phoneController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: AppColors.cyan),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone, color: AppColors.cyan),
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
                hintText: "Phone Number",
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(color: AppColors.cyan),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, color: AppColors.cyan),
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
                hintText: "Password",
              ),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Homepage()),
                );
              },
              color: AppColors.cyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Confirm",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    );
                  },
                  color: AppColors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
