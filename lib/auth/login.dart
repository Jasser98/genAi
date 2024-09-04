import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genai/core/firebase_store.dart';
import 'package:genai/core/hive/local_data.dart';
import 'package:genai/model/user_model.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../app_route.dart';
import '../components/custombuttonauth.dart';
import '../components/customlogoauth.dart';
import '../components/textformfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  Future<void> signInWithGoogle() async {
    // try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          showCloseIcon: true,
          closeIcon: const Icon(Icons.close_fullscreen_outlined),
          title: 'Info',
          desc: 'Google sign-in was canceled.',
        ).show();
        return;
      }

      await FirebaseStore.addUserDataToFireStore(
        userId: googleUser.id,
        email: googleUser.email,
        username: googleUser.displayName ?? '',
        role: 'user',
      );

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Get.toNamed(AppRoutes.userPage);
      LocalData.saveUserData(LocalUser(id: googleUser.id, role: 'user'));
    // } catch (e) {
    //   print(e);
    //   AwesomeDialog(
    //     context: context,
    //     dialogType: DialogType.error,
    //     animType: AnimType.rightSlide,
    //     showCloseIcon: true,
    //     closeIcon: const Icon(Icons.close_fullscreen_outlined),
    //     title: 'Error',
    //     desc: 'Google sign-in failed. Please try again. Error: $e',
    //   ).show();
    // }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 40),
            Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomLogoAuth(),
                  const SizedBox(height: 10),
                  const Text(
                    "Login To Continue Using The App",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  const Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  CustomTextForm(
                    isPassword: true,
                    hinttext: "Enter Your Password",
                    mycontroller: password,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Can't be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      if (email.text.isNotEmpty) {
                        try {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email.text);

                          // Show success dialog
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.rightSlide,
                            showCloseIcon: true,
                            closeIcon:
                                const Icon(Icons.close_fullscreen_outlined),
                            title: 'Success',
                            desc: 'Check your inbox to reset your password.',
                          ).show();
                        } catch (e) {
                          // Show error dialog if sending email fails
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            showCloseIcon: true,
                            closeIcon:
                                const Icon(Icons.close_fullscreen_outlined),
                            title: 'Error',
                            desc:
                                'Failed to send reset email. Please try again.',
                          ).show();
                        }
                      } else {
                        // Show warning dialog if email is empty
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          showCloseIcon: true,
                          closeIcon:
                              const Icon(Icons.close_fullscreen_outlined),
                          title: 'Warning',
                          desc: 'Please enter your email first.',
                        ).show();
                      }
                    },
                    child: Container(
                      alignment: Alignment.topRight,
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomButtonAuth(
              title: "Login",
              onPressed: () async {
                if (formState.currentState!.validate()) {
                  try {
                    final credential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );

                    if (credential.user!.emailVerified) {
                      // get user from firestore
                      final user = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(credential.user!.uid)
                          .get();

                      final String role = user.data()!['role'];
                      // check user type
                      if (role == 'owner') {
                        Get.offAllNamed(AppRoutes.ownerPage);
                      } else if (role == 'user') {
                        Get.offAllNamed(AppRoutes.userPage);
                      } else {
                        Get.offAllNamed(AppRoutes.adminPage);
                      }

                      LocalData.saveUserData(
                          LocalUser(id: credential.user!.uid, role: role));
                    } else {
                      await FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        showCloseIcon: true,
                        closeIcon: const Icon(Icons.close_fullscreen_outlined),
                        title: 'Info',
                        desc:
                            "Please check your inbox and verify your email to activate your account.",
                      ).show();
                    }
                  } on FirebaseAuthException catch (e) {
                    String errorMessage;
                    switch (e.code) {
                      case 'invalid-email':
                        errorMessage = 'Invalid email address.';
                        break;
                      case 'wrong-password':
                        errorMessage = 'Wrong password provided.';
                        break;
                      case 'user-disabled':
                        errorMessage = 'This user account has been disabled.';
                        break;
                      case 'too-many-requests':
                        errorMessage =
                            'Too many login attempts. Please try again later.';
                        break;
                      default:
                        errorMessage = 'Login failed. Please try again.';
                    }

                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      showCloseIcon: true,
                      closeIcon: const Icon(Icons.close_fullscreen_outlined),
                      title: 'Error',
                      desc: errorMessage,
                    ).show();
                  }
                } else {
                  print("Not Valid");
                }
              },
            ),
            const SizedBox(height: 20),
            MaterialButton(
              height: 40,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.red[700],
              textColor: Colors.white,
              onPressed: signInWithGoogle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Login With Google  "),
                  Image.asset(
                    "images/4.png",
                    width: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Get.offAllNamed(AppRoutes.register);
              },
              child: const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Don't Have An Account? "),
                      TextSpan(
                        text: "Register",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
