import 'package:firebasebookingapp/pages/manage_appoinment_page.dart';
import 'package:firebasebookingapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebasebookingapp/shared/constants.dart';
import '../model/service_model.dart';

class ServiceDetailsPage extends StatelessWidget {
  final Service service;

  const ServiceDetailsPage({required this.service, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service.name),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(service.imageUrl),
            const SizedBox(height: 16),
            Text(
              service.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "\$${service.price.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              service.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                nextScreen(context, const ManageAppointmentsPage());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                
              ),
              child: const Text('Prendre un rendez-vous',style: TextStyle(color: secondaryColor),),
            ),
          ],
        ),
      ),
    );
  }
}
