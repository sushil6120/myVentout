import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventout/Utils/colors.dart';
import 'package:ventout/Utils/responsive.dart';
import 'package:ventout/Utils/utilsFunction.dart';
import 'package:ventout/Utils/valueConstants.dart';
import 'package:ventout/newFlow/services/sharedPrefs.dart';
import 'package:ventout/newFlow/shimmer/shimmerEffectExpertSCreen.dart';
import 'package:ventout/newFlow/viewModel/authViewModel.dart';
import 'package:ventout/newFlow/viewModel/homeViewModel.dart';
import 'package:ventout/newFlow/viewModel/utilViewModel.dart';
import 'package:ventout/newFlow/viewModel/utilsClass.dart';
import 'package:ventout/newFlow/viewModel/walletViewModel.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';

class ExpertInfoScreen extends StatefulWidget {
  Map<String, dynamic>? arguments;
  ExpertInfoScreen({super.key, this.arguments});
  @override
  State<ExpertInfoScreen> createState() => _ExpertInfoScreenState();
}

class _ExpertInfoScreenState extends State<ExpertInfoScreen> {
  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();

  String? id, userId, token;
  double? balance;
  bool? freeStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = widget.arguments!['id'];
    balance = widget.arguments!['balance'];
    if (kDebugMode) {
      print("Balance:" + balance.toString());
    }

    final getAuthData = Provider.of<AuthViewModel>(context, listen: false);
    final getHomeData = Provider.of<HomeViewModel>(context, listen: false);
    final getReviewData = Provider.of<UtilsViewModel>(context, listen: false);

    Future.wait([sharedPreferencesViewModel.getFreeStatus()]).then((value) {
      freeStatus = value[0];
    });
    Future.wait([
      sharedPreferencesViewModel.getToken(),
      sharedPreferencesViewModel.getUserId(),
      sharedPreferencesViewModel.getSignUpToken()
    ]).then((value) {
      userId = value[1];
      token = value[0];
      getAuthData.fetchTherapistProfileAPi(id.toString());
      getHomeData.fetchWalletBalanceAPi(
          token == null ? value[2].toString() : token.toString());
      getReviewData.fetchReViewAPi(id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/back-designs.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Consumer<AuthViewModel>(
          builder: (context, value, child) {
            if (value.profileLoading == true) {
              return ShimmerExpertInfoScreen();
            } else if (value.therapistProfileModel == null) {
              return const SizedBox();
            } else {
              String capitalizeName(String name) {
                return name
                    .split(' ')
                    .map((word) => word[0].toUpperCase() + word.substring(1))
                    .join(' ');
              }

              String formattedName =
                  capitalizeName(value.therapistProfileModel!.name!);
              return Scaffold(
                  backgroundColor: Colors.transparent,
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                    backgroundColor: Colors.transparent,
                    centerTitle: false,
                    title: Text(
                      'Know your Expert',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * .048,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onLongPress: () {
                                    _showImageViewer(
                                        context,
                                        value.therapistProfileModel!.profileImg
                                            .toString());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                            Border.all(color: primaryColor)),
                                    child: CircleAvatar(
                                        backgroundColor: colorLightWhite,
                                        radius: 50,
                                        backgroundImage: NetworkImage(value
                                            .therapistProfileModel!.profileImg
                                            .toString())),
                                  ),
                                ),
                                const SizedBox(width: 25),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$formattedName",
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                .044,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      value.therapistProfileModel!.qualification
                                          .toString(),
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                .034,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    RatingBar.builder(
                                      initialRating: value
                                          .therapistProfileModel!.avgRating!
                                          .toDouble(),
                                      ignoreGestures: true,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize:
                                          MediaQuery.of(context).size.width *
                                              .062,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: primaryColor,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '${value.therapistProfileModel!.experience} years experience',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                .035,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            color: colorDark2,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.transparent,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Mini Session',
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .020,
                                              fontWeight: FontWeight.w700,
                                            )),
                                        Text(
                                            '(Mini session’s\nduration is 10 minutes)',
                                            style: GoogleFonts.inter(
                                              color: Color(0xff049569),
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .016,
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ],
                                    ),
                                    Text(
                                        "Rs. ${value.therapistProfileModel!.discountedFeesForTenMinute != null ? value.therapistProfileModel!.discountedFeesForTenMinute.toString() : value.therapistProfileModel!.feesForTenMinute.toString()}",
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .020,
                                          fontWeight: FontWeight.w700,
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: verticalSpaceSmall2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Session',
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .020,
                                              fontWeight: FontWeight.w700,
                                            )),
                                        Text(
                                            '(Full session’s\nduration is 45 minutes)',
                                            style: GoogleFonts.inter(
                                              color: Color(0xff049569),
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .016,
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ],
                                    ),
                                    Text(
                                        "Rs. ${value.therapistProfileModel!.discountedFees != null ? value.therapistProfileModel!.discountedFees.toString() : value.therapistProfileModel!.fees.toString()}",
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .020,
                                          fontWeight: FontWeight.w700,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          value.therapistProfileModel!.question1!.isEmpty ||
                                  value.therapistProfileModel!.question1 == null
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 0),
                                  child: Text(
                                    'What can you ask me?',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: context.deviceWidth * .044,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 6),
                          value.therapistProfileModel!.question1!.isEmpty ||
                                  value.therapistProfileModel!.question1 == null
                              ? const SizedBox()
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 0),
                                  shrinkWrap: true,
                                  itemCount: value
                                      .therapistProfileModel!.question1!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                              'assets/img/column.svg'),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${value.therapistProfileModel!.question1![index].toString()}',
                                              style: TextStyle(
                                                color: const Color(0xff676767),
                                                fontSize:
                                                    context.deviceWidth * .036,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                          value.therapistProfileModel!.question2!.isEmpty ||
                                  value.therapistProfileModel!.question2 == null
                              ? const SizedBox()
                              : const SizedBox(height: 20),
                          value.therapistProfileModel!.question2!.isEmpty ||
                                  value.therapistProfileModel!.question2 == null
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 0),
                                  child: Text('Who can reach me out',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                .042,
                                        fontWeight: FontWeight.w700,
                                      )),
                                ),
                          const SizedBox(height: 10),
                          value.therapistProfileModel!.question1!.isEmpty ||
                                  value.therapistProfileModel!.question1 == null
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 0),
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      ...List.generate(
                                        value.therapistProfileModel!.question2!
                                            .length,
                                        (index) => _buildChip(
                                            value.therapistProfileModel!
                                                .question2![index],
                                            context),
                                      )
                                    ],
                                  ),
                                ),
                          const SizedBox(height: 28),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Text('My Expertise',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * .042,
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                          const SizedBox(height: 18),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              double itemWidth =
                                  (constraints.maxWidth - (2 * 10.0)) / 3;
                              double itemHeight = 120;

                              return GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: itemWidth / itemHeight,
                                ),
                                itemCount: value
                                    .therapistProfileModel!.category!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildIconWithLabel(
                                          value.therapistProfileModel!
                                              .category![index].categoryName
                                              .toString(),
                                          value.therapistProfileModel!
                                              .category![index].emoji
                                              .toString(),
                                          Colors.red,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Text('About',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * .042,
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Text(
                              value.therapistProfileModel!.about.toString(),
                              style: GoogleFonts.inter(
                                color: const Color(0xff676767),
                                fontSize:
                                    MediaQuery.of(context).size.width * .042,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 28,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/img/world.svg',
                                  height: 28,
                                  color: primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Wrap(
                                    children: List.generate(
                                      value.therapistProfileModel!.language!
                                          .length,
                                      (index) {
                                        var language = value
                                            .therapistProfileModel!
                                            .language![index];
                                        return Text(
                                          "$language${index != value.therapistProfileModel!.language!.length - 1 ? ', ' : ''}", // Conditionally add comma
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: height * 0.02,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Reviews',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            .042,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Consumer<UtilsViewModel>(
                                  builder: (context, value, child) {
                                    if (value.reviewList.isEmpty) {
                                      return const SizedBox();
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 2, top: 0),
                                        child: Text(
                                          "(${value.reviewList.length.toString()})",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Consumer<UtilsViewModel>(
                            builder: (context, value, child) {
                              if (value.reviewList == null ||
                                  value.reviewList.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 0),
                                  child: const Text('None'),
                                );
                              } else {
                                return ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 0),
                                  physics: ScrollPhysics(),
                                  itemCount: value.reviewList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var item =
                                        value.reviewList.reversed.toList();
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Text(item[index].userId == null
                                              ? "Deleted User"
                                              : item[index]
                                                  .userId!
                                                  .name
                                                  .toString()),
                                          subtitle: Text(
                                            item[index].review.toString(),
                                            style: const TextStyle(
                                                color: colorDark3),
                                          ),
                                          trailing: Text(
                                              item[index].createdAt!.wellDated,
                                              style: const TextStyle(
                                                  color: colorDark3)),
                                        ),
                                        const Divider(
                                          color: colorDark2,
                                        )
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar: Consumer<WalletViewModel>(
                    builder: (context, walletdate, child) {
                      if (balance == null) {
                        return const SizedBox();
                      } else {
                        return Container(
                          height: height * .11,
                          width: width,
                          padding: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          decoration:
                              const BoxDecoration(color: Colors.transparent),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // _buildContactButton(CupertinoIcons.chat_bubble_fill, 'Chat', () {
                              //   Navigator.pushNamed(context, RoutesName.ChatPage);
                              // }, context),
                              _buildContactButton(
                                  SvgPicture.asset('assets/img/miniLogo.svg',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .028),
                                  'Mini session', () {
                                if (balance! <
                                        value.therapistProfileModel!
                                            .feesForTenMinute! &&
                                    freeStatus == false) {
                                  UtilsClass().showRatingBottomSheet(
                                      context,
                                      value.therapistProfileModel!
                                                  .discountedFeesForTenMinute !=
                                              0
                                          ? value.therapistProfileModel!
                                              .discountedFeesForTenMinute!
                                          : value.therapistProfileModel!
                                              .feesForTenMinute!
                                              .toInt(),
                                      token.toString(),
                                      '10');
                                } else if (value
                                        .therapistProfileModel!.isAvailable ==
                                    false) {
                                  UtilsClass().showCustomDialog(
                                      context,
                                      value.therapistProfileModel!
                                                      .isFree ==
                                                  true &&
                                              freeStatus == true
                                          ? '0'
                                          : value.therapistProfileModel!
                                                      .discountedFees ==
                                                  null
                                              ? value.therapistProfileModel!
                                                  .feesForTenMinute
                                                  .toString()
                                              : value
                                                  .therapistProfileModel!.discountedFees
                                                  .toString(),
                                      token,
                                      value.therapistProfileModel!.sId,
                                      value.therapistProfileModel!.name,
                                      value.therapistProfileModel!.profileImg,
                                      value.therapistProfileModel!.name,
                                      value.therapistProfileModel!
                                                  .discountedFeesPerMinuteOfTenMinute !=
                                              0
                                          ? value.therapistProfileModel!
                                              .discountedFeesPerMinuteOfTenMinute
                                          : value.therapistProfileModel!
                                              .feesPerMinuteOfTenMinute,
                                      '10',
                                      userId,
                                      value.therapistProfileModel!.sId,
                                      value.therapistProfileModel!.name,
                                      false);
                                } else {
                                  UtilsClass().showDialogWithoutTimer(
                                    context,
                                    value.therapistProfileModel!.isFree ==
                                                true &&
                                            freeStatus == true
                                        ? '0'
                                        : value.therapistProfileModel!
                                                    .feesForTenMinute ==
                                                null
                                            ? '0'
                                            : value.therapistProfileModel!
                                                        .discountedFeesForTenMinute ==
                                                    0
                                                ? value.therapistProfileModel!
                                                    .feesForTenMinute
                                                    .toString()
                                                : value.therapistProfileModel!
                                                    .discountedFeesForTenMinute
                                                    .toString(),
                                    token,
                                    value.therapistProfileModel!.sId,
                                    value.therapistProfileModel!.name,
                                    value.therapistProfileModel!.profileImg,
                                    value.therapistProfileModel!.name,
                                    value.therapistProfileModel!
                                                .discountedFeesPerMinuteOfTenMinute !=
                                            0
                                        ? value.therapistProfileModel!
                                            .discountedFeesPerMinuteOfTenMinute
                                        : value.therapistProfileModel!
                                            .feesPerMinuteOfTenMinute,
                                    '10',
                                    userId,
                                    value.therapistProfileModel!.sId,
                                    value.therapistProfileModel!.name,
                                    () {},
                                    false,
                                  );
                                }
                              }, context),
                              _buildContactButton(
                                  SvgPicture.asset(
                                    'assets/img/session.svg',
                                    color: const Color(0xff0E0E0E),
                                    height: MediaQuery.of(context).size.height *
                                        .028,
                                  ),
                                  'Session', () {
                                int? balancess = value.therapistProfileModel!
                                            .discountedFees !=
                                        null
                                    ? value
                                        .therapistProfileModel!.discountedFees
                                    : value.therapistProfileModel!.fees!;
                                if (balance! < balancess! &&
                                    freeStatus == false) {
                                  UtilsClass().showRatingBottomSheet(
                                      context,
                                      value.therapistProfileModel!.fees!
                                          .toInt(),
                                      token.toString(),
                                      '45');
                                } else if (value
                                        .therapistProfileModel!.isAvailable ==
                                    false) {
                                  UtilsClass().showCustomDialog(
                                      context,
                                      value.therapistProfileModel!.isFree ==
                                                  true &&
                                              freeStatus == true
                                          ? '0'
                                          : value.therapistProfileModel!.fees ==
                                                  null
                                              ? '0'
                                              : value
                                                          .therapistProfileModel!
                                                          .discountedFees ==
                                                      0
                                                  ? value.therapistProfileModel!
                                                      .fees
                                                      .toString()
                                                  : value.therapistProfileModel!
                                                      .discountedFees
                                                      .toString(),
                                      token,
                                      value.therapistProfileModel!.sId,
                                      value.therapistProfileModel!.name,
                                      value.therapistProfileModel!.profileImg,
                                      value.therapistProfileModel!.name,
                                      value.therapistProfileModel!
                                                  .discountedFeesPerMinuteOfTenMinute !=
                                              0
                                          ? value.therapistProfileModel!
                                              .discountedFeesPerMinuteOfTenMinute
                                          : value.therapistProfileModel!
                                              .feesPerMinuteOfTenMinute,
                                      '10',
                                      userId,
                                      value.therapistProfileModel!.sId,
                                      value.therapistProfileModel!.name,
                                      true);
                                } else {
                                  UtilsClass().showDialogWithoutTimer(
                                    context,
                                    value.therapistProfileModel!
                                                .discountedFees ==
                                            null
                                        ? value.therapistProfileModel!.fees
                                            .toString()
                                        : value.therapistProfileModel!
                                            .discountedFees
                                            .toString(),
                                    token,
                                    value.therapistProfileModel!.sId,
                                    value.therapistProfileModel!.name,
                                    value.therapistProfileModel!.profileImg,
                                    value.therapistProfileModel!.name,
                                    value.therapistProfileModel!
                                                .discountedFeesPerMinute !=
                                            0
                                        ? value.therapistProfileModel!
                                            .discountedFeesPerMinute
                                        : value.therapistProfileModel!
                                            .feesPerMinute,
                                    '45',
                                    userId,
                                    value.therapistProfileModel!.sId,
                                    value.therapistProfileModel!.name,
                                    () {},
                                    true,
                                  );
                                }
                              }, context),
                            ],
                          ),
                        );
                      }
                    },
                  ));
            }
          },
        ));
  }

  void _showImageViewer(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: colorLightWhite,
          appBar: AppBar(),
          body: Center(
            child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, BuildContext context) {
    return Chip(
      elevation: 0,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      label: Text(label),
      backgroundColor: const Color(0xff003D2A),
      labelStyle: TextStyle(
          color: primaryColor,
          fontSize: MediaQuery.of(context).size.width * .034),
    );
  }

  Widget _buildIconWithLabel(String label, icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
                color: Colors.white,
                fontSize: context.deviceWidth * .034,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(
      Widget icon, String label, VoidCallback oonTap, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: ElevatedButton.icon(
          onPressed: oonTap,
          icon: icon,
          label: Text(label,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * .036)),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: buttonColor,
            side: BorderSide(color: primaryColor),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ),
    );
  }
}
