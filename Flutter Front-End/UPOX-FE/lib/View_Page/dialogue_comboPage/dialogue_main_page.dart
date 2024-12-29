import 'package:first_app/Components/CommonComponent/back_button_component.dart';
import 'package:first_app/Components/dialogueComponent/dialogue_background.dart';
import 'package:first_app/Components/dialogueComponent/dialogue_content.dart';
import 'package:first_app/Components/dialogueComponent/dialogue_icon.dart';
import 'package:first_app/Components/dialogueComponent/dialogue_yourchoose.dart';
import 'package:first_app/Controller/token_controller.dart';
import 'package:first_app/View_Page/homepage_comboPage/homepage_mainview.dart';
import 'package:first_app/View_Page/welcomePage.dart';

import 'package:flutter/material.dart';

class DialoguePage extends StatelessWidget {
  const DialoguePage({super.key});
  

  @override
  Widget build(BuildContext context) {
    TokenController tokenController = TokenController();
    tokenController.findToken();
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: DialogueBackground(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Back Button
            const SizedBox(height: 10),
            BackButtonComponent(
              targetPage: HomepageMainview(tokenController.getAccessToken(), tokenController.getRefreshToken()),
              iconColor: Colors.white,
              textColor: Colors.white,
              labelText: "Back",
            ),
            const SizedBox(height: 20),
            Container(
                child: Column(children: [
              const DialogueContentText(),
              const SizedBox(height: 12),
              const DialogueContentIcon(),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.13),
                child: const DialogueChooseButton(),
              ),
            ]))
          ],
        )),
      ),
    );
  }
}
