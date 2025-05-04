import 'dart:io';

import 'package:flutter/material.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/Utils/utilsFunction.dart';
import 'package:overcooked/newFlow/paymentLogsScreen.dart';
import 'package:overcooked/newFlow/routes/routeName.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:overcooked/newFlow/shimmer/walletHistoryShimmer.dart';
import 'package:overcooked/newFlow/viewModel/walletViewModel.dart';
import 'package:overcooked/newFlow/walletTransactionItemWidget.dart';
import 'package:overcooked/newFlow/widgets/color.dart';
import 'package:provider/provider.dart';

class WalletHistoryScreen extends StatefulWidget {
  Map<String, dynamic>? arguments;
  WalletHistoryScreen({super.key, this.arguments});
  @override
  State<WalletHistoryScreen> createState() => _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends State<WalletHistoryScreen> {
  int currentIndex = 0;

  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();

  String? token;
  double? balance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var amount = widget.arguments!['balance'];
    balance = double.tryParse(amount);
    final walletData = Provider.of<WalletViewModel>(context, listen: false);

    Future.wait([sharedPreferencesViewModel.getToken(), sharedPreferencesViewModel.getUserId()]).then((value) {
      token = value[0];
      walletData.fetchWalletHistoryAPi(value[1].toString());
      walletData.fetchPaymentLogAPi(token.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
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
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new_rounded)),
            backgroundColor: Colors.transparent,
            centerTitle: false,
            title: const Text(
              'Wallet history',
              style: TextStyle(fontSize: 22),
            ),
          ),
          body: Consumer<WalletViewModel>(
            builder: (context, value, child) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Available balance',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '₹ ${balance!.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              print('tap');

                              Navigator.pushNamed(
                                  context, RoutesName.AddMoneyScreen,
                                  arguments: {'balance': balance!.toInt()});
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 6),
                              margin: EdgeInsets.only(
                                  right: Platform.isAndroid ? 28 : 16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: buttonColor),
                              child: const Center(
                                  child: Text(
                                'Recharge',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              )),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndex = 0;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.03,
                                  vertical: MediaQuery.of(context).size.height *
                                      0.008,
                                ),
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: currentIndex == 0
                                      ? Color(0xff003d2a)
                                      : Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    'Wallet transactions',
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                              .size
                                              .width *
                                          (Platform.isAndroid ? 0.03 : 0.03),
                                      color: currentIndex == 0
                                          ? primaryColor
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndex = 1;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.03,
                                  vertical: MediaQuery.of(context).size.height *
                                      0.008,
                                ),
                                margin: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: currentIndex == 1
                                      ? Color(0xff003d2a)
                                      : Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    'Payment logs',
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                              .size
                                              .width *
                                          (Platform.isAndroid ? 0.03 : 0.03),
                                      color: currentIndex == 1
                                          ? primaryColor
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      currentIndex == 0
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: value.walletHistoryData.length,
                                itemBuilder: (context, index) {
                                  var item =
                                      value.walletHistoryData.reversed.toList();
                                  return value.isHistoryLoading == true
                                      ? ShimmerWalletTransactionItem()
                                      : WalletTransactionItem(
                                        transactionId:item[index].sId ,
                                        duration:'10' ,
                                          name: item[index].transactionWith ==
                                                  null
                                              ? 'Deleted Therapist'
                                              : item[index]
                                                  .transactionWith!
                                                  .name,
                                          date: item[index]
                                              .createdAt!
                                              .wellFormattedDate,
                                          price: item[index]
                                              .transactionAmount
                                              .toString(),
                                        );
                                },
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: value.paymentLogData.length,
                                itemBuilder: (context, index) {
                                  var item =
                                      value.paymentLogData.reversed.toList();
                                  return value.isHistoryLoading == true
                                      ? ShimmerWalletTransactionItem()
                                      : PaymentLogsScreen(
                                          time: item[index]
                                              .createdAt!
                                              .wellFormattedDate,
                                          price: item[index]
                                              .transactionAmount
                                              .toString(),
                                        );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
