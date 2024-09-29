import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebookingapp/service/database_service.dart';
import 'package:firebasebookingapp/helper/helper_function.dart';
class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login
  Future<bool> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      User? user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      // Vérifiez si l'utilisateur existe
      if (user != null) {
        return true; // La connexion a réussi
      } else {
        return false; // Échec de la connexion
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return false; // Échec de la connexion
    }
  }

  // register
  Future<bool> registerUserWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User? user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      // Vérification de la création de l'utilisateur
      if (user != null) {
        // Mise à jour des données de l'utilisateur dans la base de données
        await DatabaseService(uid: user.uid).updatingData(fullName, email);
        return true; // Retourne vrai si l'inscription est réussie
      } else {
        return false; // Retourne faux si l'utilisateur est null
      }
    } on FirebaseAuthException catch (e) {
      // Retourne faux en cas d'échec et affiche un message d'erreur
      print(e.message);
      return false;
    }
  }

  // sign out
  
  // sign out function
  Future<dynamic> signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

   // Méthode pour réinitialiser le mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Erreur lors de la réinitialisation du mot de passe:");
    }
  }

}


 