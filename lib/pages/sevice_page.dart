import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebasebookingapp/pages/booking_page.dart';
import 'package:firebasebookingapp/shared/constants.dart';
import 'package:firebasebookingapp/widgets/widgets.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Services', style: TextStyle(color: secondaryColor)),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('services').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erreur de chargement des services'));
          }

          final services = snapshot.data?.docs ?? [];

          if (services.isEmpty) {
            return const Center(child: Text('Aucun service disponible'));
          }

          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              var serviceData = services[index].data() as Map<String, dynamic>;
              String serviceId = services[index].id;
              String serviceName = serviceData['name'] ?? 'Service';
              String description = serviceData['description'] ?? '';
              double price = serviceData['price']?.toDouble() ?? 0.0;
              String duration = serviceData['duration'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(serviceName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(description),
                      const SizedBox(height: 8.0),
                      Text('Durée: $duration'),
                      const SizedBox(height: 4.0),
                      Text('Prix: \$${price.toStringAsFixed(2)}'),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward, color: primaryColor),
                  onTap: () {
                    nextScreen(
                      context,
                      BookingPage(
                        serviceId: serviceId,
                        serviceName: serviceName,
                        price: price,
                        duration: duration,
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
