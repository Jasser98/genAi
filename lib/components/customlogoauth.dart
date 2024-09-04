import 'package:flutter/material.dart';

class CustomLogoAuth extends StatelessWidget {
  const CustomLogoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.fromARGB(15, 238, 238, 238),
          borderRadius: BorderRadius.circular(70),
        ),
        child: Image.asset(
          "images/login.png",
          height: 120, // Adjust height as needed
        ),
      ),
    );
  }
}
