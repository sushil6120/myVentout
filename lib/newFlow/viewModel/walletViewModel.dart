import 'package:flutter/cupertino.dart';
import 'package:overcooked/newFlow/model/paymentLogModel.dart';
import '../../Utils/utilsFunction.dart';
import '../model/walletHistoryModel.dart';
import '../model/walletModel.dart';
import '../reposetries/walletRepo.dart';
import '../routes/routeName.dart';

class WalletViewModel with ChangeNotifier {
  final WalletRepo walletRepo;

  WalletViewModel(this.walletRepo);

  WalletModel? walletModel;
  List<WalletHistoryModel> _walletHistoryData = [];
  List<PaymentLogModel> paymentLogData = [];

  List<WalletHistoryModel> get walletHistoryData => _walletHistoryData;

  bool isLoading = false;
  bool isHistoryLoading = false;

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  setHistoryLoading(bool value) {
    isHistoryLoading = value;
    notifyListeners();
  }

  Future<void> fetchWalletBalanceAPi(String token) async {
    try {
      setLoading(true);

      walletModel = await walletRepo.fetchWalletBalance(token);

      notifyListeners();
      setLoading(false);
      print(walletModel);
    } catch (error) {
      setLoading(false);
      print(error);
    }
  }

  Future<void> fetchWalletHistoryAPi(String token) async {
    try {
      setHistoryLoading(true);
      _walletHistoryData = await walletRepo.fetchWalletHistory(token);

      notifyListeners();
      setHistoryLoading(false);
      print(_walletHistoryData);
    } catch (error) {
      setHistoryLoading(false);
      print(error);
    }
  }

  Future<void> fetchPaymentLogAPi(String token) async {
    try {
      setHistoryLoading(true);
      paymentLogData = await walletRepo.fetchPaymentLogApi(token);

      notifyListeners();
      setHistoryLoading(false);
      print(_walletHistoryData);
    } catch (error) {
      setHistoryLoading(false);
      print(error);
    }
  }

  Future<void> addMoneyApis(
      int amount, String token, bool isSuccess, BuildContext context) async {
    if (amount <= 0 || amount.isNaN || amount.isInfinite) {
      Utils.toastMessage('Invalid amount');
      return;
    }

    try {
      setLoading(true);
      final newData =
          await walletRepo.addMoneyApi(amount, token, isSuccess, context);

      setLoading(false);

      if (newData != null && newData.message != null) {
        Utils.toastMessage(newData.message.toString());
        print(newData.message);
      } else {
        Utils.toastMessage('Unexpected API response');
        print('Unexpected API response');
      }
    } catch (error) {
      setLoading(false);
      Utils.toastMessage('Error: $error');
      print('Error: $error');
    }
  }

  Future<void> deductMoneyApis(
      String amount, userId, token, sessionid, BuildContext context) async {
    try {
      final newData =
          await walletRepo.moneyDeductApi(amount, userId, token, sessionid);

      print(newData.message);
    } catch (error) {
      setLoading(false);
      print(error);
    }
  }

  Future<void> sessionCompleteApis(
      String sessionId, bool isHome, BuildContext context) async {
    try {
      final newData = await walletRepo.sessionCompleteApi(sessionId);

      print(newData.message);
    } catch (error) {
      setLoading(false);
      print(error);
    }
  }

  // =======
}
