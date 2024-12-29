import 'package:flutter/material.dart';

class MyLogo extends StatefulWidget {
  const MyLogo({super.key});

  @override
  State<MyLogo> createState() => _MyLogoState();
}

class _MyLogoState extends State<MyLogo> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
              const Text("UPOX", style:TextStyle( //Child 1
                  // backgroundColor: Color(0xFFAAAAAA),
                  color: Color(0xffFFFFFF), //FFFFFF
                  fontWeight: FontWeight.bold,
                  fontSize: 55.0,
                  fontFamily: 'LogoFont',
                  letterSpacing: 0.67,
                  shadows: [
                    Shadow(
                      color: Color(0x403C62EB),
                      blurRadius: 6,
                      offset: Offset(0, 4)
                    )
                  ])
                ),
                	SizedBox( //Child 2
                  height: screenHeight * 0.12,
                  width: screenWidth * 0.3,

                  child: Stack(
                    children: [
                      Positioned(
                        top: -screenHeight * 0.039,
                        left: screenWidth * 0.043,
                        height: screenHeight * 0.21,
                        width: screenWidth * 0.21,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF79BEF7),
                            shape: BoxShape.circle),
                          ),
                          
                      ),
                      Positioned( 
                        top: -screenHeight * 0.05,
                        left: screenWidth * 0.044,
                        height: screenHeight * 0.21,
                        width: screenWidth * 0.21,
                        child: Image.asset("assets/Icon_box_lookDown.png"),
                      ),
                    ],
                  ),
                ),
            ],
          );
  }
}