import 'dart:io';

class CheckInternet {
  CheckInternet.ci();
  static final CheckInternet instance = CheckInternet.ci();

  Future<bool> check() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      print('result $result');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('inside if');
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
