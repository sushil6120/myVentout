import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../Utils/utilsFunction.dart';
import '../reposetries/razorPayRepo.dart';

class RazorPayViewzModel with ChangeNotifier {
  final RazorPayRepo razorPayRepo;
  RazorPayViewzModel(this.razorPayRepo);
  bool isLoading = false;

  String? orderId;

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> capturePaymentApi(
      String amount, paymnetId, BuildContext context) async {
    try {
      await razorPayRepo.capturePaymentApi(amount, paymnetId, context);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
