import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ventout/Utils/valueConstants.dart';
import 'package:ventout/newFlow/routes/routeName.dart';
import 'package:ventout/newFlow/services/sharedPrefs.dart';
import 'package:ventout/newFlow/shimmer/singleStoryShimmer.dart';
import 'package:ventout/newFlow/viewModel/homeViewModel.dart';
import 'package:ventout/newFlow/widgets/agentCardWidget.dart';
import 'package:ventout/newFlow/widgets/color.dart';
import 'package:provider/provider.dart';

import 'model/allTherapistModel.dart';
import 'viewModel/utilsClass.dart';

class StoryScreen extends StatefulWidget {
  Map<String, dynamic>? arguments;
  StoryScreen({super.key, this.arguments});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  String? id, cateId;
  Stream<List<AllTherapistModel>>? _theraPistStream;

  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();
  String? token, userId;
  bool? freeStatus;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    id = widget.arguments!['id'];
    cateId = widget.arguments!['cateid'];
    if (kDebugMode) {
      print(id);
    }
    final getHomeData = Provider.of<HomeViewModel>(context, listen: false);
    Future.wait([sharedPreferencesViewModel.getFreeStatus()]).then((value) {
      freeStatus = value[0];
    });
    Future.wait([
      sharedPreferencesViewModel.getSignUpToken(),
      sharedPreferencesViewModel.getToken(),
      sharedPreferencesViewModel.getUserId()
    ]).then((value) {
      token = value[1];
      userId = value[2];
      getHomeData.fetchSingleStoryAPi(id.toString());
      setState(() {
        _theraPistStream = getHomeData.therapistByCateStream(cateId.toString());
      });
      print(value[2]);
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
          backgroundColor: Colors.black,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            backgroundColor: Colors.black,
            title: const Text(
              'Story',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            centerTitle: false,
          ),
          body: Consumer<HomeViewModel>(
            builder: (context, value, child) {
              if (value.isLoading == true) {
                return SingleStoryShimmer();
              } else if (value.singleStoryModel == null) {
                return SingleStoryShimmer();
              } else {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 14, right: 14, top: 5),
                        child: Text(
                          value.singleStoryModel!.title.toString(),
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * .054,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 14, right: 14, top: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                value.singleStoryModel!.image.toString(),
                                width: 170,
                                height: 170,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    value.singleStoryModel!.shortDescription !=
                                            null
                                        ? '"${value.singleStoryModel!.shortDescription}"'
                                        : '',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              .038,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: verticalSpaceSmall),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white.withOpacity(.1)),
                                    child: Text(
                                      value.singleStoryModel!.categoryId![0] ==
                                              null
                                          ? ''
                                          : value.singleStoryModel!
                                              .categoryId![0].categoryName
                                              .toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 14, right: 14, top: 5),
                        child: Text(
                          value.singleStoryModel!.description.toString(),
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * .041,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 26.0),
                      Divider(
                        color: Colors.grey.withOpacity(.4),
                      ),
                      const SizedBox(height: 18.0),
                      StreamBuilder(
                        stream: _theraPistStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          } else if (snapshot.data == null ||
                              snapshot.data!.isEmpty) {
                            return const SizedBox();
                          } else {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.checkmark_seal_fill,
                                        color: greenColor,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Related experts',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .046,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 28,
                                ),
                                ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var item = snapshot.data!.toList();
                                    String capitalizeName(String name) {
                                      return name
                                          .split(' ')
                                          .map((word) =>
                                              word[0].toUpperCase() +
                                              word.substring(1))
                                          .join(' ');
                                    }

                                    String formattedName =
                                        capitalizeName(item[index].name!);
                                    return AgentCardWidget(
                                      normalPrice:
                                          item[index].fees!.toStringAsFixed(0),
                                      rating: item[index].avgRating!.toInt(),
                                      onCallTap: () {
                                        int? balancess =
                                            item[index].discountedFees != null
                                                ? item[index].discountedFees
                                                : item[index].fees!;
                                        if (value.walletModel!.balance! <
                                                balancess! &&
                                            freeStatus == false) {
                                          UtilsClass().showRatingBottomSheet(
                                              context,
                                              item[index].discountedFees != 0
                                                  ? item[index]
                                                      .discountedFees!
                                                      .toInt()
                                                  : item[index].fees!.toInt(),
                                              token.toString(),
                                              '45');
                                        } else if (item[index].isAvailable ==
                                            false) {
                                          UtilsClass().showCustomDialog(
                                              context,
                                              item[index].isFree == true &&
                                                      freeStatus == true
                                                  ? '0'
                                                  : item[index].fees == null
                                                      ? '0'
                                                      : item[index]
                                                                  .discountedFees ==
                                                              0
                                                          ? item[index]
                                                              .fees
                                                              .toString()
                                                          : item[index]
                                                              .discountedFees
                                                              .toString(),
                                              token,
                                              item[index].sId,
                                              item[index].name,
                                              item[index].profileImg,
                                              item[index].name,
                                              item[index].feesPerMinute,
                                              '45',
                                              userId,
                                              item[index].sId,
                                              item[index].name,
                                              true);
                                        } else {
                                          UtilsClass().showDialogWithoutTimer(
                                              context,
                                              item[index].isFree == true &&
                                                      freeStatus == true
                                                  ? '0'
                                                  : item[index].fees == null
                                                      ? '0'
                                                      : item[index]
                                                                  .discountedFees ==
                                                              0
                                                          ? item[index]
                                                              .fees
                                                              .toString()
                                                          : item[index]
                                                              .discountedFees
                                                              .toString(),
                                              token,
                                              item[index].sId,
                                              item[index].name,
                                              item[index].profileImg,
                                              item[index].name,
                                              item[index].feesPerMinute,
                                              '45',
                                              userId,
                                              item[index].sId,
                                              item[index].name,
                                              () {},
                                              true);
                                        }
                                      },
                                      isRisingStar: item[index].risingStar,
                                      isHomeScreen: false,
                                      isAvailble: item[index].isAvailable,
                                      isFree: false,
                                      name: "$formattedName",
                                      // Fixing the language access issue
                                      language: item[index].language!,
                                      price: item[index].fees == null
                                          ? ''
                                          : item[index]
                                              .fees!
                                              .toStringAsFixed(0),
                                      oneMintPrice: item[index]
                                                      .discountedFeesPerMinute !=
                                                  null ||
                                              item[index]
                                                      .discountedFeesPerMinute !=
                                                  0
                                          ? item[index]
                                              .discountedFeesPerMinute!
                                              .toStringAsFixed(0)
                                          : item[index].feesPerMinute != 0
                                              ? item[index]
                                                  .feesPerMinute!
                                                  .toStringAsFixed(0)
                                              : '',
                                      discountPrice:
                                          item[index].discountedFees == null
                                              ? ''
                                              : item[index]
                                                  .discountedFees!
                                                  .toStringAsFixed(0),
                                      theraPistCate:
                                          item[index].psychologistCategory,
                                      theraPistSubCate:
                                          item[index].qualification,
                                      image: item[index].profileImg,
                                      onTap: () {
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      onCardTap: () {
                                        Navigator.pushNamed(
                                            context, RoutesName.expertScreen,
                                            arguments: {
                                              'id': item[index].sId,
                                              "balance":
                                                  value.walletModel!.balance
                                            });
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                );
              }
            },
          )),
    );
  }
}
