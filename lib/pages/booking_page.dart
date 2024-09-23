import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  final double price;
  final String duration;

  const BookingPage({
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.price,
    required this.duration,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? selectedDate;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réserver ${widget.serviceName}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Service: ${widget.serviceName}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10),
            Text(
              'Durée: ${widget.duration}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10),
            Text(
              'Prix: \$${widget.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choisissez une date :',
              style: TextStyle(fontSize: 18.0),
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Sélectionner la date'),
            ),
            const SizedBox(height: 20),
            if (selectedDate != null)
              Text(
                "Date sélectionnée : ${selectedDate!.toLocal()}".split(' ')[0],
                style: const TextStyle(fontSize: 18.0),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Logique pour effectuer la réservation et le paiement
              },
              child: const Text('Confirmer la réservation'),
            ),
          ],
        ),
      ),
    );
  }
}
