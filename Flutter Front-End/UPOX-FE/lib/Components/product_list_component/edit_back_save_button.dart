import 'package:first_app/View_Page/manual_input._page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class EditBackSaveButton extends StatefulWidget {
  const EditBackSaveButton({super.key});

  @override
  State<EditBackSaveButton> createState() => _EditBackSaveButton();
}

class _EditBackSaveButton extends State<EditBackSaveButton> {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // Back Button
      Container(
        margin: const EdgeInsets.only(top: 10),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: ManualInputPage.initialize(),
                      type: PageTransitionType.leftToRight,
                      duration: const Duration(milliseconds: 300)));
            },
            child: const Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 1),
                Text(
                  "Back",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Save Button
      Container(
        margin: const EdgeInsets.only(top: 10),
        child: Padding(
          padding: const EdgeInsets.only(right: 13, top: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: ManualInputPage.initialize(),
                      type: PageTransitionType.leftToRight,
                      duration: const Duration(milliseconds: 300)));
            },
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
