import 'package:flutter/material.dart';
import 'package:ventout/Utils/slideTransition.dart';
import 'package:ventout/newFlow/addMoneyScreen.dart';
import 'package:ventout/newFlow/bottomNaveBar.dart';
import 'package:ventout/newFlow/expertScreen.dart';
import 'package:ventout/newFlow/filterScreen.dart';
import 'package:ventout/newFlow/login/selectGenderScreen.dart';
import 'package:ventout/newFlow/routes/routeName.dart';
import 'package:ventout/newFlow/storyInfoScreen.dart';
import 'package:ventout/newFlow/successfullScreen.dart';
import 'package:ventout/newFlow/term&conditionScreen.dart';
import 'package:ventout/newFlow/walletScreen.dart';
import 'package:ventout/newFlow/login/login.dart';
import 'package:ventout/newFlow/login/otpscreen.dart';
import 'package:ventout/newFlow/login/registrationScreen.dart';
import 'package:ventout/newFlow/login/dob.dart';

import '../../Utils/help_screen.dart';
import '../privacyPolicyScreen.dart';
import '../sessionHistory.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.expertScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return SlideRoute(
            page: ExpertInfoScreen(
              arguments: arguments,
            ),
            x: 1,
            y: 0);
      case RoutesName.sortFilterScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return SlideRoute(
            page: SortFilterScreen(
              arguments: arguments,
            ),
            x: 1,
            y: 0);
      case RoutesName.StoryScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return SlideRoute(
            page: StoryScreen(
              arguments: arguments,
            ),
            x: 1,
            y: 0);
      case RoutesName.WalletHistoryScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return SlideRoute(
            page: WalletHistoryScreen(
              arguments: arguments,
            ),
            x: 1,
            y: 0);
      case RoutesName.AddMoneyScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return SlideRoute(
            page: AddMoneyScreen(
              arguments: arguments,
            ),
            x: 1,
            y: 0);

      case RoutesName.LoginScreen:
        return SlideRoute(page: const LoginScreen(), x: 1, y: 0);

      case RoutesName.OtpScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return SlideRoute(
            page: OtpScreen(
              arguments: arguments,
            ),
            x: 1,
            y: 0);
      case RoutesName.bottomNavBarView:
        return SlideRoute(page: BottomNavBarView(), x: 1, y: 0);
      case RoutesName.TermAndConditionScreen:
        return SlideRoute(page: const TermAndConditionScreen(), x: 1, y: 0);
      case RoutesName.PrivacyPolicyScreen:
        return SlideRoute(page: const PrivacyPolicyScreen(), x: 1, y: 0);
      case RoutesName.SessionHistoryScreen:
        return SlideRoute(page: SessionHistoryScreen(), x: 1, y: 0);
      case RoutesName.registrationScreen:
        return SlideRoute(page: RegistrationScreen(), x: 1, y: 0);
      case RoutesName.WalletSuccessScreen:
        return SlideRoute(page: const WalletSuccessScreen(), x: 1, y: 0);
      case RoutesName.HelpScreen:
        return SlideRoute(page: const HelpScreen(), x: 1, y: 0);
      case RoutesName.dOBScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return SlideRoute(
            page: DOBScreen(
              arguments: arguments,
            ),
            x: 1,
            y: 0);
      case RoutesName.genderSelectionScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return SlideRoute(
            page: GenderSelectionScreen(
              arguments: arguments,
            ),
            x: 1,
            y: 0);
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('NO route defined'),
            ),
          );
        });
    }
  }
}
