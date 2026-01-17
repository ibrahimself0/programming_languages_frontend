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

  Future<List<dynamic>> getReservations(String token) async {
    final response = await http.get(
      Uri.parse("http://$ip:8000/api/tenant/reservations"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

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

      finished = data.where((r) => r["status"] == "approved").toList();

      notFinished = data.where((r) => r["status"] != "approved").toList();

      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error loading reservations")),
      );
    }
  }

  Widget buildReservationCard(dynamic reservation) {
    final apartment = reservation["apartment"];
    final bool isFinished = reservation["status"] == "approved";

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  apartment['province'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isFinished ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    reservation['status'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.date_range, size: 16),
                const SizedBox(width: 6),
                Text(
                  "${reservation['start_date']} → ${reservation['end_date']}",
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ],
        ),
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
            appBar: AppBar(
              backgroundColor: AppColors.primaryColor,
              automaticallyImplyLeading: false,
              elevation: 0,
              toolbarHeight: 0,
              bottom: const TabBar(
                labelColor: AppColors.cyan,
                unselectedLabelColor: AppColors.cyan,
                indicatorColor: AppColors.cyan,
                tabs: const [
                  Tab(text: "Finished"),
                  Tab(text: "Not Finished"),
                ],
              ),
            ),

            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.cyan),
                  )
                : TabBarView(
                    children: [
                      finished.isEmpty
                          ? const Center(
                              child: Text("No finished reservations 👀"),
                            )
                          : ListView.builder(
                              itemCount: finished.length,
                              itemBuilder: (context, index) =>
                                  buildReservationCard(finished[index]),
                            ),
                      notFinished.isEmpty
                          ? const Center(
                              child: Text("No active reservations 😴"),
                            )
                          : ListView.builder(
                              itemCount: notFinished.length,
                              itemBuilder: (context, index) =>
                                  buildReservationCard(notFinished[index]),
                            ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
