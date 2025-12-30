import 'package:app/constants/app_colors.dart';
import 'package:app/models/api_response.dart';
import 'package:app/pages/Owner/owner_navigation.dart';
import 'package:app/pages/error_page.dart';
import 'package:app/pages/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/general_service.dart';
import 'user_selection_page.dart';

import '../Tenant/tenant_navigation.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passwordHidden = true;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> loginstate = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Form(
          key: loginstate,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "enter your Number";
                  }
                  return null;
                },
                controller: phoneController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: AppColors.cyan),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone, color: AppColors.cyan),
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
                  hintText: "Phone Number",
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "enter your Password";
                  }
                  return null;
                },
                controller: passwordController,

                obscureText: passwordHidden,
                style: TextStyle(color: AppColors.cyan),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: AppColors.cyan),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.cyan),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        passwordHidden = !passwordHidden;
                      });
                    },
                    icon: Icon(
                      color: AppColors.cyan,
                      passwordHidden
                          ? Icons.visibility_off_sharp
                          : Icons.visibility_sharp,
                    ),
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
                onPressed: () async {
                  if (loginstate.currentState!.validate()) {
                    ApiResponse response = await login(
                      number: phoneController.text,
                      password: passwordController.text,
                    );

                    final data;
                    if (response.data != null) {
                      data = response.data as Map<String, dynamic>;
                    } else {
                      data = null;
                    }
                    if (response.error == null) {
                      final role = data["role"];
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context)  {
                            if (role == "tenant") {
                              return TenantNavBar(selectedPage: 0);
                            } else if (role == "owner") {
                          

                              return OwnerNavBar(ownerSelectedPage: 0);
                            } else {
                              return ErrorPage();
                            }
                          },
                        ),
                      );
                    } else {
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
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UserSelectionPage(),
                        ),
                      );
                    },
                    color: AppColors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.white,
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
      ),
    );
  }
}
