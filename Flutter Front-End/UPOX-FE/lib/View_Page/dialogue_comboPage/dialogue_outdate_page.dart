import 'package:first_app/Components/CommonComponent/back_button_component.dart';
import 'package:first_app/Components/dialogueComponent/dialogueOutDateComponent/dialogue_outdate_content.dart';
import 'package:first_app/Components/dialogueComponent/dialogueOutDateComponent/dialogue_outdate_yourchoose.dart';
import 'package:first_app/Components/dialogueComponent/dialogue_background.dart';
import 'package:first_app/Components/dialogueComponent/dialogue_icon.dart';
import 'package:first_app/View_Page/dialogue_comboPage/dialogue_main_page.dart';

import 'package:flutter/material.dart';

class DialogueOutdatePage extends StatelessWidget {
  const DialogueOutdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: DialogueBackground(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Back Button
            const SizedBox(height: 10),
            const BackButtonComponent(
              targetPage: DialoguePage(),
              iconColor: Colors.white,
              textColor: Colors.white,
              labelText: "Back",
            ),
            const SizedBox(height: 20),
            Container(
                child: Column(children: [
              const DialogueOutdateContent(),
              const SizedBox(height: 12),
              const DialogueContentIcon(),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.13),
                child: const DialogueOutdateYourchoose(),
              ),
            ]))
          ],
        )),
      ),
    );
  }
}
