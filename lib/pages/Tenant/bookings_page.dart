import 'package:app/constants/app_colors.dart';
import 'package:app/data/notifiers.dart';
import 'package:flutter/material.dart';


class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, value, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            // key: scaffoldkey,
            body: Column(
              children: [
                Container(
                  color: AppColors.primaryColor,
                  child: TabBar(
                    // dividerColor: AppColors.cyan,
                    indicatorColor: AppColors.cyan,

                    tabs: [
                      Tab(text: "finished"),
                      Tab(text: "not-finished"),
                    ],
                    labelColor: AppColors.cyan,
                    unselectedLabelColor: AppColors.cyan,
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    children: [
                      Center(child: Text("data1")),
                      Center(child: Text("data2")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    // home:
  }
}