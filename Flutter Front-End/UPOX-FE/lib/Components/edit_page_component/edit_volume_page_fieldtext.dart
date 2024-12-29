import 'dart:developer';

import 'package:first_app/Components/edit_page_component/SelectHistoryComponent/edit_select_history.dart';
import 'package:first_app/View_Page/edit_page_comboView/edit_main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EditVolumePageFieldtext extends StatefulWidget {

  Map<String,List<int>> volumeSuggested;
  //volumeUnit hiển thị
  String volumeUnit = "";
  int? editedVolume;
  
  EditVolumePageFieldtext(this.volumeSuggested, this.volumeUnit, {super.key});
  EditVolumePageFieldtext.isEdited(this.volumeSuggested, this.volumeUnit, this.editedVolume, {super.key});

  @override
  State<EditVolumePageFieldtext> createState() => _EditVolumePageFieldtext();
}

class _EditVolumePageFieldtext extends State<EditVolumePageFieldtext> {
  //? Controller để tạo event cho textfield
  final TextEditingController _volumeController = TextEditingController();
  String selectedVolume =
      ""; // Giá trị để hiển thị trong Container phía dưới
  String local_volumeUnit = "";
  
  
  //? Hàm xử lý khi chọn từ SelectHistoryOption
  void _updateTextField(String volume) {
    setState(() {
      _volumeController.text = volume;
    });
  }

  //? Hàm xử lý khi bấm xác nhận
  void _confirmSelection() {
    setState(() {
      selectedVolume =
          _volumeController.text.isEmpty ? "" : _volumeController.text;
    });
    // Trả về giá trị đã chọn/nhập
    Navigator.pop(context, selectedVolume);
  }

  List<Container> _buildSuggestion(double width, double height){
    List<int> commonSuggestion = widget.volumeSuggested["common"]!;
    List<int> lessCommonSuggestion = [];

    if(widget.volumeSuggested.containsKey("lessCommon")){
      lessCommonSuggestion = widget.volumeSuggested["lessCommon"]!;
      log(lessCommonSuggestion[0].toString());
    }
    int sizeCommonSug = commonSuggestion.length;
    int sizeLessCommonSug = lessCommonSuggestion.length;
    int count = sizeCommonSug + sizeLessCommonSug;
    log("sizeCommonSug: ${sizeCommonSug.toString()}");
    log("sizeLessCommonSug: ${sizeLessCommonSug.toString()}");
    log("count: ${count.toString()}");

    List<Container> suggestionList = [];

    for(int i = 0; i < count; i++){
      int index = i - sizeCommonSug;
      if (i == sizeCommonSug && index < sizeLessCommonSug){ //Less common Container
        
        log("index: ${index.toString()}");

        suggestionList.add(
          Container(
            child: SelectHistoryButton(
            text: "${lessCommonSuggestion[index]} $local_volumeUnit", //Xử lý đơn vị hiển thị
            backgroundColor: Colors.white,
            borderColor: const Color(0xff18A0FB),
            textColor: const Color(0xff18A0FB),
            width: width * 0.2,
            height: height * 0.04,
            onPressed: () {
              _updateTextField("${lessCommonSuggestion[index]}");
            },
          ),
          )
        );
      }
      else if(i < sizeCommonSug){ //Common Container
        log("i: ${i.toString()}");

        suggestionList.add(Container(
          margin:  EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.03,
            ),
          child: SelectHistoryButton(
            text: "${commonSuggestion[i]} $local_volumeUnit", //Xử lý đơn vị hiển thị
            backgroundColor: const Color(0xff18A0FB),
            borderColor: Colors.transparent,
            textColor: Colors.white,
            width: width * 0.25,
            height: height * 0.04,
            iconPath: "assets/heart_icon.png",
            iconColor: const Color(0xff68C2FE),
            onPressed: () {
              _updateTextField("${commonSuggestion[i]}");
            },
          ),
        ));
      }
    }
    return suggestionList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    local_volumeUnit = widget.volumeUnit;
    if(widget.editedVolume != null){
      _volumeController.text = widget.editedVolume.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Container(
      height: height * 0.86,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          child: Column(children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(right: 20, left: 5),
              child: TextField(
                // Chỉ user nhập số thôi nên khỏi phải sợ bị phá nhé
                controller: _volumeController, // Controller
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  hintText: 'Khối lượng tịnh ($local_volumeUnit)',
                  hintStyle: const TextStyle(
                      color: Color(0xffDEDEDE),
                      fontSize: 25,
                      fontFamily: "inter",
                      fontWeight: FontWeight.w700),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Color(0xffDEDEDE),
                    size: 30,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffDEDEDE)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffDEDEDE)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
                margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.73),
                child: Text("*Ví dụ: 170 $local_volumeUnit",
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xff18A0FB),
                        fontFamily: "intern",
                        fontStyle: FontStyle.italic))),
            const SizedBox(height: 15),
            // ** Select HistoryOption
            Container(
                child: Column(children: [
              // Row 1
              Row(
                children: [
                  Container(
                      child: const Text(
                    "Khối lượng tịnh thường được dùng",
                    style: TextStyle(
                        fontFamily: "inter",
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  )),
                  const SizedBox(width: 10),
                  Container(
                    child: Image.asset(
                      "assets/heart_icon.png",
                      width: width * 0.05,
                      height: height * 0.05,
                    ),
                  )
                ],
              ),
              // Row 2
              const SizedBox(height: 10),
              Row(
                children: _buildSuggestion(width, height)
                // [
                //   // Volume 1  --- 100g
                //   SelectHistoryButton(
                //     text: "100 g",
                //     backgroundColor: const Color(0xff18A0FB),
                //     borderColor: Colors.transparent,
                //     textColor: Colors.white,
                //     width: width * 0.2,
                //     height: height * 0.03,
                //     iconPath: "assets/clock_icon.png",
                //     onPressed: () {
                //       _updateTextField("100");
                //     },
                //   ),
                //   const SizedBox(width: 10),
                //   // Volume 2 --- 50g
                //   SelectHistoryButton(
                //     text: "500 g",
                //     backgroundColor: const Color(0xff18A0FB),
                //     borderColor: Colors.transparent,
                //     textColor: Colors.white,
                //     width: width * 0.2,
                //     height: height * 0.03,
                //     iconPath: "assets/heart_icon.png",
                //     iconColor: const Color(0xff68C2FE),
                //     onPressed: () {
                //       _updateTextField("500");
                //     },
                //   ),
                //   const SizedBox(width: 10),
                //   // Volume 3  --- 40g
                //   SelectHistoryButton(
                //     text: "40 g",
                //     backgroundColor: Colors.white,
                //     borderColor: Colors.blue,
                //     textColor: Colors.blue,
                //     width: width * 0.15,
                //     height: height * 0.03,
                //     // iconPath: "assets/heart_icon.png",
                //     // iconColor: const Color(0xff68C2FE),
                //     onPressed: () {
                //       _updateTextField("40");
                //     },
                //   ),
                //   const SizedBox(width: 10),
                //   // Volume 4 --- 130g
                //   SelectHistoryButton(
                //     text: "130 g",
                //     backgroundColor: Colors.white,
                //     borderColor: Colors.blue,
                //     textColor: Colors.blue,
                //     width: width * 0.15,
                //     height: height * 0.03,
                //     // iconPath: "assets/heart_icon.png",
                //     // iconColor: const Color(0xff68C2FE),
                //     onPressed: () {
                //       _updateTextField("130");
                //     },
                //   ),
                // ],
              ),
            ]))
          ]),
        ),
        const SizedBox(height: 20),
        // ** Container  --> Confirm button
        Container(
          child: TextButton(
            onPressed: _confirmSelection,
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(266, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: const Text("Xác Nhận!",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                )),
          ),
        ),
      ]),
    );
  }
}
