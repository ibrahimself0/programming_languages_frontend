import 'dart:convert';

import 'package:app/constants/app_colors.dart';
import 'package:app/constants/url.dart';
import 'package:app/data/notifiers.dart';
import 'package:app/services/general_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class BookingPage extends StatefulWidget {
  @override
  State<BookingPage> createState() => _BookingPageState();
}
class _BookingPageState extends State<BookingPage> {
  List<dynamic> finished = [];
  List<dynamic> notFinished = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadReservations();
  }

  // -------------------------
  // 1) GET RESERVATIONS
  // -------------------------
  Future<List<dynamic>> getReservations(String token) async {
    final response = await http.get(
      Uri.parse("http://$ip:8000/api/tenant/reservations"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );
     print("STATUS = ${response.statusCode}");
  print("RESPONSE BODY = ${response.body}");


if (response.statusCode == 200) {
  
      final data = jsonDecode(response.body);
      return data['reservations'] ?? [];
    }

    return [];
  }
 Future<void> loadReservations() async {
    final token = await getToken();

    try {
      final data = await getReservations(token);

      finished = data.where((r) =>
          r["status"] == "done" ||
          r["status"] == "cancelled").toList();

      notFinished = data.where((r) =>
          r["status"] == "pending" ||
          r["status"] == "approved" ||
          r["status"] == "edit_requested" ||
          r["status"] == "cancel_requested").toList();

      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading reservations")),
      );
    }
  }
 Widget buildReservationCard(dynamic reservation) {
    final apartment = reservation["apartment"];

    return Card(
      margin: EdgeInsets.all(3),
      child: ListTile(
        tileColor: AppColors.cyan,
        title: Text(
          "Apartment: ${apartment['province']}",
          style: TextStyle(color: AppColors.primaryColor),
        ),
        subtitle: Text(
          "Status: ${reservation['status']}",
          style: TextStyle(color: AppColors.primaryColor),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: AppColors.primaryColor),
        onTap: () {
          // يمكنك فتح صفحة تفاصيل الشقة هنا
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, value, child) {
         return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Column(
          children: [
            Container(
              color: AppColors.primaryColor,
              child: TabBar(
                indicatorColor: AppColors.cyan,
                labelColor: AppColors.cyan,
                unselectedLabelColor: AppColors.cyan,
                tabs: const [
                  Tab(text: "Finished"),
                  Tab(text: "Not Finished"),
                ],
              ),
            ),
         Expanded(
              child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  // FINISHED
                  finished.isEmpty
                      ? const Center(child: Text("No finished reservations"))
                      : ListView.builder(
                          itemCount: finished.length,
                          itemBuilder: (context, index) =>
                              buildReservationCard(finished[index]),
                        ),

                  // NOT FINISHED
                  notFinished.isEmpty
                      ? const Center(child: Text("No active reservations"))
                      : ListView.builder(
                          itemCount: notFinished.length,
                          itemBuilder: (context, index) =>
                              buildReservationCard(notFinished[index]),
                        ),
                ],
         
                   ),
      ),
          ]
        ),),
    );

      
               
              
          
      },
    );
    // home:
  }
}