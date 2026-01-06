import 'dart:convert';

import 'package:app/constants/app_colors.dart';
import 'package:app/constants/url.dart';
import 'package:app/services/general_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class addBookingPage extends StatefulWidget {
  final Map<String, dynamic> apartment;

  const addBookingPage({super.key, required this.apartment});

  @override
  _addBookingPageState createState() => _addBookingPageState();
}

class _addBookingPageState extends State<addBookingPage> {
  Future<void> pickDateOfend(BuildContext context) async {
    if (_startDateController.text.isEmpty) {
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("select the start date first")),
    );
    return;
  }
  final DateTime startDate = DateTime.parse(_startDateController.text);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate:startDate,
      lastDate:  DateTime(2027),
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
      initialDate:  DateTime.now(),
      firstDate: DateTime.now(),
      lastDate:  DateTime(2027),
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
          backgroundColor:AppColors.cyan, 
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
    final token = await getToken(); 
    setState(() => isLoading = true);
     try {
      await createBook().createReservation(
        token,
        widget.apartment['id'],
        _startDateController.text,
        _endDateController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Done")),
      );
      Navigator.pop(context); 
    }catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("error: $e")),
        
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
   Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(backgroundColor: AppColors.primaryColor,centerTitle: true ,title: Text("${widget.apartment['province']} Aparment",style: TextStyle(color: AppColors.cyan))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("price for one night: ${widget.apartment['price']}",style: TextStyle(color: AppColors.cyan),),
             const SizedBox(height: 10),
              const SizedBox(height: 10),
            TextFormField(

              controller: _startDateController,
              readOnly: true,
              decoration: InputDecoration(                 
                  filled: true,
                  fillColor: AppColors.cyan,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.cyan),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.cyan, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  hintText: "Start Date",
                ),style: TextStyle(color: AppColors.primaryColor),
              onTap: () => pickDateOfstart(context),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _endDateController,
              readOnly: true,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.cyan,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.cyan),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.cyan, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  hintText: "End Date",),style: TextStyle(color: AppColors.primaryColor),
              onTap: () => pickDateOfend(context),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _bookApartment,
                    child: Text("Confrim booking"),
                  ),
          ],
           ),
      ),
    );
  }
}


class createBook {
  final String baseUrl = "http://$ip:8000/api";

  Future<void> createReservation(String token, int apartmentId, String startDate, String endDate) async {
    final response = await http.post(
      Uri.parse("$baseUrl/tenant/reservations/$apartmentId"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
      body: {
        "start_date": startDate,
        "end_date": endDate,
      },
    );

    if (response.statusCode == 201) {
      print("Reservation created successfully");
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? "Failed to create reservation");
    }
  }
}


