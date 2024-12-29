import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyLoadingScreen extends StatefulWidget {
  const MyLoadingScreen({super.key});

  @override
  State<MyLoadingScreen> createState() => _MyLoadingState();
}

class _MyLoadingState extends State<MyLoadingScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background_big.png"),
              fit: BoxFit.cover)
          ),
          child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text("UPOX", style:TextStyle( //Child 1
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
                  height: screenHeight * 0.2,
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
                        top: -screenHeight * 0.09,
                        left: -screenWidth * 0.001,
                        height: screenHeight * 0.3,
                        width: screenWidth * 0.3,
                        child: LottieBuilder.asset("assets/Lottie/icon_lookAround.json"),
                      ),
                      Positioned( 
                        top: -screenHeight * 0.04,
                        left: -screenWidth * 0.08,
                        height: screenHeight * 0.4,
                        width: screenWidth * 0.45,
                        child: LottieBuilder.asset("assets/Lottie/loading.json"),
                      ),
                    ],
                  ),
                ),
              ]
            ) 
            
        )
      );
  }
}