import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overcooked/firebase_options.dart';
import 'package:overcooked/newFlow/reposetries/authRepo.dart';
import 'package:overcooked/newFlow/reposetries/homeRepo.dart';
import 'package:overcooked/newFlow/reposetries/slotsRepo.dart';
import 'package:overcooked/newFlow/therapistChatscreens/viewmodels/chatProvider.dart';
import 'package:overcooked/newFlow/viewModel/slotsViewModel.dart';
import 'package:overcooked/pushNotifications.dart';
import 'package:provider/provider.dart' as provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:overcooked/Utils/scrollBehavior.dart';
import 'package:overcooked/newFlow/reposetries/razorPayRepo.dart';
import 'package:overcooked/newFlow/reposetries/sessionRepo.dart';
import 'package:overcooked/newFlow/reposetries/walletRepo.dart';
import 'package:overcooked/newFlow/routes/route.dart';
import 'package:overcooked/newFlow/splashScreens/splash_screen1.dart';
import 'package:overcooked/newFlow/viewModel/chatViewModel.dart';
import 'package:overcooked/newFlow/viewModel/homeViewModel.dart'; 
import 'package:overcooked/newFlow/viewModel/razorPayviewModel.dart';
import 'package:overcooked/newFlow/viewModel/sessionViewModel.dart';
import 'package:overcooked/newFlow/viewModel/utilViewModel.dart';
import 'package:overcooked/newFlow/viewModel/walletViewModel.dart';
import 'newFlow/reposetries/utilsRepo.dart';
import 'newFlow/services/app_url.dart';
import 'newFlow/services/http_service.dart';
import 'newFlow/viewModel/authViewModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'newFlow/viewModel/questionsProvider.dart';

SharedPreferences? preferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    runApp(ProviderScope(child: OverCooked()));
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
}

class OverCooked extends StatefulWidget {
  const OverCooked({
    Key? key,
  }) : super(key: key);

  @override
  State<OverCooked> createState() => _OverCookedState();
}

class _OverCookedState extends State<OverCooked> {
  @override
  Widget build(BuildContext context) {
    final apiService = ApiService(AppUrl.baseUrl, context);
    final authrepo = AuthRepo(apiService);
    final slotsRepo = SlotsRepo(apiService);
    final homeRepo = HomeRepo(apiService);
    final utilsRepo = UtilsRepo(apiService);
    final walletRepo = WalletRepo(apiService);
    final sessionRepo = SessionRepo(apiService);
    final razor = RazorPayRepo(apiService);
    return provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider(create: (_) => AuthViewModel(authrepo)),
        provider.ChangeNotifierProvider(
            create: (_) => SlotsViewModel(slotsRepo)),
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
        provider.ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: GetMaterialApp(
        title: 'OverCooked.',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
          brightness: Brightness.dark,
        ),
        home: SplashScreen10(),
        onGenerateRoute: Routes.generateRoute,
        scrollBehavior: MyBehavior(),
      ),
    );
  }
}
