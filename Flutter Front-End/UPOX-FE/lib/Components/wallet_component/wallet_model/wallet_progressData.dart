import 'dart:developer';

import 'package:first_app/Components/wallet_component/wallet_model/wallet_items_progressData.dart';
import 'package:flutter/material.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';

class WalletProgressdata extends StatefulWidget {

  Map<String, dynamic> categories = {};
  final VoidCallback onPressed;
  int totSpent = 0;
  String displayedMonth = "";
  String displayedYear = "";

  WalletProgressdata({super.key, required this.onPressed});
  WalletProgressdata.newCategories(this.categories, this.totSpent, this.displayedMonth, this.displayedYear,
  {super.key, required this.onPressed});

  @override
  State<WalletProgressdata> createState() => _WalletProgressdataState();
}

class _WalletProgressdataState extends State<WalletProgressdata> {

  //? Data Progress Bar
  List<Segment> segments = [];

  List<Color> defaultColors = [
    const Color(0xff92F9CE),
    const Color(0xff4AA8FF),
    const Color(0xff73D3FC),
    const Color(0xffFFABF7),
    const Color(0xffFF3850),
    const Color(0xffFFCD4C),
    const Color(0xffFF9D88),
  ];

  void _buildDisplayedSegment(){
    int size = widget.categories.length;
    int index = 0;
    widget.categories.forEach((key, value) {
      log("$key: ${value/widget.totSpent*100}");
      int percentage = (value/widget.totSpent*100).ceil();
      segments.add(
        Segment(value: percentage, 
        color: defaultColors[index])
      );
      index++;
    },);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _buildDisplayedSegment();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    //? Build ProgressBar
    final progressBar =
        PrimerProgressBar(segments: segments, showLegend: false);
    //? cho color từ segment sang WalletItemsProgressData
    WalletItemsProgressdata(
        widget.categories,
        widget.totSpent,
        widget.displayedMonth,
        widget.displayedYear,
        segmentColors: segments.map((segment) => segment.color).toList());

    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // TextButton chứa ProgressBar
          TextButton(
            onPressed: widget.onPressed,
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: progressBar,
          ),
          // Positioned( Tà đạo
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     height: 60,
          //     color: Colors.white,
          //   ),
          // ),
        ],
      ),
    );
  }
}
