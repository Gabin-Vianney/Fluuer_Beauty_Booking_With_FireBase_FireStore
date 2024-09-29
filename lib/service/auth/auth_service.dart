import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebookingapp/service/database_service.dart';
import 'package:firebasebookingapp/helper/helper_function.dart';
class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
 // login function
Future<String> loginWithEmailAndPassword(String email, String password) async {
  try {
    User? user = (await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      // Connexion réussie
      return "success";
    } else {
      // Connexion échouée, mais sans erreur explicite
      return "failed";
    }
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'wrong-password':
        return 'Le mot de passe est incorrect.';
      case 'user-not-found':
        return "Aucun utilisateur trouvé pour cet e-mail.";
      case 'invalid-email':
        return "L'adresse e-mail est invalide.";
      case 'user-disabled':
        return "Ce compte a été désactivé.";
      case 'too-many-requests':
        return "Trop de tentatives de connexion. Veuillez réessayer plus tard.";
      default:
        return "Une erreur inconnue s'est produite : ${e.message}";
    }
  } catch (e) {
    return "Une erreur s'est produite";
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


 