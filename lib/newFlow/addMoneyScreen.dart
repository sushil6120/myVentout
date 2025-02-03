import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/Utils/config.dart';
import 'package:overcooked/Utils/responsive.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:overcooked/newFlow/viewModel/razorPayviewModel.dart';
import 'package:overcooked/newFlow/viewModel/utilsClass.dart';
import 'package:overcooked/newFlow/viewModel/walletViewModel.dart';
import 'package:overcooked/newFlow/widgets/amountWidget.dart';
import 'package:overcooked/newFlow/widgets/color.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'services/app_url.dart';

class AddMoneyScreen extends StatefulWidget {
  Map<String, dynamic>? arguments;
  AddMoneyScreen({super.key, this.arguments});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  TextEditingController amountController = TextEditingController();
  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();

  final List<double> _amounts = [
    100,
    500,
    1000,
    2000,
    3000,
    4000,
    8000,
    15000,
    20000,
    50000,
  ];

  late Razorpay _razorpay;
  double? _selectedAmount;
  double? balance;
  String? token;

  @override
  void initState() {
    super.initState();
    var amount = widget.arguments!['balance'];
    balance = double.tryParse(amount.toString());
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    Future.wait([sharedPreferencesViewModel.getToken()]).then((value) {
      token = value[0];
    });
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
    final razorData = Provider.of<RazorPayViewzModel>(context, listen: false);

    double amountToAdd;

    if (amountController.text.isNotEmpty) {
      amountToAdd = double.tryParse(amountController.text) ?? 0;
    } else {
      amountToAdd = _selectedAmount ?? 0;
    }
    // razorData
    //     .capturePaymentApi(
    //         amountToAdd.toString(), paymentSuccessResponse.paymentId, context)
    //     .then((value) {
    walletData.addMoneyApis(
        amountToAdd.toInt(), token.toString(), true, context);
    razorData.setLoading(false);
    // });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(
        'Payment failed! Code: ${response.code}, Message: ${response.message}');
    final walletData = Provider.of<WalletViewModel>(context, listen: false);
    final razorData = Provider.of<RazorPayViewzModel>(context, listen: false);

    double amountToAdd;

    if (amountController.text.isNotEmpty) {
      amountToAdd = double.tryParse(amountController.text) ?? 0;
    } else {
      amountToAdd = _selectedAmount ?? 0;
    }

    walletData.addMoneyApis(
        amountToAdd.toInt(), token.toString(), false, context);
    razorData.setLoading(false);
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
        print('OrderId : ${data['orderId']}');
      }
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
      if (kDebugMode) {
        print('hhhkkk' + response.body);
        print('hhhkkk' + response.statusCode.toString());
      }
      razorApi.setLoading(false);
      print('hhhkkk' + response.body);
    }
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final walletData = Provider.of<WalletViewModel>(context, listen: false);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/back-designs.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: false,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new_rounded)),
            title: Text(
              'Add money to wallet',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * .058,
                  color: Colors.white),
            ),
          ),
          body: Consumer<RazorPayViewzModel>(
            builder: (context, value, child) {
              return Stack(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              'Available balance',
                              style: GoogleFonts.inter(
                                fontSize:
                                    MediaQuery.of(context).size.width * .037,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '₹ ${balance!.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                  fontSize:
                                      MediaQuery.of(context).size.width * .11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              margin: EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter amount';
                                        }
                                      },
                                      controller: amountController,
                                      cursorColor: Colors.white,
                                      keyboardType: TextInputType.number,
                                      cursorHeight: 15,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: 'Enter Amount in INR',
                                        hintStyle: GoogleFonts.inter(
                                            color: Colors.grey.shade600,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .039,
                                            fontWeight: FontWeight.w300),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.transparent,
                                              width: .5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.transparent),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        double? amount = double.tryParse(
                                            amountController.text);
                                        // Proceed with the payment using the entered amount
                                        // walletData.addMoneyApis(
                                        //     amount!.toInt(), token.toString(), context);
                                        _openRazorpayCheckout(amount!);
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 8),
                                      margin: EdgeInsets.only(
                                          right: Platform.isAndroid ? 28 : 16),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: primaryColor),
                                      child: Center(
                                          child: Text(
                                        'Proceed',
                                        style: GoogleFonts.inter(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .036,
                                            color: Colors.black),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.0),
                            Expanded(
                              child: GridView.count(
                                crossAxisCount: 3,
                                crossAxisSpacing: 0.0,
                                mainAxisSpacing: 18.0,
                                childAspectRatio: .6 / .48,
                                shrinkWrap: true,
                                children:
                                    List.generate(_amounts.length, (index) {
                                  return AmountButton(
                                    amount: _amounts[index].toInt(),
                                    isSelected:
                                        _selectedAmount == _amounts[index],
                                    isMostPopular: _amounts[index] == 500,
                                    onTap: () {
                                      setState(() {
                                        _selectedAmount = _amounts[index];
                                        amountController
                                            .clear(); // Clear the text field when a button is tapped
                                      });
                                      _openRazorpayCheckout(
                                          _selectedAmount!.toDouble());
                                    },
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  value.isLoading == true
                      ? Container(
                          width: context.deviceWidth,
                          height: context.deviceHeight,
                          decoration:
                              BoxDecoration(color: colorDark1.withOpacity(.2)),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: colorLightWhite,
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              );
            },
          )),
    );
  }
}
