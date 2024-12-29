import 'package:flutter/material.dart';

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/loading_progress.gif',
            height: 100,
            width: 100,
          ),
          const SizedBox(height: 10),
          // const Text(
          //   'Loading...',
          //   style: TextStyle(color: Colors.white, fontSize: 16),
          // ),
        ],
      ),
    );
  }
}
