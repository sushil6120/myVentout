import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/Utils/config.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:overcooked/newFlow/sessionCreatingWidget.dart';
import 'package:overcooked/newFlow/viewModel/razorPayviewModel.dart';
import 'package:overcooked/newFlow/viewModel/sessionViewModel.dart';
import 'package:overcooked/newFlow/viewModel/walletViewModel.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import '../services/app_url.dart';

class AmountAddSheet extends StatefulWidget {
  String? token, sessionTime;
  int amount;
  String? id;
  bool? isInstant;
  dynamic commissionValue;
  String? slotId, userId;
  String amountFees;
  AmountAddSheet(
      {super.key,
      required this.amountFees,
      this.token,
      required this.amount,
      required this.sessionTime,
      required this.userId,
      this.commissionValue,
      this.isInstant,
      this.id,
      this.slotId});
  @override
  _AmountAddSheetState createState() => _AmountAddSheetState();
}

class _AmountAddSheetState extends State<AmountAddSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // int _selectedAmount = 100;

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    // _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("✅ Payment Success Triggered");
    print('🧾 Payment ID: ${response.paymentId}');

    try {
      final walletData = Provider.of<WalletViewModel>(context, listen: false);
      final sessionData = Provider.of<SessionViewModel>(context, listen: false);

      if (kDebugMode) {
        print("📤 Calling addMoneyApis with:");
        print("  ➤ amount: ${widget.amount.toInt()}");
        print("  ➤ token: ${widget.token.toString()}");
        print("  ➤ isSuccess: true");
      }

      await walletData.addMoneyApis(
        widget.amount.toInt(),
        widget.token.toString(),
        true,
        true,
        context,
      );

      if (kDebugMode) {
        print("✅ addMoneyApis Result: ");

        print("📤 Calling BookSessionApis with:");
        print("  ➤ amount: ${widget.amount.toString()}");
        print("  ➤ therapistId: 55");
        print("  ➤ dateTime: ${DateTime.now().toString()}");
        print("  ➤ token: ${widget.token}");
        print("  ➤ sessionId: ${widget.id}");
        print("  ➤ userId: ${widget.userId.toString()}");
        print("  ➤ isInstant: ${widget.isInstant}");
        print("  ➤ callType: Video Call");
        print("  ➤ slotId: ${widget.slotId}");
      }

      await sessionData.BookSessionApis(
        widget.amountFees.toString(),
        "55",
        DateTime.now().toString(),
        widget.token,
        widget.id,
        widget.userId.toString(),
        false,
        "Video Call",
        context,
        widget.slotId,
      );

      print("✅ BookSessionApis Result:");
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e, stack) {
      print("❌ Error in payment success handling: $e");
      print(stack);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(
        'Payment failed! Code: ${response.code}, Message: ${response.message}');
    //      Get.to(SessionCreationScreen(
    //   amountFees: widget.amountFees,
    //   amount: widget.amount,
    //   sessionTime: "55",
    //   userId: widget.userId.toString(),
    //   commissionValue: widget.commissionValue,
    //   id: widget.id,
    //   isInstant: false,
    //   slotId: widget.slotId,
    //   token: widget.token,
    // ));
    final walletData = Provider.of<WalletViewModel>(context, listen: false);
    double amountToAdd;
    walletData.addMoneyApis(
        widget.amount.toInt(), widget.token.toString(), false, false, context);
  }

  void _openRazorpayCheckout(totalPrice) async {
    final razorApi = Provider.of<RazorPayViewzModel>(context, listen: false);
    SharedPreferencesViewModel sharedPreferencesViewModel =
        SharedPreferencesViewModel();
    String? name = await sharedPreferencesViewModel.getUserName();
    String? number = await sharedPreferencesViewModel.getUserNumber();
    razorApi.setLoading(true);

    final response = await http.post(
      Uri.parse(AppUrl.createPaymentApi),
      body: jsonEncode({"amount": totalPrice, "currency": "INR"}),
      headers: {
        "Content-type": "application/json",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      if (kDebugMode) {
        print('hhhkkk' + response.body);
        print('OrderId : ${data['orderId']}');
      }
      razorApi.setLoading(false);
      final options = {
        'key': razorKey,
        'amount': (totalPrice * 100).toString(),
        'name': 'Overcooked',
        'order_id': data['orderId'],
        'image': 'https://i.ibb.co/prjMQV15/IMG-9789-1.png',
        'theme': {'color': '#000000'},
        'description': 'Overcooked Payment',
        'prefill': {'contact': number, 'email': name},
        'external': {
          'wallets': ['paytm', 'phonepe'],
        }
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        razorApi.setLoading(false);
        print('Error initiating payment: $e');
      }
    } else {
      razorApi.setLoading(false);
      print('hhhkkk' + response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: Image.asset(
                        width: width * 0.082,
                        height: height * 0.015,
                        'assets/img/Rectangle.png'),
                  ),
                  SizedBox(height: height * 0.02),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Your session will be confirmed once the your payment has been processed.',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: darkModePrimaryTextColor,
                      ),
                    ),
                  ),
                  Text(
                    "Note: your payment includes session plus ${widget.commissionValue}% convenience charges.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: darkModeTextLight3,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 40),
                    child: Consumer<WalletViewModel>(
                      builder: (context, value, child) {
                        return GestureDetector(
                          onTap: () {
                            if (widget.amount != 0) {
                              print("  ➤ amount: ${widget.amount.toInt()}");
                              _openRazorpayCheckout(widget.amount);
                            } else {
                              final sessionData = Provider.of<SessionViewModel>(
                                  context,
                                  listen: false);
                              sessionData.BookSessionApis(
                                  widget.amountFees.toString(),
                                  "55",
                                  DateTime.now().toString(),
                                  widget.token,
                                  widget.id,
                                  widget.userId.toString(),
                                  false,
                                  "Video Call",
                                  context,
                                  widget.slotId);
                              Navigator.pop(context);
                            }
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: context.width * 0.8,
                              height: 52,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: greenColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(60))),
                              child: value.isLoading == true
                                  ? CupertinoActivityIndicator(
                                      color: primaryColorDark)
                                  : Text(
                                      "Click to pay ₹${widget.amount}",
                                      style: TextStyle(
                                          color: primaryColorDark,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Consumer<WalletViewModel>(
          builder: (context, walletModel, _) {
            return SessionCreationOverlay(
              isLoading: walletModel.isLoading,
              message: "Processing Payment",
            );
          },
        ),
      ],
    );
  }
}
