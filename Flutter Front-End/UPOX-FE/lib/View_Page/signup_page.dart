import 'package:first_app/Components/CommonComponent/back_button_component.dart';
import 'package:first_app/Components/SignUp_PageComponent/content_user_signup_field.dart';
import 'package:first_app/Components/SignUp_PageComponent/header_signup_text.dart';
import 'package:first_app/Components/loginPage_Component/footer_googleButton.dart';
import 'package:first_app/Components/loginPage_Component/header_iconLogin.dart';
import 'package:first_app/View_Page/welcomePage.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return const Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
            child: const Column(
          children: [
            // Stack 1
            Stack(
              children: [
                Positioned(
                  left: 10,
                  top: 10,
                  child: BackButtonComponent(
                    targetPage: WelcomePage(),
                    iconColor: Colors.blue,
                    textColor: Colors.blue,
                    labelText: "Back",
                  ),
                ),
                Center(
                  child: HeaderIconLogin(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    HeaderSignUpContext(),
                  ],
                )),
            // Sign Up filed
            SignUpFieldEvent(),
            GoogleSignUpButton(true),
          ],
        )),
      ),
    );
  }
}
