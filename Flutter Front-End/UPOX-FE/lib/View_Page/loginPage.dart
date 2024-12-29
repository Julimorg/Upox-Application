import 'package:first_app/Components/CommonComponent/back_button_component.dart';
import 'package:first_app/Components/loginPage_Component/content_user_login_field.dart';
import 'package:first_app/Components/loginPage_Component/footer_googleButton.dart';
import 'package:first_app/Components/loginPage_Component/header_LoginText.dart';
import 'package:first_app/Components/loginPage_Component/header_iconLogin.dart';
import 'package:first_app/View_Page/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
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

              // Stack 2
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: Row(
                  children: [
                    Expanded(
                      child: HeaderContentText(),
                    ),
                  ],
                ),
              ),
              // Stack 3
              LoginFieldEvent(),

              GoogleSignUpButton(false),
            ],
          ),
        ),
      ),
    );
  }
}
