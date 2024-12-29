import 'package:flutter/material.dart';
import 'package:first_app/Components/dialogueComponent/dialogueOutDateShowlList/itemshowlist.dart';

class DialogueOutdateShowlist extends StatefulWidget {
  const DialogueOutdateShowlist({super.key});

  @override
  _DialogueOutdateShowlistState createState() =>
      _DialogueOutdateShowlistState();
}

class _DialogueOutdateShowlistState extends State<DialogueOutdateShowlist> {
  List<Map<String, String>> items = [];

  Future<void> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      items = List.generate(
        10,
        (index) => {
          "itemName": "Kem chống nắng $index",
          "itemCount": "${index + 1}",
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.85,
      height: screenHeight * 0.3,
      // color: Colors.green,
      child: Stack(children: [
        Center(
          child: Container(
            width: screenWidth * 0.75,
            height: screenHeight * 0.2,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.white.withOpacity(0.8),
            ),
            child: items.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Itemshowlist(
                        itemName: items[index]["itemName"]!,
                        itemCount: items[index]["itemCount"]!,
                      );
                    },
                  ),
          ),
        ),
        // Đặt hình ảnh ở góc trên bên phải
        Positioned(
          top: -3,
          right: -8,
          child: Image.asset(
            "assets/logo_dialogue.png",
            height: 60,
            width: 60,
          ),
        ),
      ]),
    );
  }
}
