import 'package:flutter/cupertino.dart';

ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(true);
ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(true);
ValueNotifier<List<Map<String, dynamic>>> apartmentsNotifier =
ValueNotifier<List<Map<String, dynamic>>>([]);
