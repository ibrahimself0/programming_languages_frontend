import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../data/notifiers.dart';



class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
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
                      Tab(text: "chat"),
                      Tab(text: "notifications"),
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