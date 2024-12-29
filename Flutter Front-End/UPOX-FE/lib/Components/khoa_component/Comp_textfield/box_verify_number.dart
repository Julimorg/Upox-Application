import 'package:first_app/Components/khoa_component/Comp_logic/list_square_filled.dart';
import 'package:first_app/Components/khoa_component/Comp_textfield/square_verify_number.dart';
import 'package:flutter/material.dart';

class MyBoxVerifyNumber extends StatefulWidget {
  final TextEditingController myControlleSquares;

  const MyBoxVerifyNumber({super.key, required this.myControlleSquares});

  @override
  State<MyBoxVerifyNumber> createState() => _MyBoxVerifyNumberState();
}

class _MyBoxVerifyNumberState extends State<MyBoxVerifyNumber> {
  bool isSelected = false;
  bool isFilled = false;
  final node1 = FocusNode();
  final node2 = FocusNode();
  final node3 = FocusNode();
  final node4 = FocusNode();

  final myControlNode1 = TextEditingController();
  final myControlNode2 = TextEditingController();
  final myControlNode3 = TextEditingController();
  final myControlNode4 = TextEditingController();

  final EntitySquareFilled _entity = EntitySquareFilled();

  void prepareNode() {
    myControlNode1.selection = TextSelection.fromPosition(
        TextPosition(offset: myControlNode1.text.length));

    myControlNode2.selection = TextSelection.fromPosition(
        TextPosition(offset: myControlNode2.text.length));

    myControlNode3.selection = TextSelection.fromPosition(
        TextPosition(offset: myControlNode3.text.length));

    myControlNode4.selection = TextSelection.fromPosition(
        TextPosition(offset: myControlNode4.text.length));

    List<FocusNode> lst = [node1, node2, node3, node4];
    _entity.createList(lst);
  }

  void updateOtpStringCode() {
    widget.myControlleSquares.text =
        "${myControlNode1.text}${myControlNode2.text}${myControlNode3.text}${myControlNode4.text}";
  }

  @override
  Widget build(BuildContext context) {
    prepareNode();

    //Gôm thành loop khởi tạo
    final dynamic mySquare1 = MySquareVerifyNumber(
      itsFocusNode: node1,
      nextFocusNode: node2,
      prevFocusNode: null,
      isFirstNode: true,
      isLastNode: false,
      nodeName: "node1",
      firstNode: node1,
      myController: myControlNode1,
      entity: _entity,
      callback: updateOtpStringCode,
    );

    final dynamic mySquare2 = MySquareVerifyNumber(
      itsFocusNode: node2,
      nextFocusNode: node3,
      prevFocusNode: node1,
      isFirstNode: false,
      isLastNode: false,
      nodeName: "node2",
      firstNode: node1,
      myController: myControlNode2,
      entity: _entity,
      callback: updateOtpStringCode,
    );

    final dynamic mySquare3 = MySquareVerifyNumber(
      itsFocusNode: node3,
      nextFocusNode: node4,
      prevFocusNode: node2,
      isFirstNode: false,
      isLastNode: false,
      nodeName: "node3",
      firstNode: node1,
      myController: myControlNode3,
      entity: _entity,
      callback: updateOtpStringCode,
    );

    final dynamic mySquare4 = MySquareVerifyNumber(
      itsFocusNode: node4,
      nextFocusNode: null,
      prevFocusNode: node3,
      isFirstNode: false,
      isLastNode: true,
      nodeName: "node4",
      firstNode: node1,
      myController: myControlNode4,
      entity: _entity,
      callback: updateOtpStringCode,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // AnimatedContainer( //Box1
        //   duration: const Duration(microseconds: 0),
        //   width: 50, height: 50,
        //   margin: const EdgeInsets.symmetric(vertical: 10),
        //   decoration: BoxDecoration(
        //     border: Border.all(strokeAlign: BorderSide.strokeAlignOutside, width: 2,color: !isSelected? Colors.white :const Color(0xFF18A0FB)),
        //     color: !isSelected? const Color(0xFFF1F2F4): Colors.white,
        //     borderRadius: const BorderRadius.all(Radius.circular(10))),
        //   child: TextFormField(
        //     onChanged: (value) => {
        //       if(value.length == 1){
        //         boxOnTap(),
        //         FocusScope.of(context).requestFocus(focus)
        //       }
        //     },
        //     textInputAction: TextInputAction.next,
        //     textAlign: TextAlign.center,
        //     showCursor: false,
        //     decoration: const InputDecoration(
        //       border: InputBorder.none,
        //       focusedBorder: InputBorder.none,
        //       enabledBorder: InputBorder.none,
        //       errorBorder: InputBorder.none,
        //       disabledBorder: InputBorder.none,
        //       hintStyle: TextStyle(color: Color(0xFF18A0FB))),
        //     style: const TextStyle(color: Color(0xFF18A0FB), fontSize: 23, fontWeight: FontWeight.w700,
        //     decoration: TextDecoration.none, decorationThickness: 0),
        //   ),
        // ),
        mySquare1,

        const SizedBox(width: 20),
        mySquare2,

        const SizedBox(width: 20),
        mySquare3,

        const SizedBox(width: 20),
        mySquare4,
      ],
    );
  }
}
