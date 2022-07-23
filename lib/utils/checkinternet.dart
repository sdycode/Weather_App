import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

// class CheckInternet {
//   CheckInternet.ci();
//   static final CheckInternet instance = CheckInternet.ci();

//   Future<bool> check() async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       print('result $result');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         print('inside if');
//         return true;
//       }
//     } on SocketException catch (_) {
//       return false;
//     }
//     return false;
//   }
// }

Future<bool> checkConnectivityStatus() async {
  bool connected = false;
  await Connectivity().checkConnectivity().then((value) {
    if (value == ConnectivityResult.mobile ||
        value == ConnectivityResult.wifi) {
      connected = true;
    }
  });
  return connected;
}
