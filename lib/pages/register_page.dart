import 'package:firebasebookingapp/pages/home_page.dart';
import 'package:firebasebookingapp/pages/login_page.dart';
import 'package:firebasebookingapp/service/auth/auth_service.dart';
import 'package:firebasebookingapp/shared/constants.dart';
import 'package:firebasebookingapp/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../helper//helper_function.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String fullName = "";
  String password = "";
  bool isLoading = false;
  bool hidePassword = true;

  AuthService authService = AuthService();
  // Définition  d'une expression régulière pour valider l'email
  final RegExp _emailRegExp = RegExp(
    r'^[^@]+@[^@]+\.[^@]+$',
    caseSensitive: false,
    multiLine: false,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: const Text(
            "Beauty Booking",
            style: TextStyle(color: secondaryColor),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: IntrinsicHeight(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 50),
                          child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    "Sign in",
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  const Text(
                                    "Sign in to access the salon",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 50.0,
                                  ),
                                  Image.asset("assets/images/register.png"),
                                  const SizedBox(
                                    height: 50.0,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,

                                    decoration: textInputDecoration.copyWith(
                                      labelText: "Full Name",
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: primaryColor,
                                      ),
                                    ),

                                    onChanged: (value) {
                                      setState(() {
                                        fullName = value;
                                      });
                                    },

                                    // we check the validation here by using validator
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Your name is required';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,

                                    decoration: textInputDecoration.copyWith(
                                      labelText: "Email",
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: primaryColor,
                                      ),
                                    ),

                                    onChanged: (value) {
                                      setState(() {
                                        email = value;
                                      });
                                    },

                                    // we check the validation here by using validator
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return ' The email is required';
                                      } else if (!_emailRegExp
                                          .hasMatch(value)) {
                                        return "Please enter a valid email";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  TextFormField(
                                      obscureText: hidePassword,
                                      keyboardType: TextInputType.text,
                                      decoration: textInputDecoration.copyWith(
                                        labelText: "Password",
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            hidePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: primaryColor,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              hidePassword =
                                                  !hidePassword; // Inverse l'état de hidePassword
                                            });
                                          },
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          color: primaryColor,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          password = value;
                                        });
                                      },

                                      // we check the validation here by using validator
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a password';
                                        } else if (value.length < 6) {
                                          return "The password must contain at least 6 characters";
                                        } else if (!RegExp(r'[A-Z]')
                                            .hasMatch(value)) {
                                          return "The password must contain at least one uppercase letter.";
                                        } else if (!RegExp(r'[0-9]')
                                            .hasMatch(value)) {
                                          return "The password must contain at least one digit.";
                                        }
                                        return null;
                                      }),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            elevation: 0.0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0))),
                                        onPressed: () {
                                          register();
                                        },
                                        child: const Text(
                                          "Sign in",
                                          style: TextStyle(
                                              color: secondaryColor,
                                              fontSize: 16.0),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Text.rich(TextSpan(
                                      text: "Already have an account?",
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 14.0),
                                      children: <TextSpan>[
                                        TextSpan(
                                            mouseCursor:
                                                SystemMouseCursors.click,
                                            text: "Log in here",
                                            style: const TextStyle(
                                                color: primaryColor,
                                                fontSize: 14.0,
                                                decoration:
                                                    TextDecoration.underline),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                nextScreenReplace(
                                                    context, const LoginPage());
                                              })
                                      ])),
                                ],
                              )),
                        ),
                      ),
              ),
            );
          },
        ));
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      bool isRegistered = await authService.registerUserWithEmailAndPassword(
          fullName, email, password);

      if (isRegistered) {
        // Sauvegarde de l'état de connexion dans les préférences partagées
        await HelperFunctions.saveUserLoggedInStatus(true);
        await HelperFunctions.saveUserNameSF(fullName);
        await HelperFunctions.saveUserEmailSF(email);

        // Naviguation  vers la page d'accueil
        nextScreenReplace(context, const HomePage());
      } else {
        // Affichage d'un message d'erreur si l'inscription échoue
        ShowSnackbar(context, primaryColor, "Échec de l'inscription");
      }

      setState(() {
        isLoading = false;
      });
    }
  }
}
