import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overcooked/Utils/utilsFunction.dart';
import 'package:overcooked/newFlow/model/allTherapistModel.dart';
import 'package:overcooked/newFlow/model/singleSessionModel.dart';
import 'package:overcooked/newFlow/model/singleStoryModel.dart';
import 'package:overcooked/newFlow/model/storyModel.dart';
import 'package:overcooked/newFlow/model/therapistByCateModel.dart';
import 'package:overcooked/newFlow/reposetries/homeRepo.dart';
import 'package:overcooked/newFlow/routes/routeName.dart';

import '../model/walletModel.dart';
import '../reposetries/walletRepo.dart';

class HomeViewModel with ChangeNotifier {
  final HomeRepo homeRepo;
  final WalletRepo walletRepo;

  HomeViewModel(this.homeRepo, this.walletRepo);

  List<StoryModel> _storyList = [];
  List<AllTherapistModel> therapistData = [];
  List<AllTherapistModel> filterTherapistData = [];

  SingleStoryModel? singleStoryModel;
  WalletModel? walletModel;
  bool isEmpty = false;

  String? cateId;

  List<StoryModel> get storyList => _storyList;

  bool isLoading = false;
  bool storyLoading = false;

  bool isCate = false;
  bool statusLoading = false;

  setIsEmpty(bool value) {
    isEmpty = value;
    notifyListeners();
  }

  setStatus(bool value) {
    statusLoading = value;
    notifyListeners();
  }

  setLoading(bool value) {
    isLoading = value;
    // notifyListeners();
  }

  setStoryLoading(bool value) {
    storyLoading = value;
    // notifyListeners();
  }

  setCate(bool value) {
    isCate = value;
    notifyListeners();
  }

  setCateId(String value) {
    cateId = value;
    notifyListeners();
  }

   Stream<List<AllTherapistModel>> therapistStream(
    String sortByFees, category, language, sortByRating, experience, token) async* {
    int currentPage = 1;
    bool hasMoreData = true;
    List<AllTherapistModel> therapistList = [];
    Set<String> therapistIds = {};

    try {
      while (hasMoreData) {
        isLoading = true;
        notifyListeners();

        List<AllTherapistModel> fetchedTherapists = await homeRepo.fetchTherapistApi(
          sortByFees,
          category,
          language,
          sortByRating,
          experience,
          token,
          currentPage.toString(),
        );
        fetchedTherapists.removeWhere((therapist) => therapistIds.contains(therapist.sId));

        therapistList.addAll(fetchedTherapists);
        therapistIds.addAll(fetchedTherapists.map((therapist) => therapist.sId.toString()));

        if (fetchedTherapists.isEmpty) {
          hasMoreData = false;
        } else {
          yield therapistList;
          currentPage++;
        }

        isLoading = false;
        notifyListeners();
        await Future.delayed(Duration(seconds: 3));
      }
    } catch (e) {
      print("Error in stream: $e");
    }
  }

  bool isLoadingMore = false;

  Stream<List<AllTherapistModel>> therapistByCateStream(String id) async* {
    try {
      while (true) {
        List<AllTherapistModel> theraPistList =
            await homeRepo.fetchTherapistByCateApi(id);
        yield theraPistList;

        await Future.delayed(Duration(seconds: 3));
      }
    } catch (e) {
      print("Error in stream: $e");
    }
  }

  Stream<List<AllTherapistModel>> therapistByCategoryStream(
      String id, token) async* {
    try {
      while (true) {
        List<AllTherapistModel> theraPistList =
            await homeRepo.fetchTherapistByCategoryApi(id, token);

        yield theraPistList;

        await Future.delayed(Duration(seconds: 3));
        if (theraPistList.isEmpty) {
          setIsEmpty(true);
        } else if (theraPistList.isNotEmpty) {
          setIsEmpty(false);
        }
      }
    } catch (e) {
      print("Error in stream: $e");
    }
  }

  Future<void> fetchTheraPistByIdAPi(String id) async {
    try {
      setLoading(true);
      therapistData = await homeRepo.fetchTherapistByCateApi(id);

      notifyListeners();
      setLoading(false);
      print(_storyList);
    } catch (error) {
      setLoading(false);
      print(error);
    }
  }

  Future<void> bookingStatusApis(
      String token, String status, id, BuildContext context) async {
    try {
      setStatus(true);
      final newData = await homeRepo.bookingStatusApi(token, status, id);
      Future.delayed(Duration(seconds: 4), () {
        setStatus(false);
      });

      print(newData.message);
    } catch (error) {
      setStatus(false);
      print(error);
    }
  }

  Future<void> fetchStoryAPi() async {
    try {
      setStoryLoading(true);
      _storyList = await homeRepo.fetchStory();

      notifyListeners();
      setStoryLoading(false);
      print(_storyList);
    } catch (error) {
      setStoryLoading(false);
      print(error);
    }
  }
  Future<void> fetchFilterTherapistAPi(String token) async {
    try {
      setLoading(true);
      filterTherapistData = await homeRepo.filterTherapistApi(token);

      notifyListeners();
      setLoading(false);
      print(_storyList);
    } catch (error) {
      setLoading(false);
      print(error);
    }
  }

  Future<void> fetchSingleStoryAPi(String Id) async {
    try {
      setLoading(true);

      singleStoryModel = await homeRepo.fetchSingleStory(Id);

      notifyListeners();
      setLoading(false);
      print(singleStoryModel!);
    } catch (error) {
      setLoading(false);
      print(error);
    }
  }

  Future<void> fetchWalletBalanceAPi(String token) async {
    try {
      walletModel = await walletRepo.fetchWalletBalance(token);

      notifyListeners();
    } catch (error) {
      setLoading(false);
      print(error);
    }
  }

  Future<void> sessionCompleteApis(
      String sessionId, bool isHome, BuildContext context) async {
    setStatus(true);
    try {
      final newData = await homeRepo.sessionCompleteApi(sessionId, context);
      if (isHome == false) {
        // Navigator.pushReplacementNamed(context, RoutesName.bottomNavBarView);
      }
      print(newData.message);
      Future.delayed(Duration(seconds: 4), () {
        setStatus(false);
      });
    } catch (error) {
      setStatus(false);
    }
  }


  // ---------------

  
}
