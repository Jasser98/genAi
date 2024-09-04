import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genai/core/firebase_store.dart';
import 'package:get/get.dart';

import '../app_route.dart';
import '../components/custombuttonauth.dart';
import '../components/customlogoauth.dart';
import '../components/textformfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();

  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    phone.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Form(
              key: formState, // Assign the formState to Form
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 50),
                  const CustomLogoAuth(),
                  Container(height: 20),
                  const Text("Sign Up",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  Container(height: 10),
                  const Text("Sign up to continue using the app",
                      style: TextStyle(color: Colors.grey)),
                  Container(height: 20),
                  const Text(
                    "Username",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter Your Username",
                    mycontroller: username,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Can't be empty";
                      }
                      return null;
                    },
                  ),
                  Container(height: 20),
                  const Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter Your Email",
                    mycontroller: email,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Can't be empty";
                      }
                      return null;
                    },
                  ),
                  Container(height: 20),
                  const Text(
                    "Phone",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter Your phone",
                    mycontroller: phone,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Can't be empty";
                      }
                      return null;
                    },
                  ),
                  Container(height: 10),
                  const Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter Your Password",
                    mycontroller: password,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Can't be empty";
                      }
                      return null;
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    alignment: Alignment.topRight,
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomButtonAuth(
              title: "Sign Up",
              onPressed: () async {
                if (formState.currentState!.validate()) {
                  try {
                    // Créez un compte avec l'email et le mot de passe fournis
                    await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                          email: email.text,
                          password: password.text,
                        )
                        .then(
                          (value) => FirebaseStore.addUserDataToFireStore(
                            userId: value.user!.uid,
                            email: email.text,
                            username: username.text,
                            role: 'owner',
                          ),
                        );
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();

                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      showCloseIcon: true,
                      closeIcon: const Icon(Icons.close_fullscreen_outlined),
                      title: 'Success',
                      desc:
                          'Account created successfully. Please check your email to verify your account.',
                    ).show();
                    Get.offAndToNamed(AppRoutes.login);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        showCloseIcon: true,
                        closeIcon: const Icon(Icons.close_fullscreen_outlined),
                        title: 'Error',
                        desc: 'The password provided is too weak.',
                      ).show();
                    } else if (e.code == 'email-already-in-use') {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        showCloseIcon: true,
                        closeIcon: const Icon(Icons.close_fullscreen_outlined),
                        title: 'Error',
                        desc: 'The account already exists for that email.',
                      ).show();
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        showCloseIcon: true,
                        closeIcon: const Icon(Icons.close_fullscreen_outlined),
                        title: 'Error',
                        desc: 'An unknown error occurred.',
                      ).show();
                    }
                  } catch (e) {
                    print(e);
                  }
                }
              },
            ),
            Container(height: 20),
            InkWell(
              onTap: () {
                Get.offAllNamed(AppRoutes.login);
              },
              child: const Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                    text: "Have An Account? ",
                  ),
                  TextSpan(
                      text: "Login",
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.bold)),
                ])),
              ),
            ),
            Container(height: 50),
          ],
        ),
      ),
    );
  }
}
