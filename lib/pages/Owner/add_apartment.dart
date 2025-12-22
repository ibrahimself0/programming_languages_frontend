
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers.dart';


class OwnerAddApartmentScreen extends StatefulWidget {
  const OwnerAddApartmentScreen({super.key});

  @override
  State<OwnerAddApartmentScreen> createState() =>
      _OwnerAddApartmentScreenState();
}

class _OwnerAddApartmentScreenState extends State<OwnerAddApartmentScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('add apartment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'name '),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'description'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'price'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final apartment = Apartment(
                  title: titleController.text,
                  description: descController.text,
                  price: double.parse(priceController.text),
                );

                Provider.of<ApartmentProvider>(
                  context,
                  listen: false,
                ).addApartment(apartment);

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}