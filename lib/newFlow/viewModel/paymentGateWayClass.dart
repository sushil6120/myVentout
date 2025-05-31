// import 'package:flutter/material.dart';
// import 'package:overcooked/Utils/config.dart';
// import 'package:overcooked/newFlow/viewModel/walletViewModel.dart';
// import 'package:provider/provider.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class PaymentGateway {
//   late Razorpay _razorpay;

//   void handlePaymentSuccess(
//       PaymentSuccessResponse paymentSuccessResponse,
//       String amountController,
//       token,
//       double _selectedAmount,
//       BuildContext context) {
//     print(
//         'Payment successful! Payment ID: ${paymentSuccessResponse.paymentId}');
//     final walletData = Provider.of<WalletViewModel>(context, listen: false);

//     // Determine the amount to be added
//     double amountToAdd;

//     // Check if the user entered an amount in the text field
//     if (amountController.isNotEmpty) {
//       amountToAdd = double.tryParse(amountController) ?? 0;
//     } else {
//       // If the user did not enter an amount, use the selected amount
//       amountToAdd = _selectedAmount ?? 0;
//     }

//     // Call the API to add money to the wallet
//     walletData.addMoneyApis(
//         amountToAdd.toInt(), token.toString(), true, context);
//   }

//   void handlePaymentError(
//       PaymentFailureResponse response,
//       String amountController,
//       token,
//       double _selectedAmount,
//       BuildContext context) {
//     print(
//         'Payment failed! Code: ${response.code}, Message: ${response.message}');
//     final walletData = Provider.of<WalletViewModel>(context, listen: false);

//     // Determine the amount to be added
//     double amountToAdd;

//     // Check if the user entered an amount in the text field
//     if (amountController.isNotEmpty) {
//       amountToAdd = double.tryParse(amountController) ?? 0;
//     } else {
//       // If the user did not enter an amount, use the selected amount
//       amountToAdd = _selectedAmount ?? 0;
//     }

//     // Call the API to add money to the wallet
//     walletData.addMoneyApis(
//         amountToAdd.toInt(), token.toString(), false, context);
//   }

//   void openRazorpayCheckout(double totalPrice) {
//     final options = {
//       'key': razorKey,
//       'amount': (totalPrice * 100).toString(),
//       'name': 'VentOut',
//       'image': 'https://i.ibb.co/WBTySmF/AppIcon.png',
//       'theme': {'color': '#000000'},
//       'description': 'Test Payment',
//       'prefill': {'contact': '9810417636', 'email': 'sharma@swayye.club'},
//       'external': {
//         'wallets': ['paytm', 'phonepe'],
//       }
//     };

//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       print('Error initiating payment: $e');
//     }
//   }
// }
