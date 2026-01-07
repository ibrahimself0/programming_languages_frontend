import 'package:app/pages/launch/start_page.dart';
import 'package:flutter/material.dart';

import '../../services/general_service.dart';
import '../Owner/owner_navigation.dart';
import '../Tenant/tenant_navigation.dart';
import '../error_page.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void checkUserHasToken() async {
    String token = await getToken();
    //token = "";
    if (token == "") {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => StartPage()),
      );
    } else {
      String? role = await getRole();
      // Stops execution if the widget was disposed before the async task finished
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) {
            if (role == "tenant") {
              return TenantNavBar(selectedPage: 0);
            } else if (role == "owner") {
              return OwnerNavBar(ownerSelectedPage: 0);
            } else {
              debugPrint(role);
              return ErrorPage();
            }
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserHasToken();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Colors.cyan),
    );
  }
}
