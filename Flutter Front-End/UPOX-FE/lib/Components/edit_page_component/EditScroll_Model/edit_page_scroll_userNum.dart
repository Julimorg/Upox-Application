import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class EditPageScrollUsernum extends StatefulWidget {
  final Function(int) onUserNumSelected;

  const EditPageScrollUsernum({super.key, required this.onUserNumSelected});

  @override
  State<EditPageScrollUsernum> createState() => _EditPageScrollUsernum();
}

class _EditPageScrollUsernum extends State<EditPageScrollUsernum> {
  int selectedUserNum = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Center(
      child: Container(
        width: width * 0.75,
        height: height * 0.35,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 40,
                scrollController: FixedExtentScrollController(),
                children: List<Widget>.generate(
                  11,
                  (index) => Text(
                    '$index',
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
                onSelectedItemChanged: (int value) {
                  setState(() {
                    selectedUserNum = value;
                  });
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      widget.onUserNumSelected(selectedUserNum);
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(width: 1, color: Colors.black),
                      ),
                    ),
                    child: const Text(
                      "Xác nhận !",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "intern",
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(width: 1, color: Colors.black),
                      ),
                    ),
                    child: const Text(
                      "Hủy!",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "intern",
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void ShowUserNum(BuildContext context, Function(int) onUserNumSelected) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: EditPageScrollUsernum(onUserNumSelected: onUserNumSelected),
      );
    },
  );
}
