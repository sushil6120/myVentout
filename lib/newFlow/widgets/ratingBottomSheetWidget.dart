import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventout/Utils/config.dart';
import 'package:ventout/Utils/utilsFunction.dart';
import 'package:ventout/newFlow/viewModel/paymentGateWayClass.dart';
import 'package:ventout/newFlow/viewModel/razorPayviewModel.dart';
import 'package:ventout/newFlow/viewModel/walletViewModel.dart';
import 'package:ventout/newFlow/widgets/color.dart';
import 'package:ventout/Utils/components.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart'as http;
import '../services/app_url.dart';

class AmountAddSheet extends StatefulWidget {
  String? token, sessionTime;
  int amount;
  AmountAddSheet(
      {super.key, this.token, required this.amount, required this.sessionTime});
  @override
  _AmountAddSheetState createState() => _AmountAddSheetState();
}

class _AmountAddSheetState extends State<AmountAddSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _selectedAmount = 100;

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

    // Determine the amount to be added
    double amountToAdd;

    // Check if the user entered an amount in the text field
    if (_selectedAmount.toString().isNotEmpty) {
      amountToAdd = double.tryParse(_selectedAmount.toString()) ?? 0;
    } else {
      // If the user did not enter an amount, use the selected amount
      amountToAdd = _selectedAmount.toDouble() ?? 0;
    }

    // Call the API to add money to the wallet
    walletData.addMoneyApis(
        amountToAdd.toInt(), widget.token.toString(), true, context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(
        'Payment failed! Code: ${response.code}, Message: ${response.message}');
    final walletData = Provider.of<WalletViewModel>(context, listen: false);

    // Determine the amount to be added
    double amountToAdd;

    // Check if the user entered an amount in the text field
    if (_selectedAmount.toString().isNotEmpty) {
      amountToAdd = double.tryParse(_selectedAmount.toString()) ?? 0;
    } else {
      // If the user did not enter an amount, use the selected amount
      amountToAdd = _selectedAmount.toDouble() ?? 0;
    }

    // Call the API to add money to the wallet
    walletData.addMoneyApis(
        amountToAdd.toInt(), widget.token.toString(), false, context);
  }

  void _openRazorpayCheckout(double totalPrice) async {
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Minimum balance of ${widget.sessionTime} minutes (INR ${widget.amount}) is required to start chat with the counselor',
                  style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                      color: Color(0xffFF5C5C)),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Recharge Now',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4.0),
                const Text(
                  '💡 Tip: 90% users recharge for 10 mins or more',
                  style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    for (var amount in [100, 200, 500, 1000, 2000, 3000, 4000])
                      ChoiceChip(
                        padding: EdgeInsets.zero,
                        label: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff1A1C21),
                            boxShadow: [
                              BoxShadow(
                                  color: _selectedAmount == amount
                                      ? greenColor
                                      : Colors.transparent,
                                  blurRadius: 1,
                                  offset: const Offset(0, .8),
                                  spreadRadius: 0.8)
                            ],
                            gradient: _selectedAmount == amount
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xff003D2A),
                                      Color(0xff003D2A)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 9, horizontal: 24),
                          child: Text(
                            '₹ $amount',
                            style: TextStyle(
                              fontSize: 12,
                              color: _selectedAmount == amount
                                  ? greenColor
                                  : Colors.white,
                            ),
                          ),
                        ),
                        showCheckmark: false,
                        selectedShadowColor: greenColor,
                        selected: _selectedAmount == amount,
                        labelPadding: EdgeInsets.zero,
                        onSelected: (selected) {
                          setState(() {
                            _selectedAmount = (selected ? amount : null)!;
                          });

                          if (_selectedAmount != null) {
                            _openRazorpayCheckout(_selectedAmount.toDouble());
                          } else {
                            Utils.toastMessage('Select Amount!');
                          }
                        },
                        backgroundColor: const Color(0xff1A1C21),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: _selectedAmount == amount
                                  ? greenColor
                                  : Colors.white,
                              width: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Consumer<WalletViewModel>(
                  builder: (context, value, child) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_selectedAmount != null) {
                            _openRazorpayCheckout(_selectedAmount.toDouble());
                          } else {
                            Utils.toastMessage('Select Amount!');
                          }
                        },
                        child: Center(
                          child: value.isLoading == true
                              ? LoadingAnimationWidget.waveDots(
                                  color: Colors.white,
                                  size: 30,
                                )
                              : const Text(
                                  'Proceed to Pay',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffA2D9A0),
                            minimumSize: Size(width * 0.9, 50)),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
