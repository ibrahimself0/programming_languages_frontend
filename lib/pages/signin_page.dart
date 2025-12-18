import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'navigation.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController datePfbirthController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> Signtate = GlobalKey();
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
        child: Form(
          key: Signtate,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                 validator: (value) {
                  if (value!.isEmpty) {
                    return "enter your firstname";
                  }
                },
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
              TextFormField(
                 validator: (value) {
                  if (value!.isEmpty) {
                    return "enter your Lastname";
                  }
                },
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
              TextFormField(
                 validator: (value) {
                  if (value!.isEmpty) {
                    return "enter your DateOfBirth";
                  }
                },
                controller: datePfbirthController,
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
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "enter your number";
                  }
                },
                controller: phoneNumberController,
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
              const SizedBox(height: 10),
              TextFormField(
                 validator: (value) {
                  if (value!.isEmpty) {
                    return "enter your password";
                  }
                },
                controller: passwordController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: AppColors.cyan),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password, color: AppColors.cyan),
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
              MaterialButton(
                onPressed: () {
                  if (Signtate.currentState!.validate()) {
                     Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NavBar(selectedPage: 0),
                      ),
                    );
                  }
                  
                },
                color: AppColors.cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
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
      ),
    );
  }
}
