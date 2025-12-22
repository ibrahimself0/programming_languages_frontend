
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_apartment.dart';
import '../providers.dart';

class MyApartments extends StatefulWidget {
  const MyApartments({super.key});
  
  @override
  State<MyApartments> createState() => _MyApartmentsState();
}

class _MyApartmentsState extends State<MyApartments>{
  @override
  Widget build(BuildContext context) {
    final apartments =
        Provider.of<ApartmentProvider>(context).apartments;

     return Scaffold(
      appBar: AppBar(title: Text('Owner Dashboard')),
      body: ListView.builder(
        itemCount: apartments.length,
        itemBuilder: (ctx, index) {
          final apt = apartments[index];
          return ListTile(
            title: Text(apt.title),
            subtitle: Text('${apt.price} - \$${apt.price}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => OwnerAddApartmentScreen()),
          );
        },
      ),
    );
  }
}
  