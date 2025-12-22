import 'dart:io';

import 'package:app/constants/app_colors.dart';
import 'package:app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/api_response.dart';
import 'navigation.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key, required this.role});
  final String role;
  @override
  State<SignIn> createState() => _SignInState();
}

final TextEditingController firstNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController dateOfBirthController = TextEditingController();
final TextEditingController phoneNumberController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

File? profileImage;
File? identityImage;

GlobalKey<FormState> Signtate = GlobalKey();

class _SignInState extends State<SignIn> {
  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> pickIdentityImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        identityImage = File(pickedFile.path);
      });
    }
  }
  Future<void> pickDateOfBirth(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dateOfBirthController.text =
        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tenant"),
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
                  return null;
                },
                controller: firstNameController,
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
                  return null;
                },
                controller: lastNameController,
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
                onTap: () {
                  pickDateOfBirth(context);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "enter your DateOfBirth";
                  }
                  return null;
                },
                controller: dateOfBirthController,

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
              Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      pickProfileImage();
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
                      "ProfileImage",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  MaterialButton(
                    onPressed: () {
                      pickIdentityImage();
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
                      "IdentityImage",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              MaterialButton(
                onPressed: () async {
                  if (Signtate.currentState!.validate() && profileImage != null && identityImage !=null ) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SigninPage2(role: widget.role),
                      ),
                    );
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 5),
                          content: Text("Don't forget to enter images"),
                          behavior: SnackBarBehavior.floating,
                        ));
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
                  "Next",
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

class SigninPage2 extends StatefulWidget {
  const SigninPage2({super.key, required this.role});
  final String role;

  @override
  State<SigninPage2> createState() => _SigninPage2State();
}

class _SigninPage2State extends State<SigninPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tenant"),
        foregroundColor: AppColors.cyan,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: AppColors.primaryColor,
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "enter your number";
                  }
                  return null;
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
                  return null;
                },
                controller: passwordController,
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
                onPressed: () async {
                  print("CONFIRM PRESSED 1 ");

                  if (Signtate.currentState!.validate()) {
                    ApiResponse response = await register(
                      phoneNumber: phoneNumberController.text,
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      dateOfBirth: dateOfBirthController.text,
                      role: widget.role,
                      password: passwordController.text,
                      profileImage: profileImage!,
                      identityImage: identityImage!

                    );
                    if (response.error == null) {
                      print("CONFIRM PRESSED 2 ");

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const NavBar(selectedPage: 0),
                        ),
                      );
                    } else {
                      print("CONFIRM PRESSED 3");

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 5),
                          content: Text(response.error.toString()),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
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
