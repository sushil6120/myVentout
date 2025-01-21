import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:ventout/Utils/colors.dart';
import 'package:ventout/Utils/responsive.dart';
import 'package:ventout/Utils/utilsFunction.dart';
import 'package:ventout/newFlow/routes/routeName.dart';
import 'package:ventout/newFlow/shimmer/walletHistoryShimmer.dart';
import 'package:ventout/newFlow/viewModel/sessionViewModel.dart';
import 'package:ventout/newFlow/widgets/color.dart';
import 'package:provider/provider.dart';

import 'services/sharedPrefs.dart';

class SessionHistoryScreen extends StatefulWidget {
  @override
  State<SessionHistoryScreen> createState() => _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends State<SessionHistoryScreen> {
  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();

  String? balance, token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final sessiontData = Provider.of<SessionViewModel>(context, listen: false);

    Future.wait([sharedPreferencesViewModel.getUserId()]).then((value) {
      token = value[0];
      sessiontData.fetchSessionHistoryAPi(token.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'Order history',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Consumer<SessionViewModel>(
            builder: (context, value, child) {
              if (value.isLoading == true) {
                return ShimmerWalletTransactionItem();
              } else if (value.sessionHistoryData.isEmpty) {
                return Center(
                  heightFactor: context.deviceHeight * .05,
                  child: const Text('No Therapist Availble!'),
                );
              } else {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: ListView.builder(
                      itemCount: value.sessionHistoryData
                          .length, // Adjust this based on your data
                      itemBuilder: (context, index) {
                        var item = value.sessionHistoryData.reversed.toList();
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutesName.expertScreen, arguments: {
                                'id': item[index].therapistId!.sId
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: primaryColor),
                                  ),
                                  child: item[index].therapistId == null
                                      ? CircleAvatar(
                                          radius: height *
                                              0.026, // Responsive radius
                                          child: const Icon(
                                            size: 22,
                                            Icons.account_circle,
                                            color: Colors.white,
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: height *
                                              0.026, // Responsive radius
                                          backgroundImage: NetworkImage(
                                              item[index]
                                                  .therapistId!
                                                  .profileImg
                                                  .toString()),
                                        ),
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item[index].therapistId == null
                                          ? 'Deleted Therpist'
                                          : item[index]
                                              .therapistId!
                                              .name
                                              .toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.phone,
                                          color: Color(0xff0CD799),
                                          size: 16,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          item[index].createdAt!.time,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item[index].createdAt!.wellDated,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                   item[index].sessionId == null ? '':   "${item[index].sessionId!.timeDuration.toString()} Min",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                       item[index].sessionId == null ? '':  "₹ ${item[index].sessionId!.fees.toString()}",
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            },
          )),
    );
  }
}
