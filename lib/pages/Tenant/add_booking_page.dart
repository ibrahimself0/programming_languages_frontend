import 'dart:convert';

import 'package:app/constants/app_colors.dart';
import 'package:app/constants/url.dart';
import 'package:app/services/general_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddBookingPage extends StatefulWidget {
  final Map<String, dynamic> apartment;
  const AddBookingPage({super.key, required this.apartment});
  @override
  _AddBookingPageState createState() => _AddBookingPageState();
}

class _AddBookingPageState extends State<AddBookingPage> {
  Future<void> pickDateOfend(BuildContext context) async {
    if (_startDateController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("select the start date first")));
      return;
    }
    final DateTime startDate = DateTime.parse(_startDateController.text);
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: startDate,
      lastDate: DateTime(2027),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.cyan,
            colorScheme: ColorScheme.light(
              primary: AppColors.cyan,
              onPrimary: AppColors.darkCyan,
              onSurface: AppColors.darkCyan,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppColors.cyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _endDateController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> pickDateOfstart(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.cyan,
            colorScheme: ColorScheme.light(
              primary: AppColors.cyan,
              onPrimary: AppColors.darkCyan,
              onSurface: AppColors.darkCyan,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppColors.cyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _startDateController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  bool isLoading = false;
  Future<void> _bookApartment() async {
    setState(() => isLoading = true);
    try {
      print("SENDING REQUEST");
      await createBook().createReservation(
        widget.apartment['id'],
        _startDateController.text,
        _endDateController.text,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Done")));
      Navigator.pop(context);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
    print("REQUEST FINISHED");

  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.cyan,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "${widget.apartment['province']} Apartment",
          style: TextStyle(color: AppColors.cyan, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cyan,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Price / night",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "${widget.apartment['price']}",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Booking dates",
              style: TextStyle(
                color: AppColors.cyan,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),

            Column(
              children: [
                TextFormField(
                  controller: _startDateController,
                  readOnly: true,
                  style: TextStyle(color: AppColors.primaryColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.cyan,
                    hintText: "Start Date",
                    hintStyle: TextStyle(color: AppColors.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onTap: () => pickDateOfstart(context),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _endDateController,
                  readOnly: true,
                  style: TextStyle(color: AppColors.primaryColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.cyan,
                    hintText: "End Date",
                    hintStyle: TextStyle(color: AppColors.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onTap: () => pickDateOfend(context),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cyan, width: 3),
                  ),
                  child: Icon(
                    Icons.date_range_rounded,
                    color: AppColors.cyan,
                    size: 28,
                  ),
                ),
              ],
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: AppColors.cyan),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cyan,
                        foregroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _bookApartment,
                      child: Text(
                        "Confirm Booking",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class createBook {
  final String baseUrl = "http://$ip:8000/api";
  Future<void> createReservation(
    int apartmentId,
    String startDate,
    String endDate,
  ) async {
    final token = await getToken();

    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    if (token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    final response = await http.post(
      Uri.parse("$baseUrl/tenant/reservations/$apartmentId"),
      headers: headers,
      body: jsonEncode({"start_date": startDate, "end_date": endDate}),
    );

    if (response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
