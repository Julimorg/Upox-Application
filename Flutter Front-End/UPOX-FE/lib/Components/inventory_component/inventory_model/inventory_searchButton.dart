import 'package:first_app/View_Page/homepage_comboPage/inventory_comboPage/inventory_search_page.dart';
import 'package:first_app/model/track_user_product_response.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class InventorySearchButton extends StatelessWidget {
  late Function reloadProductList;
  late Map<String, dynamic> reloadSuggestionCategories;
  late List<TrackedUserProductResponse> reloadedProductList;
  late Map<String,bool> reloadedChosenFilters;


  InventorySearchButton({super.key});
  InventorySearchButton.search(this.reloadProductList, this.reloadSuggestionCategories,
  this.reloadedProductList, this.reloadedChosenFilters, {super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth * 0.9,
      height: screenHeight * 0.06,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              child: InventorySearchPage.search(reloadProductList, reloadSuggestionCategories, 
              reloadedProductList, reloadedChosenFilters),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 300),
            ),
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.search,
              color: Color(0xffababab),
              size: 35,
            ),
            const SizedBox(width: 8),
            const Text(
              "Tìm sản phẩm",
              style: TextStyle(
                fontFamily: "inter",
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Color(0xffababab),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
