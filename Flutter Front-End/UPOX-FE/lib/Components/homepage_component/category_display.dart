import 'package:first_app/Components/homepage_component/component/category.dart';
import 'package:first_app/model/warning_categories.dart';
import 'package:flutter/material.dart';

class CategoryDisplay extends StatefulWidget {
  List<WarningCategories>? warningCategories = [];
  CategoryDisplay(this.warningCategories , {super.key});

  @override
  State<CategoryDisplay> createState() => _CategoryDisplayState();
}

class _CategoryDisplayState extends State<CategoryDisplay> {

    List<Container> _buildListOfCategories (){
    String originImagePath = "assets/category";
    String originStatusPath = "assets/status";

    return List.generate(widget.warningCategories!.length, 
      (i) => Container(
        child: Category(onPressed: (){},
        categoryBanner: "$originImagePath${widget.warningCategories![i].imagePath}.png",
        categoryStatus: "$originStatusPath${widget.warningCategories![i].statusname}.png",)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      // color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildListOfCategories(),
      ),
    );
  }
}
