import 'dart:convert';

import 'package:app/constants/app_colors.dart';
import 'package:app/constants/url.dart';
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
    Uri.parse("http://$ip:8000/api/favorites"),
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
  );

  if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
  return data['favorites'] ?? [];
}

return [];

}


  Future<void> loadFavorites() async {
    final token = await getToken(); 
    try {
      final data = await getFavorites(token);
      setState(() {
        favorites = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error in loading")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,

      appBar: AppBar(foregroundColor: AppColors.cyan,centerTitle: true, backgroundColor: AppColors.primaryColor,title: Text("Favorite",style: TextStyle(color: AppColors.cyan),)),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? Center(child: Text("no apartment in favorite"))
              : ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final fav = favorites[index];

                    return Card(
                      margin: EdgeInsets.all(3),
                      child: ListTile(
                        tileColor: AppColors.cyan,
                        
                        title: Text("apartment id: ${fav['apartment_id']}",style: TextStyle(color: AppColors.primaryColor),),
                        // subtitle: Text("رقم المفضلة: ${fav['id']}"),
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
      Uri.parse("http://$ip:8000/api/favorites/$apartmentId"),
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
        SnackBar(content: Text("the apartment has been removed from favorites")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error on removing")),
      );
    }
  }
}