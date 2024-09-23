import 'package:firebasebookingapp/pages/login_page.dart';
import 'package:firebasebookingapp/service/auth/auth_service.dart';
import 'package:firebasebookingapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebookingapp/service/database_service.dart';
import 'package:firebasebookingapp/shared/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String fullName = "";
  String email = "";
  String profileImageUrl = "";
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  // Fonction pour récupérer les détails de l'utilisateur connecté
  void _getUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userData = await DatabaseService(uid: user.uid).getUserData();
      setState(() {
        email = user.email!;
        fullName = userData['fullName'] ?? "";
        profileImageUrl = userData['profilePic'] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: secondaryColor)),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: profileImageUrl.isNotEmpty
                    ? NetworkImage(profileImageUrl)
                    : null,
                backgroundColor: Colors.grey[300],
                child: profileImageUrl.isEmpty
                    ? const Icon(Icons.person, size: 80, color: primaryColor)
                    : null,
              ),
              const SizedBox(height: 20),
              Text(
                fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
              const Divider(thickness: 1),
              ListTile(
                leading: const Icon(Icons.edit, color: primaryColor),
                title: const Text("Edit Profile"),
                onTap: () {
                  _showEditProfileDialog();
                },
              ),
              const Divider(thickness: 1),
              ListTile(
                leading: const Icon(Icons.security, color: primaryColor),
                title: const Text("Change Password"),
                onTap: () {
                  _showChangePasswordDialog();
                },
              ),
              const Divider(thickness: 1),
              ListTile(
                leading: const Icon(Icons.logout, color: primaryColor),
                title: const Text("Déconnexion",
                    style: TextStyle(color: primaryColor)),
                onTap: () {
                  logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour afficher le dialogue de modification de profil
  void _showEditProfileDialog() {
    String newFullName = fullName;
    String newEmail = email;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modifier le profil"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: fullName,
                decoration: const InputDecoration(labelText: "Nom complet"),
                onChanged: (value) {
                  newFullName = value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: "Email"),
                onChanged: (value) {
                  newEmail = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  // Mettre à jour les informations de l'utilisateur dans Firebase Authentication
                  if (newEmail != email) {
                    try {
                      await user.verifyBeforeUpdateEmail(newEmail);
                    } catch (e) {
                      ShowSnackbar(context, primaryColor, "Erreur: $e");
                      return;
                    }
                  }
                  // Mettre à jour les informations de l'utilisateur dans Firestore
                  await DatabaseService(uid: user.uid).updateUserData(newFullName, newEmail);
                  setState(() {
                    fullName = newFullName;
                    email = newEmail;
                  });
                  Navigator.of(context).pop();
                  ShowSnackbar(context, primaryColor, "Profil mis à jour");
                }
              },
              child: const Text("Enregistrer"),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour afficher le dialogue de changement de mot de passe
  void _showChangePasswordDialog() {
    String newPassword = "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Changer le mot de passe"),
          content: TextFormField(
            decoration: const InputDecoration(labelText: "Nouveau mot de passe"),
            obscureText: false,
            onChanged: (value) {
              newPassword = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  try {
                    await user.updatePassword(newPassword);
                    Navigator.of(context).pop();
                    ShowSnackbar(context, primaryColor, "Mot de passe mis à jour");
                  } catch (e) {
                    ShowSnackbar(context, primaryColor, "Erreur");
                  }
                }
              },
              child: const Text("Enregistrer"),
            ),
          ],
        );
      },
    );
  }

  void logout() async {
    await authService.signOut();
    nextScreen(context, const LoginPage());
  }
}
