import 'dart:developer';

import 'package:first_app/Components/CommonComponent/textbutton_imageicon_left.dart';
import 'package:first_app/Components/CommonComponent/title_text.dart';
import 'package:first_app/Components/wallet_component/wallet_model/wallet_itemsData.dart';
import 'package:first_app/Components/wallet_component/wallet_model/wallet_items_progressData.dart';
import 'package:first_app/Components/wallet_component/wallet_model/wallet_progressData.dart';
import 'package:first_app/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';

//** NOTE
//** Đã fix trong UI của ProgressBar và WalletItemsProgressdata
class WalletPageContent extends StatefulWidget {
  Expense displayedExpense;
  DateTime displayedDate;
  Function reload;
  WalletPageContent(this.displayedExpense, this.displayedDate, this.reload,
      {super.key});

  @override
  State<WalletPageContent> createState() => _WalletPageContentState();
}

class _WalletPageContentState extends State<WalletPageContent> {
  //? Date Selection
  int selectedIndex = -1;
  bool isFirstTimeUse = false;
  String selectedMonth = "";
  String selectedYear = "";
  int NUM_DISPLAYED_DATES = 10;
  late DateTime INITIAL_DATE;

  int findIndex() {
    int local_monthIndex = widget.displayedDate.month - 1;
    int local_yearIndex = years.indexOf(widget.displayedDate.year.toString());

    int divided = 12;

    int index = local_yearIndex * divided + local_monthIndex;

    log("Month index: $local_monthIndex, Year index: $local_yearIndex");
    log("Index: $index");

    return index;
    // int monthIndex = index % months.length; //Lấy phần dư
    // int yearIndex = index ~/ months.length; //Lấy phần nguyên
    // log("Size: ${months.length * years.length}");
    // log("Index: $index");
    // log("Month index: $monthIndex, Year index: $yearIndex");
  }

  final List<String> years = List.generate(10, (index) {
    //10 năm bắt đầu từ năm hiện tại
    int currentYear = DateTime.now().year;
    log("Years: ${(currentYear + index).toString()}");
    return (currentYear + index).toString();
  });

  final List<String> months = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];

  void calculateInitialDate() {
    

    INITIAL_DATE = widget.displayedDate;
    DateTime subtractDate = DateTime.utc(INITIAL_DATE.year, INITIAL_DATE.month - 1, INITIAL_DATE.day);
    INITIAL_DATE = subtractDate;
    selectedIndex = 1;
  }

  //Ý tưởng: Bắt từ ngày INITIAL_DATE
  //Lấy range là hiển thị 10 ngày (NUM_DISPLAYED_DATES)
  //index[0, 9] ~ [0, NUM_DISPLAYED_DATES - 1]
  //Trả về showedDate = Date.utc(INITIAL_DATE.year, INITIAL_DATE.month + index)
  //("${showedDate.month}/${showedDate.year}")
  Widget _buildDisplayedDate() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: (NUM_DISPLAYED_DATES), //10 (NUM_DISPLAYED_DATES)
      //INITIAL_DATE
      itemBuilder: (context, index) {
        DateTime showedDate =
            DateTime(INITIAL_DATE.year, INITIAL_DATE.month + index, 1);
        log("INITIAL_DATE.month: ${showedDate.month}, INITIAL_DATE.year: ${showedDate.year}");
        bool isSelected = selectedIndex == index;
        log("Selected index: $selectedIndex - Index: $index");
        if (isSelected) {
          
          log("${showedDate.month}/${showedDate.year}");
        }

        return GestureDetector(
          onTap: () {
            DateTime newSelectionDate = showedDate;
            widget.reload(newSelectionDate);
            // setState(() {
            //   selectedIndex = index;

            // });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: TitleText(
              titleName: "${showedDate.month}/${showedDate.year}",
              textColor: isSelected ? Colors.blue : Colors.black,
              fontWeight: FontWeight.w700,
              fontFam: "Inter",
              fontSize: 15,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFirstTimeUse = widget.displayedExpense.limit == 0;
    selectedIndex = findIndex();
    // log("Calculate index: $selectedIndex");
    selectedMonth = widget.displayedDate.month.toString();
    selectedYear = widget.displayedDate.year.toString();
    calculateInitialDate();
  }

  @override
  Widget build(BuildContext context) {
    //? Định dạng tiền tệ bên ngoài
    log("Calculating");
    final limtiLeft =
        widget.displayedExpense.limit! - widget.displayedExpense.totSpent!;
    log("Done Calculating");
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final dinhmucconlai = formatter
        .format(limtiLeft); // --> định mức còn lại (định mức - tiêu dùng)

    final sodinhmuc =
        formatter.format(widget.displayedExpense.limit!); // --> số định mức
    final tieudung =
        formatter.format(widget.displayedExpense.totSpent!); // --> Tiêu dùng
    log("Done Setting up");

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        margin: const EdgeInsets.only(top: 5),
        child: Column(
          children: [
            // Title
            TitleText(
              titleName: isFirstTimeUse ? "Đã chi tiêu" : "Định mức còn lại",
              fontSize: 25,
              textColor: Color(0xff9F9F9F),
              fontFam: "Inter",
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 5),
            // Price - 1st
            TitleText(
              titleName: isFirstTimeUse ? tieudung : dinhmucconlai,
              fontSize: 30,
              textColor: isFirstTimeUse
                  ? const Color(0xff363636)
                  : const Color(0xffEB475B),
              fontFam: "Inter",
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 5),

            // Price - 2nd
            TitleText(
              titleName: isFirstTimeUse ? "Chưa có định mức" : sodinhmuc,
              fontSize: 20,
              textColor: const Color(0xffC3C3C3),
              fontFam: "Inter",
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 5),
            // Filter Tag
            (!isFirstTimeUse && limtiLeft < 0)
                ? TextbuttonImageiconLeft(
                    iconImage: "assets/tag_icon.png",
                    iconWidth: 20,
                    iconHeight: 20,
                    filterName: "Vượt định mức",
                    fontFamily: "Roboto",
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    textColor: const Color(0xffCF2127),
                    //(4D là giá trị alpha tương đương 30%).
                    backgroundColor: const Color(0x4DD3454A),
                    widthFactor: 0.4,
                    heightFactor: 0.04,
                    onPressed: () {},
                  )
                : Container(),
            const SizedBox(height: 10),

            // Scroll Select Date --> Month / Year //Test đã
            Container(
              width: screenWidth,
              height: screenHeight * 0.06,
              child: _buildDisplayedDate()
              // ListView.builder(
              //   scrollDirection: Axis.horizontal,
              //   itemCount:
              //       months.length * years.length, //10 (NUM_DISPLAYED_DATES)
              //   //INITIAL_DATE
              //   itemBuilder: (context, index) {
              //     int monthIndex = index % months.length; //Lấy phần dư
              //     int yearIndex = index ~/ months.length; //Lấy phần nguyên
              //     log("Size: ${months.length * years.length}");
              //     log("Index: $index");
              //     log("Month index: $monthIndex, Year index: $yearIndex");
              //     log("Selected index: $selectedIndex");
              //     bool isSelected = selectedIndex == index;
              //     if (isSelected) {
              //       log("Selected index: $selectedIndex");
              //       log("${months[monthIndex]}/${years[yearIndex]}");
              //     }

              //     return GestureDetector(
              //       onTap: () {
              //         DateTime newSelectionDate = DateTime(
              //             int.parse(years[yearIndex]),
              //             int.parse(months[monthIndex]),
              //             1);
              //         widget.reload(newSelectionDate);
              //         // setState(() {
              //         //   selectedIndex = index;

              //         // });
              //       },
              //       child: Container(
              //         padding: const EdgeInsets.symmetric(horizontal: 10),
              //         alignment: Alignment.center,
              //         decoration: BoxDecoration(
              //           border: Border(
              //             bottom: BorderSide(
              //               color:
              //                   isSelected ? Colors.blue : Colors.transparent,
              //               width: 2,
              //             ),
              //           ),
              //         ),
              //         child: TitleText(
              //           titleName: "${months[monthIndex]}/${years[yearIndex]}",
              //           textColor: isSelected ? Colors.blue : Colors.black,
              //           fontWeight: FontWeight.w700,
              //           fontFam: "Inter",
              //           fontSize: 15,
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ),

            const SizedBox(height: 10),
            // Data child of Scroll Date Selection

            (widget.displayedExpense.categories.isEmpty)
                ? Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.19),
                    child: const TitleText(
                      titleName: "Các khoản chi tiêu \nchưa được ghi nhận",
                      fontSize: 20,
                      textColor: const Color(0xffC3C3C3),
                      fontFam: "Inter",
                      fontWeight: FontWeight.w400,
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.all(15),
                    width: screenWidth * 1,
                    height: screenHeight * 0.45,
                    // color: Colors.amber,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TitleText(
                                titleName: "Tiêu dùng",
                                textColor: Color(0xff363636),
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                fontFam: "Inter",
                              ),
                              const SizedBox(height: 10),
                              // Data Price
                              TitleText(
                                titleName: tieudung,
                                textColor: const Color(0xffEB475B),
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                fontFam: "Inter",
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),

                        //?Progress Bar
                        //** Đã FIX */
                        Container(
                          child: WalletProgressdata.newCategories(
                            widget.displayedExpense.categories,
                            widget.displayedExpense.totSpent!,
                            selectedMonth,
                            selectedYear,
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  //** Đã FIX */
                                  return WalletItemsProgressdata(
                                    widget.displayedExpense.categories,
                                    widget.displayedExpense.totSpent!,
                                    selectedMonth,
                                    selectedYear,
                                    segmentColors: [],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        // const SizedBox(height: 20),
                      ],
                    ),
                  )
          ],
        ));
  }
}
