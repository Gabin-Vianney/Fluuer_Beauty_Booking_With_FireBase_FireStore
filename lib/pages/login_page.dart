import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../service/auth/auth_service.dart';
import '../helper/helper_function.dart';
import '../pages/home_page.dart';
import '../pages/register_page.dart';
import '../shared/constants.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool isLoading = false;
  bool hidePassword = true;
  AuthService authService = AuthService();

  // Expression régulière pour valider l'email
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
                                "Log in",
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10.0),
                              const Text(
                                "Log in to access the salon",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(height: 50.0),
                              Image.asset("assets/images/login.png"),
                              const SizedBox(height: 50.0),
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return ' The email is required';
                                  } else if (!_emailRegExp.hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20.0),
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
                                        hidePassword = !hidePassword;
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  } else if (value.length < 6) {
                                    return "The password must contain at least 6 characters";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10.0),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: resetPasswordDialog,
                                  child: const Text(
                                    "Forgot Password ?",
                                    style: TextStyle(color: primaryColor),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0))),
                                  onPressed: () {
                                    login();
                                  },
                                  child: const Text(
                                    "Log in",
                                    style: TextStyle(
                                        color: secondaryColor, fontSize: 16.0),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              Text.rich(
                                TextSpan(
                                  text: "Don't have an account ? ",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14.0),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Sign in here",
                                      style: const TextStyle(
                                          color: primaryColor,
                                          fontSize: 14.0,
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          nextScreen(
                                              context, const RegisterPage());
                                        },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      bool result =
          await authService.loginUserWithEmailAndPassword(email, password);

      if (result) {
        await HelperFunctions.saveUserLoggedInStatus(true);
        await HelperFunctions.saveUserEmailSF(email);
        nextScreenReplace(context, const HomePage());
      } else {
        ShowSnackbar(context, primaryColor, "Login failed");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void resetPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String resetEmail = "";
        return AlertDialog(
          title: const Text("Reset password"),
          content: TextFormField(
            decoration: textInputDecoration.copyWith(labelText: "Email"),
            onChanged: (value) {
              resetEmail = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await authService
                      .resetPassword(resetEmail); // Appel correct de la méthode
                  Navigator.of(context).pop();
                  ShowSnackbar(context, primaryColor,
                      "Password reset email sent.");
                } catch (e) {
                  ShowSnackbar(context, primaryColor, e.toString());
                }
              },
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }
}
