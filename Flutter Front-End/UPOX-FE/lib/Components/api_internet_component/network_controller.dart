import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:first_app/Components/Alert_Component/time_out_connection/time_out_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  BuildContext? _dialogContext;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResults) {
    // check kết nối wifi
    if (connectivityResults.isEmpty ||
        connectivityResults.contains(ConnectivityResult.none)) {
      if (_dialogContext == null) {
        showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            _dialogContext = context;
            return const TimeOutAlert();
          },
        );
      }
    } else {
      if (_dialogContext != null) {
        Navigator.of(_dialogContext!).pop();
        _dialogContext = null;
      }
    }
  }
}
