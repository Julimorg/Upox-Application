import 'dart:developer';

import 'package:first_app/Components/CommonComponent/title_text.dart';
import 'package:first_app/Components/edit_page_component/EditScroll_Model/edit_page_scroll_date_event.dart';
import 'package:first_app/Components/edit_page_component/EditScroll_Model/edit_page_scroll_price.dart';
import 'package:first_app/Components/edit_page_component/SelectHistoryComponent/edit_select_history.dart';
import 'package:first_app/model/payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EditPrice extends StatefulWidget {
  Map<String, List<int>> costSuggested; //Đổ dữ liệu
  String dateBought = "";
  int? editedCost;

  EditPrice(this.costSuggested, {super.key});
  EditPrice.isEdited(this.costSuggested, this.editedCost, this.dateBought,
      {super.key});

  @override
  State<EditPrice> createState() => _EditPrice();
}

class _EditPrice extends State<EditPrice> {
  //? Default Attributes
  String selectedImage = "assets/crash_banner.png";
  bool isBankingVisible = false;
  String tempSelectedImage = "";
  String formattedDate = "";

//? Controller để tạo event cho textfield
  final TextEditingController _priceController = TextEditingController();
  String selectPrice = "";

  //? Hàm xử lý khi chọn từ SelectHistoryOption
  void _updateTextField(String price) {
    setState(() {
      _priceController.text = price; // Cập nhật giá trị cho _priceController
    });
  }

  //? Hàm xử lý khi bấm xác nhận
  void _confirmSelection() {
    setState(() {
      selectPrice = _priceController.text.isEmpty ? "" : _priceController.text;
      //unknown
    });
    formattedDate = formattedDate.isEmpty
        ? DateFormat('dd/MM/yyyy').format(DateTime.now())
        : formattedDate;

    // Trả về giá trị đã chọn/nhập
    Payment payment = Payment(selectPrice, formattedDate);

    //Kết hợp hai giá trị selectPrice và formattedDate thành một class
    Navigator.pop(context, payment); // Trả về selectPrice
  }

  @override
  void dispose() {
    _priceController.dispose(); // Đừng quên dispose cho _priceController
    super.dispose();
  }

// ** Show Image Picker
  void _showPicker() async {
    String? selectedImage = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return const EditPageScrollPrice();
      },
    );

    if (selectedImage != null) {
      setState(() {
        this.selectedImage = selectedImage;
        isBankingVisible = (selectedImage == "assets/banking_banner.png");
      });
    }
  }

// ** Show Date Picker event
  void _showDatePicker() {
    showEditDateDialog(
      context,
      DateTime.now(),
      (selectedDate) {
        setState(() {
          log(selectedDate);
          formattedDate = selectedDate; // Cập nhật giá trị khi ngày đã chọn
        });
      },
    );
  }

  String turnToMoneyFormat(int moneyString) {
    final moneyFormat = NumberFormat.currency(locale: "vi_VN", symbol: "₫");
    return moneyFormat.format(moneyString);
  }

  List<Container> _buildCostSuggestion(double width, double height) {
    List<int> commonSuggestion = widget.costSuggested["common"]!;
    List<int> lessCommonSuggestion = [];

    if (widget.costSuggested.containsKey("lessCommon")) {
      lessCommonSuggestion = widget.costSuggested["lessCommon"]!;
    }
    int sizeCommonSug = commonSuggestion.length;
    int sizeLessCommonSug = lessCommonSuggestion.length;
    int count = sizeCommonSug + sizeLessCommonSug;

    List<Container> suggestionList = [];

    for (int i = 0; i < count; i++) {
      int index = i - sizeCommonSug;
      if (i == sizeCommonSug && index < sizeLessCommonSug) {
        //Less common Container

        suggestionList.add(Container(
          child: SelectHistoryButton(
            text: turnToMoneyFormat(
                lessCommonSuggestion[index]), //Xử lý đơn vị hiển thị
            backgroundColor: Colors.white,
            borderColor: const Color(0xff18A0FB),
            textColor: const Color(0xff18A0FB),
            width: width * 0.2,
            height: height * 0.04,
            onPressed: () {
              _updateTextField("${lessCommonSuggestion[index]}");
            },
          ),
        ));
      } else if (i < sizeCommonSug) {
        //Common Container
        suggestionList.add(Container(
          child: SelectHistoryButton(
            text:
                turnToMoneyFormat(commonSuggestion[i]), //Xử lý đơn vị hiển thị
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
    if (widget.editedCost != null) {
      _priceController.text = widget.editedCost.toString();
      if (widget.dateBought.isNotEmpty) {
        formattedDate = widget.dateBought;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Container(
      // color: Colors.amber,
      height: height * 0.86,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        // ** Container  --> TextField , ImagePicker, HistoryOptions
        Container(
          child: Column(children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(right: 20, left: 5),
              child: TextField(
                // Chỉ user nhập số thôi nên khỏi phải sợ bị phá nhé
                controller: _priceController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  hintText: 'Giá (₫)',
                  hintStyle: const TextStyle(
                      color: Color(0xffDEDEDE),
                      fontSize: 25,
                      fontFamily: "inter",
                      fontWeight: FontWeight.w700),
                  suffixIcon: IconButton(
                    icon: Image.asset(
                      selectedImage,
                      width: 30,
                      height: 30,
                    ),
                    onPressed:
                        () {}, //_showPicker, // Hiển thị picker khi bấm //Chỉ làm COD giai đoạn này
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
                //Ví dụ
                // color: Colors.amber,
                // width: width * 1.4,
                margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.68),
                child: const Text("*Ví dụ: 45,000 (₫)",
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xff18A0FB),
                        fontFamily: "intern",
                        fontStyle: FontStyle.italic))),
            const SizedBox(height: 15),
            Container(
                //Suggestion
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  // Row 1
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: const Text(
                        "Giá sản phẩm thường được mua",
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
                  Container(
                    child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _buildCostSuggestion(width, height)
                        // [
                        //   // Price Daily Use ---- 100,000 đ
                        //   SelectHistoryButton(
                        //     text: "100,000 đ",
                        //     backgroundColor: const Color(0xff18A0FB),
                        //     borderColor: Colors.transparent,
                        //     textColor: Colors.white,
                        //     width: width * 0.25,
                        //     height: height * 0.03,
                        //     iconPath: "assets/clock_icon.png",
                        //     onPressed: () {
                        //       _updateTextField("100000");
                        //     },
                        //   ),
                        //   // Price Favorite Use ---- 200,000 đ
                        //   SelectHistoryButton(
                        //     text: "200,000 đ",
                        //     backgroundColor: const Color(0xff18A0FB),
                        //     borderColor: Colors.transparent,
                        //     textColor: Colors.white,
                        //     width: width * 0.25,
                        //     height: height * 0.03,
                        //     iconPath: "assets/heart_icon.png",
                        //     iconColor: const Color(0xff68C2FE),
                        //     onPressed: () {
                        //       _updateTextField("200000 ");
                        //     },
                        //   ),
                        //   // Normal User ---- 150,000
                        //   SelectHistoryButton(
                        //     text: "150,000 đ",
                        //     backgroundColor: Colors.white,
                        //     borderColor: const Color(0xff18A0FB),
                        //     textColor: Colors.blue,
                        //     width: width * 0.2,
                        //     height: height * 0.03,
                        //     onPressed: () {
                        //       _updateTextField("150000");
                        //     },
                        //   ),
                        //   // Normal User ---- 400,000
                        //   SelectHistoryButton(
                        //     text: "450,000 đ",
                        //     backgroundColor: Colors.white,
                        //     borderColor: const Color(0xff18A0FB),
                        //     textColor: Colors.blue,
                        //     width: width * 0.2,
                        //     height: height * 0.03,
                        //     onPressed: () {
                        //       _updateTextField("450000");
                        //     },
                        //   ),
                        // ],
                        ),
                  ),
                  const SizedBox(height: 20),

                  // ** Show hoặc ẩn container khi select Image Picker
                  if (isBankingVisible)
                    Center(
                      child: Container(
                          // color: Colors.amber,
                          width: width * 0.9,
                          height: height * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // color: Colors.amber,
                                width: width * 0.8,
                                height: height * 0.1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset(
                                      "assets/clock_price_icon.png",
                                      width: 50,
                                      height: 50,
                                    ),
                                    const TitleText(
                                      titleName:
                                          "Có vẻ bạn đã thanh toán sản phẩm này rồi.\n Cho UPOX biết ngày bạn thanh toán nhé!",
                                      fontSize: 10,
                                      fontFam: "Inter",
                                      fontWeight: FontWeight.w400,
                                      textColor: const Color(0xff18A0FB),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/money_icon.png",
                                    color: const Color(0xff4490E8),
                                    height: height * 0.06,
                                    width: width * 0.06,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Ngày Thanh Toán!",
                                    style: TextStyle(
                                      fontFamily: "inter",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 5),
                              Container(
                                  // color: Colors.amber,
                                  width: width * 0.8,
                                  child: TextField(
                                    readOnly: true,
                                    onTap:
                                        _showDatePicker, // Mở dialog chọn ngày khi nhấn vào TextField
                                    decoration: InputDecoration(
                                      hintText: "dd/mm/yyyy",
                                      hintStyle: const TextStyle(
                                        color: Color(0xffA0A0A0),
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: Color(0xffF4F4F4),
                                        ),
                                      ),
                                      // Set màu border
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                            color: Color(0xffF4F4F4), width: 3),
                                      ),
                                    ),
                                    controller: TextEditingController(
                                        text: formattedDate),
                                    style: const TextStyle(
                                      color: Color(0xffA0A0A0),
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )),
                            ],
                          )),
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
