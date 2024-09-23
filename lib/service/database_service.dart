import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // references to  collection

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference appointmentsCollection =
      FirebaseFirestore.instance.collection("appointments");

  // updating user data

  Future updatingData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "appointments": [],
      "profilePic": "",
      "uid": uid
    });
  }

  // Méthode pour mettre à jour les données de l'utilisateur
  Future<void> updateUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set(
        {
          'fullName': fullName,
          'email': email,
        },
        SetOptions(
            merge:
                true)); // merge: true permet de ne mettre à jour que les champs spécifiés
  }

  // Method to update the profile image URL
  Future<void> updateProfileImage(String imageUrl) async {
    try {
      await userCollection.doc(uid).update({
        'profilePic': imageUrl,
      });
    } catch (e) {
      print('Failed to update profile image: $e');
    }
  }

// Méthode pour récupérer les données de l'utilisateur
  Future<Map<String, dynamic>> getUserData() async {
    try {
      DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();

      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  Future<void> addAppointment(String appointmentId) async {
    try {
      await userCollection.doc(uid).update({
        'appointments': FieldValue.arrayUnion([appointmentId]),
      });
    } catch (e) {
      print('Failed to add appointment: $e');
    }
  }

  Future<List<String>> getUserAppointments() async {
    try {
      DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;
        return List<String>.from(userData['appointments'] ?? []);
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
