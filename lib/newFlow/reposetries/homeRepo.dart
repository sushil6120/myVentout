import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ventout/newFlow/model/reaminTimeModel.dart';
import 'package:ventout/newFlow/routes/routeName.dart';
import 'package:ventout/newFlow/services/sharedPrefs.dart';

import '../model/allTherapistModel.dart';
import '../model/availbiltyModel.dart';
import '../model/singleStoryModel.dart';
import '../model/storyModel.dart';
import '../services/app_url.dart';
import '../services/http_service.dart';

class HomeRepo {
  final ApiService apiService;
  HomeRepo(this.apiService);

  Future<List<AllTherapistModel>> fetchTherapistApi(String sortByFees, category,
      language, sortByRating, experience, token, page) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${AppUrl.baseUrl}${AppUrl.allTherapistUrl}?sortByFees=$sortByFees&sortByRating=$sortByRating&experience=$experience&language=$language&category=$category&gender=&page=$page&limit=5'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Response body: ${response.body}'); // Debug line
        var data = jsonDecode(response.body);
        if (data is List) {
          List<AllTherapistModel> therapist = data.map((item) {
            return AllTherapistModel.fromJson(item);
          }).toList();
          return therapist;
        } else {
          throw Exception('Unexpected response format: ${data.runtimeType}');
        }
      } else {
        print(response.body);
        throw Exception(
            'Failed to load categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load categories. Error: $e');
    }
  }

  Future<List<AllTherapistModel>> filterTherapistApi(
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.filterTherapistApi}?sortByFees=&sortByRating=&experience=&language=&category=&gender=&page=1&limit=3'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Filter Response body: ${response.body}');
        var data = jsonDecode(response.body);
        if (data is List) {
          List<AllTherapistModel> therapist = data.map((item) {
            return AllTherapistModel.fromJson(item);
          }).toList();
          
          return therapist;
        } else {
          throw Exception('Unexpected response format: ${data.runtimeType}');
        }
      } else {
        print(response.body);
        throw Exception(
            'Failed to load categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load categories. Error: $e');
    }
  }

  Future<List<AllTherapistModel>> fetchTherapistByCateApi(String id) async {
    try {
      final response = await http.get(
        Uri.parse(AppUrl.baseUrl + AppUrl.therapistByCateUrl + id),
        headers: {
          "Content-type": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        print('Response Body: $data');

        if (data is Map<String, dynamic>) {
          var therapistList = data['therapists'];

          if (therapistList != null && therapistList is List<dynamic>) {
            List<AllTherapistModel> therapist =
                therapistList.map((categoryData) {
              return AllTherapistModel.fromJson(categoryData);
            }).toList();
            return therapist;
          } else {
            throw Exception('No therapists found or invalid data format');
          }
        } else if (data is List<dynamic>) {
          // If the response is directly a list
          List<AllTherapistModel> therapist = data.map((categoryData) {
            return AllTherapistModel.fromJson(categoryData);
          }).toList();

          return therapist;
        } else {
          throw Exception('Unexpected JSON format');
        }
      } else {
        print('Response Body: ${response.body}');
        throw Exception(
            'Failed to load categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load categories. Error: $e');
    }
  }

  Future<List<AllTherapistModel>> fetchTherapistByCategoryApi(
      String id, String token) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${AppUrl.baseUrl}${AppUrl.allTherapistUrl}?sortByFees=&sortByRating=&experience=&language=&category=$id&gender='),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        print('Res Body: $data');

        if (data is Map<String, dynamic>) {
          var therapistList = data['therapists'];

          if (therapistList != null && therapistList is List<dynamic>) {
            List<AllTherapistModel> therapist =
                therapistList.map((categoryData) {
              return AllTherapistModel.fromJson(categoryData);
            }).toList();
            return therapist;
          } else {
            print('No therapists found or invalid data format');
            return [];
          }
        } else if (data is List<dynamic>) {
          List<AllTherapistModel> therapist = data.map((categoryData) {
            return AllTherapistModel.fromJson(categoryData);
          }).toList();

          return therapist;
        } else {
          print('Unexpected JSON format');
          return [];
        }
      } else {
        print('Response Body: ${response.body}');
        throw Exception(
            'Failed to load categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load categories. Error: $e');
    }
  }

  Future<List<StoryModel>> fetchStory() async {
    final response = await apiService
        .get(AppUrl.storyUrl, headers: {"Content-type": "application/json"});
    final List<dynamic> dataJson = json.decode(response.body);
    return dataJson.map((json) => StoryModel.fromJson(json)).toList();
  }

  Future<SingleStoryModel> fetchSingleStory(String Id) async {
    final response = await apiService.get(AppUrl.singleStoryUrl + Id,
        headers: {"Content-type": "application/json"});
    final Map<String, dynamic> dataJson = json.decode(response.body);
    return SingleStoryModel.fromJson(dataJson);
  }

  Future<AvailbiltiModel> bookingStatusApi(String token, status, id) async {
    final response = await apiService.patch(
      AppUrl.cancelSessionUrl + id,
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: {'bookingStatus': status, "cancelledBy": "User"},
    );
    return AvailbiltiModel.fromJson(json.decode(response.body));
  }

  Future<AvailbiltiModel> sessionCompleteApi(
      String sessionId, BuildContext context) async {
    SharedPreferencesViewModel sharedPreferencesViewModel =
        SharedPreferencesViewModel();
    final response = await apiService.patch(
      AppUrl.completeStatusUrl + sessionId,
      headers: {
        "Content-type": "application/json",
      },
      body: {
        'isCompleted': true,
      },
    );
    if (response.statusCode != 200) {
      sharedPreferencesViewModel.logout().then((value) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.LoginScreen,
          (route) => false,
        );
      });
    }
    print(response.body);
    return AvailbiltiModel.fromJson(json.decode(response.body));
  }

  Future<remainTimeModel> remainingTimeApi(
    double minut,
    String bookingId,
  ) async {
    final response = await apiService.post(
      AppUrl.remaingTimeUrl,
      headers: {
        "Content-type": "application/json",
      },
      body: {
        'minutes': minut,
        'bookingId': bookingId,
      },
    );

    print("Sushsil" + response.body);
    return remainTimeModel.fromJson(json.decode(response.body));
  }
}
