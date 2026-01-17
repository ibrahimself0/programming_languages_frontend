import 'dart:io';
import 'package:app/services/general_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/constants/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? imageFile;
  final ImagePicker picker = ImagePicker();
  Map<String, String> edit = {};
  Future<void> pickImage() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Widget buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.cyan,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile Image"),
        foregroundColor: AppColors.cyan,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundColor: AppColors.cyan,
              backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
              child: imageFile == null
                  ? Icon(Icons.person, size: 70, color: AppColors.cyan)
                  : null,
            ),

            const SizedBox(height: 20),

            buildButton("Choose Image", pickImage),
            const SizedBox(height: 10),
            buildButton("Confirm", () async {
              edit["profile_image"] = imageFile!.path;
              editProfile(await getToken(), imageFile);
            }),
          ],
        ),
      ),
    );
  }
}
