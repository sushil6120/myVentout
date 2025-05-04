import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overcooked/newFlow/model/allTherapistModel.dart';
import 'package:overcooked/newFlow/model/resultModel.dart';
import 'package:overcooked/newFlow/model/singleStoryModel.dart';
import 'package:overcooked/newFlow/model/storyModel.dart';
import 'package:overcooked/newFlow/model/userProfileModel.dart';
import 'package:overcooked/newFlow/reposetries/homeRepo.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';

import '../model/walletModel.dart';
import '../reposetries/walletRepo.dart';

class HomeViewModel with ChangeNotifier {
  final HomeRepo homeRepo;
  final WalletRepo walletRepo;

  HomeViewModel(this.homeRepo, this.walletRepo);

  List<StoryModel> _storyList = [];
  List<AllTherapistModel> therapistData = [];
  List<AllTherapistModel> filterTherapistData = [];
  List<Data> userResultData = [];

  SingleStoryModel? singleStoryModel;
  UserProfileModel? userProfileModel;
  WalletModel? walletModel;

  bool isFirstLoad = true;
  bool isLoading = false;
  List<AllTherapistModel> cachedTherapists = [];

  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();
  bool isFirstFilterLoad = true;
  bool isEmpty = false;
  String? cateId;
  List<StoryModel> get storyList => _storyList;
  bool storyLoading = false;
  bool isCate = false;
  bool statusLoading = false;

  List<AllTherapistModel> cachedFilterData = []; // Cache for filter data


  void setFirstLoadComplete() {
    isFirstLoad = false;
    notifyListeners();
  }

  void setFirstFilterLoadComplete() {
    isFirstFilterLoad = false;
    notifyListeners();
  }

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
    notifyListeners();
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
      String sortByFees, category, language, sortByRating, experience, token,
      {bool? isrefresh}) async* {
    int currentPage = 1;
    bool hasMoreData = true;
    List<AllTherapistModel> therapistList = [];
    Set<String> therapistIds = {};

    if (isrefresh == true) {
      isFirstLoad == true;
      // cachedTherapists.clear();
      notifyListeners();
    } else if (!isFirstLoad && cachedTherapists.isNotEmpty) {
      yield cachedTherapists;
    }

    try {
      while (hasMoreData) {
        isLoading = true;
        notifyListeners();

        List<AllTherapistModel> fetchedTherapists =
            await homeRepo.fetchTherapistApi(
          sortByFees,
          category,
          language,
          sortByRating,
          experience,
          token,
          currentPage.toString(),
        );
        fetchedTherapists
            .removeWhere((therapist) => therapistIds.contains(therapist.sId));

        therapistList.addAll(fetchedTherapists);
        therapistIds.addAll(
            fetchedTherapists.map((therapist) => therapist.sId.toString()));

        if (fetchedTherapists.isEmpty) {
          hasMoreData = false;
        } else {
          cachedTherapists = List.from(therapistList);

          yield therapistList;
          currentPage++;
        }
        isLoading = false;
        notifyListeners();
        await Future.delayed(Duration(seconds: 3));
      }
    } catch (e) {
      print("Error in stream: $e");

      if (cachedTherapists.isNotEmpty) {
        yield cachedTherapists;
      }
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

  Future<void> fetchFilterTherapistAPi(String token, {bool? isRefresh}) async {
    if (isRefresh == true) {
      isFirstFilterLoad == true;
      setLoading(true);
      filterTherapistData.clear();
      cachedFilterData.clear();
      notifyListeners();
    } else if (!isFirstFilterLoad &&
        cachedFilterData.isNotEmpty &&
        isRefresh != true) {
      filterTherapistData = List.from(cachedFilterData);
      notifyListeners();
      return;
    } else {
      setLoading(true);
      notifyListeners();
    }
    try {
      var filterTherapistDatas = await homeRepo.filterTherapistApi(token);
      filterTherapistData = filterTherapistDatas;
          
      cachedFilterData = List.from(filterTherapistData);
      if (isFirstFilterLoad) {
        setFirstFilterLoadComplete();
      }
      setLoading(false);
      notifyListeners();
    } catch (error) {
      setLoading(false);
      notifyListeners();
      print("Error in fetchFilterTherapistAPi: $error");
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

  Future<void> userProfileApis({
    required String userId,
    required String token,
  }) async {
    SharedPreferencesViewModel sharedPreferencesViewModel =
        SharedPreferencesViewModel();
    setStatus(true);
    try {
      final newData =
          await homeRepo.userProfilApi(userId: userId, token: token);
      userProfileModel = newData;
      if (userProfileModel != null) {
        sharedPreferencesViewModel.saveUserNumber(newData.phone);
        sharedPreferencesViewModel.saveUserName(newData.name.capitalizeFirst);
      }
      notifyListeners();
    } catch (error) {
      setStatus(false);
    }
  }

  Future<void> userResultApis({
    required String totalScore,
    required String token,
  }) async {
    userResultData.clear();
    setStatus(true);
    try {
      final newData = await homeRepo.userResultApi(token: token);

      final int score = int.tryParse(totalScore) ?? 0;

      final filteredData = newData.data!.where((element) {
        final rangeParts = element.score?.split('-');
        if (rangeParts != null && rangeParts.length == 2) {
          final int min = int.tryParse(rangeParts[0].trim()) ?? 0;
          final int max = int.tryParse(rangeParts[1].trim()) ?? 0;
          return score >= min && score <= max;
        }
        return false;
      }).toList();

      userResultData.addAll(filteredData);
      setStatus(false);
      notifyListeners();
    } catch (error) {
      setStatus(false);
    }
  }

  // ---------------
}
