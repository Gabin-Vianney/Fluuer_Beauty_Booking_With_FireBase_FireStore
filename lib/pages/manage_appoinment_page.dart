import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebookingapp/shared/constants.dart';
import 'package:firebasebookingapp/widgets/widgets.dart';

class ManageAppointmentsPage extends StatefulWidget {
  const ManageAppointmentsPage({super.key});

  @override
  _ManageAppointmentsPageState createState() => _ManageAppointmentsPageState();
}

class _ManageAppointmentsPageState extends State<ManageAppointmentsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addAppointment(
      String serviceName, String date, String time, double price) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String appointmentId = _firestore.collection('appointments').doc().id;

        await _firestore.collection('appointments').doc(appointmentId).set({
          'serviceName': serviceName,
          'date': date,
          'time': time,
          'price': price,
          'userId': user.uid,
        });

        ShowSnackbar(context, 'Appointment added successful', primaryColor);
      }
    } catch (e) {
      print('Erreur lors de l\'ajout du rendez-vous: $e');
      ShowSnackbar(context, 'Error occurred', primaryColor);
    }
  }

  Future<void> _showAddAppointmentDialog() async {
    String serviceName = '';
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();
    double price = 0.0;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add an appointment',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    serviceName = value;
                  },
                  decoration: const InputDecoration(hintText: 'Service Name'),
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    price = double.tryParse(value) ?? 0.0;
                  },
                  decoration: const InputDecoration(hintText: 'Price'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.black),
                      const SizedBox(width: 8),
                      Text('Choose Date: ${selectedDate.toLocal()}'
                          .split(' ')[0]),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (pickedTime != null && pickedTime != selectedTime) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.black),
                      const SizedBox(width: 8),
                      Text('Choose hour: ${selectedTime.format(context)}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                String date = "${selectedDate.toLocal()}".split(' ')[0];
                String time = selectedTime.format(context);
                _addAppointment(serviceName, date, time, price);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelAppointment(String appointmentId) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).delete();

      ShowSnackbar(context, 'Rendez-vous annulé avec succès', primaryColor);
    } catch (e) {
      ShowSnackbar(
          context, 'Erreur lors de l\'annulation du rendez-vous', primaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Appointments management',
            style: TextStyle(color: secondaryColor)),
        centerTitle: true,
      ),
      body: user == null
          ? const Center(
              child: Text('Please login '),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('appointments')
                  .where('userId', isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                      child: Text("Error loading appointments."));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('Any appointment to display'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var appointmentData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    String appointmentId = snapshot.data!.docs[index].id;
                    String serviceName =
                        appointmentData['serviceName'] ?? 'Service';
                    String date = appointmentData['date'] ?? '';
                    String time = appointmentData['time'] ?? '';
                    double price = appointmentData['price'] ?? 0.0;

                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      borderOnForeground: false,
                      clipBehavior: Clip.antiAlias,
                      semanticContainer: true,
                      shadowColor: Colors.blue,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(serviceName,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: $date'),
                            const SizedBox(height: 4.0),
                            Text('Hour: $time'),
                            const SizedBox(height: 4.0),
                            Text('Price: \$${price.toStringAsFixed(2)}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.cancel, color: primaryColor),
                          onPressed: () {
                            _cancelAppointment(appointmentId);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAppointmentDialog,
        backgroundColor: primaryColor,
        child: const Icon(
          Icons.add,
          color: secondaryColor,
        ),
      ),
    );
  }
}
