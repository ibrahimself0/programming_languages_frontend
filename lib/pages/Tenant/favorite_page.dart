import 'dart:convert';

import 'package:app/services/general_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<dynamic> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
    
  }
  Future<List<dynamic>> getFavorites(String token) async {
  final response = await http.get(
    Uri.parse("http://192.168.137.231:8000/api/favorites"),
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['favorites'];
  } else {
    throw Exception("فشل في تحميل المفضلة");
  }
}


  Future<void> loadFavorites() async {
    final token = await getToken(); // دالة الحصول على التوكن
    try {
      final data = await getFavorites(token);
      setState(() {
        favorites = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء تحميل المفضلة")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("المفضلة")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? Center(child: Text("لا توجد شقق في المفضلة"))
              : ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final fav = favorites[index];

                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text("رقم الشقة: ${fav['apartment_id']}"),
                        subtitle: Text("رقم المفضلة: ${fav['id']}"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            removeFavorite(fav['apartment_id']);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> removeFavorite(int apartmentId) async {
    final token = await getToken();

    final response = await http.delete(
      Uri.parse("http://192.168.137.231:8000/api/favorites/$apartmentId"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        favorites.removeWhere((f) => f['apartment_id'] == apartmentId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("تمت إزالة الشقة من المفضلة")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء الحذف")),
      );
    }
  }
}