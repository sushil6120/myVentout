import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/Utils/config.dart';
import 'package:overcooked/Utils/utilsFunction.dart';
import 'package:overcooked/newFlow/viewModel/paymentGateWayClass.dart';
import 'package:overcooked/newFlow/viewModel/razorPayviewModel.dart';
import 'package:overcooked/newFlow/viewModel/sessionViewModel.dart';
import 'package:overcooked/newFlow/viewModel/walletViewModel.dart';
import 'package:overcooked/Utils/components.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import '../services/app_url.dart';

class AmountAddSheet extends StatefulWidget {
  String? token, sessionTime;
  dynamic amount;
  String? id;
  bool? isInstant;
  dynamic commissionValue;
  String? slotId;
  AmountAddSheet(
      {super.key, this.token, required this.amount, required this.sessionTime,  this.commissionValue,  this.isInstant, this.id, this.slotId});
  @override
  _AmountAddSheetState createState() => _AmountAddSheetState();
}

class _AmountAddSheetState extends State<AmountAddSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // int _selectedAmount = 100;

  PaymentGateway paymentGateway = PaymentGateway();
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

  void _handlePaymentSuccess(PaymentSuccessResponse paymentSuccessResponse) {
    print(
        'Payment successful! Payment ID: ${paymentSuccessResponse.paymentId}');
    final walletData = Provider.of<WalletViewModel>(context, listen: false);
    final sessionData = Provider.of<SessionViewModel>(context, listen: false);

    // Determine the amount to be added
    double amountToAdd;

    // Check if the user entered an amount in the text field
    // if (_selectedAmount.toString().isNotEmpty) {
    //   amountToAdd = double.tryParse(_selectedAmount.toString()) ?? 0;
    // } else {
    //   // If the user did not enter an amount, use the selected amount
    //   amountToAdd = _selectedAmount.toDouble() ?? 0;
    // }

    // Call the API to add money to the wallet

    sessionData.BookSessionApis(widget.amount.toString(), "55", DateTime.now().toString(), widget.token, widget.id, widget.isInstant!, "Video Call", context, widget.slotId);

    // walletData.addMoneyApis(
    //     amountToAdd.toInt(), widget.token.toString(), true, context);


  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(
        'Payment failed! Code: ${response.code}, Message: ${response.message}');
    final walletData = Provider.of<WalletViewModel>(context, listen: false);

    // Determine the amount to be added
    double amountToAdd;

    // Check if the user entered an amount in the text field
    // if (_selectedAmount.toString().isNotEmpty) {
    //   amountToAdd = double.tryParse(_selectedAmount.toString()) ?? 0;
    // } else {
    //   // If the user did not enter an amount, use the selected amount
    //   amountToAdd = _selectedAmount.toDouble() ?? 0;
    // }

    // Call the API to add money to the wallet
    // walletData.addMoneyApis(
    //     amountToAdd.toInt(), widget.token.toString(), false, context);
  }

  void _openRazorpayCheckout(totalPrice) async {
    final razorApi = Provider.of<RazorPayViewzModel>(context, listen: false);

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
      }
      razorApi.setLoading(false);
      final options = {
        'key': razorKey,
        'amount': (totalPrice * 100).toString(),
        'name': 'VentOut',
        'order_id': data['orderId'],
        'image': 'https://i.ibb.co/WBTySmF/AppIcon.png',
        'theme': {'color': '#000000'},
        'description': 'Ventout Payment',
        'prefill': {'contact': '9810417636', 'email': 'sharma@swayye.club'},
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

    return BackdropFilter(
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
                  fontSize: 16,
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
                          _openRazorpayCheckout(widget.amount);
                        } else {
                          print("wokring now");
                          final sessionData = Provider.of<SessionViewModel>(context, listen: false);
                          sessionData.BookSessionApis(widget.amount.toString(), "55", DateTime.now().toString(), widget.token, widget.id, widget.isInstant!, "Video Call", context, widget.slotId);
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
                              borderRadius: const BorderRadius.all(Radius.circular(60))
                          ),
                          child: value.isLoading == true
                              ?  CupertinoActivityIndicator(color: primaryColorDark)
                              : Text(
                            "Click to pay ₹${widget.amount}",
                            style:  TextStyle(
                                color: primaryColorDark,
                                fontWeight: FontWeight.w500,
                                fontSize: 16
                            ),
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
    );
  }
}