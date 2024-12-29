import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class EditPageScrollSelectintensity extends StatefulWidget {
  final Function(int, String) onIntensitySelected;

  const EditPageScrollSelectintensity(
      {super.key, required this.onIntensitySelected});

  @override
  State<EditPageScrollSelectintensity> createState() =>
      _EditPageScrollSelectintensity();
}

class _EditPageScrollSelectintensity
    extends State<EditPageScrollSelectintensity> {
  //default attributes
  int intensitySelected = 0;
  String selectedUnit = 'Ngày';

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
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              // Select num
              Expanded(
                flex: 2,
                child: Container(
                  // width: width * 0.75,
                  height: height * 0.2,
                  child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(),
                    children: List<Widget>.generate(
                      10,
                      (index) => Text(
                        '$index',
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                    onSelectedItemChanged: (int value) {
                      setState(() {
                        intensitySelected = value;
                      });
                    },
                  ),
                ),
              ),
              // Select Day - Month - Year
              Expanded(
                flex: 2,
                child: Container(
                  height: height * 0.1,
                  child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(),
                    children: const [
                      Text(
                        'Ngày',
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        'Tháng',
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        'Năm',
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                    onSelectedItemChanged: (int value) {
                      setState(() {
                        selectedUnit = ['Ngày', 'Tháng', 'Năm'][value];
                      });
                    },
                  ),
                ),
              ),
            ]),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      widget.onIntensitySelected(
                          intensitySelected, selectedUnit);
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

void ShowIntensitySelected(
    BuildContext context, Function(int, String) onIntensitySelected) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: EditPageScrollSelectintensity(
          onIntensitySelected: onIntensitySelected,
        ),
      );
    },
  );
}
