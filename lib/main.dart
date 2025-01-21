import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventout/Utils/scrollBehavior.dart';
import 'package:ventout/firebase_options.dart';
import 'package:ventout/newFlow/reposetries/authRepo.dart';
import 'package:ventout/newFlow/reposetries/homeRepo.dart';
import 'package:ventout/newFlow/reposetries/razorPayRepo.dart';
import 'package:ventout/newFlow/reposetries/sessionRepo.dart';
import 'package:ventout/newFlow/reposetries/walletRepo.dart';
import 'package:ventout/newFlow/routes/route.dart';
import 'package:ventout/newFlow/splashScreens/splash_screen1.dart';
import 'package:ventout/newFlow/viewModel/chatViewModel.dart';
import 'package:ventout/newFlow/viewModel/homeViewModel.dart';
import 'package:ventout/newFlow/viewModel/razorPayviewModel.dart';
import 'package:ventout/newFlow/viewModel/sessionViewModel.dart';
import 'package:ventout/newFlow/viewModel/utilViewModel.dart';
import 'package:ventout/newFlow/viewModel/walletViewModel.dart';
import 'package:ventout/pushNotifications.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'newFlow/reposetries/utilsRepo.dart';
import 'newFlow/services/app_url.dart';
import 'newFlow/services/http_service.dart';
import 'newFlow/viewModel/authViewModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'newFlow/viewModel/questionsProvider.dart';

SharedPreferences? preferences;
final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
    ZegoUIKit().initLog().then((value) {
      ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
        [ZegoUIKitSignalingPlugin()],
      );

      runApp(ProviderScope(
          child: GossipMark(
        navigatorKey: navigatorKey,
      )));
    });
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
}

class GossipMark extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const GossipMark({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  @override
  State<GossipMark> createState() => _GossipMarkState();
}

class _GossipMarkState extends State<GossipMark> {
  @override
  Widget build(BuildContext context) {
    final apiService = ApiService(AppUrl.baseUrl, context);
    final authrepo = AuthRepo(apiService);
    final homeRepo = HomeRepo(apiService);
    final utilsRepo = UtilsRepo(apiService);
    final walletRepo = WalletRepo(apiService);
    final sessionRepo = SessionRepo(apiService);
    final razor = RazorPayRepo(apiService);
    // final chatrepo = ChatRepo(apiService);
    return provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider(create: (_) => AuthViewModel(authrepo)),
        provider.ChangeNotifierProvider(
            create: (_) => HomeViewModel(homeRepo, walletRepo)),
        provider.ChangeNotifierProvider(
            create: (_) => UtilsViewModel(utilsRepo)),
        provider.ChangeNotifierProvider(
            create: (_) => WalletViewModel(walletRepo)),
        provider.ChangeNotifierProvider(
            create: (_) => SessionViewModel(sessionRepo)),
        provider.ChangeNotifierProvider(create: (_) => ChatViewModel(homeRepo)),
        provider.ChangeNotifierProvider(
            create: (_) => RazorPayViewzModel(razor)),
        provider.ChangeNotifierProvider(create: (_) => QuestionProvider()),
      ],
      child: GetMaterialApp(
        navigatorKey: widget.navigatorKey,
        title: 'VentOut.',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          brightness: Brightness.dark,
        ),
        home: const SplashScreen10(),
        onGenerateRoute: Routes.generateRoute,
        scrollBehavior: MyBehavior(),
      ),
    );
  }
}
