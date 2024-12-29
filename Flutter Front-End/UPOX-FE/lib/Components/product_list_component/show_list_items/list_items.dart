import 'package:flutter/material.dart';

class ListItems extends StatelessWidget {
  String? imageList = "";
  String? imageTag;
  String? statusTag;
  String? itemName = "";
  String? expireDate = "";
  String? quantity = "";
  VoidCallback onPressed;
  ListItems({
    super.key,
    required this.imageList,
    required this.imageTag,
    required this.statusTag,
    required this.itemName,
    required this.expireDate,
    required this.quantity,
    required this.onPressed,
  });

  ListItems.notOpened({
    super.key,
    required this.imageList,
    required this.itemName,
    required this.expireDate,
    required this.quantity,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    String originalImagePath = "assets/product";
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return // Item 1
        Container(
          margin: EdgeInsets.only(bottom: height * 0.02),
          child: TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
            minimumSize: Size(width * 0.09, height * 0.09),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.white),
                child: 
                Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // INFORMATIONS 1 ==> Imag for items
            Container(
              
              child: Image.asset(
                "$originalImagePath$imageList.png",
                width: width * 0.2,
                height: height * 0.1,
              ),
            ),
            // INFORMATIONS 2 ==> Content username and expired Date for items
            Container(
              child: Column(
                children: [
                // Text and Tag
                statusTag == null
                  ?Container()
                  :Container( //Tag)
                    // color: Colors.amber,
                    margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.13,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          imageTag.toString(),
                          width: width * 0.045,
                          height: height * 0.02,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          statusTag.toString(),
                          style: const TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Color(0xff363636),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // items name
                  Container(
                    width: width*0.35,
                    // color: Colors.amber,
                    child: Text(
                      itemName.toString(),
                      style: const TextStyle(
                          fontFamily: "inter",
                          fontWeight: FontWeight.w400,
                          color: Color(0xff000000),
                          fontSize: 16),
                    ),
                  ),
                  // items Date Expire
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                      const TextSpan(
                          text: "HSD: ",
                          style: TextStyle(
                            fontFamily: "inter",
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xff000000),
                          )),
                      // Date must be Covert to String here
                      TextSpan(
                          text: expireDate,
                          style: const TextStyle(
                            fontFamily: "inter",
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xff000000),
                          ))
                    ]),
                  )
                ],
              )
            ),
            // INFORMATIONS 3 ==> number of items
            Container(
              child: RichText(
                text: TextSpan(children: <TextSpan>[
                  const TextSpan(
                    text: "x",
                    style: TextStyle(
                        fontFamily: "inter",
                        fontSize: 20,
                        color: Color(0xffABABAB),
                        fontWeight: FontWeight.w700),
                  ),
                  // Number of item should put in here!
                  TextSpan(
                    text: quantity,
                    style: const TextStyle(
                        fontFamily: "inter",
                        fontSize: 20,
                        color: Color(0xffABABAB),
                        fontWeight: FontWeight.w700),
                  ),
                ]),
              ),
            ),
          ],
                ),
              ),
        );
  }
}
