import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/material.dart';

import '../../Utils/utilsFunction.dart';


class ApiService {
  final String baseUrl;
  final BuildContext context;

  ApiService(this.baseUrl, this.context);

  Future<bool> _isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<http.Response> get(String endpoint,
      {Map<String, String>? headers}) async {
    await _checkInternetConnection();
    final response =
        await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
    _checkForError(response);
    return response;
  }

  Future<http.Response> post(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    await _checkInternetConnection();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(body),
    );
    _checkForError(response);
    return response;
  }

  Future<http.Response> put(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    await _checkInternetConnection();
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(body),
    );
    _checkForError(response);
    return response;
  }

  Future<http.Response> patch(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    await _checkInternetConnection();
    final response = await http.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(body),
    );
    _checkForError(response);
    return response;
  }

  Future<http.Response> delete(String endpoint,
      {Map<String, String>? headers}) async {
    await _checkInternetConnection();
    final response =
        await http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);
    _checkForError(response);
    return response;
  }

  // New method for multipart request
  Future<http.StreamedResponse> multipartRequest(
    String endpoint, {
    required Map<String, String> fields,
    required Map<String, String> headers,
    required List<MultipartFile> files,
  }) async {
    await _checkInternetConnection();

    var uri = Uri.parse('$baseUrl$endpoint');
    var request = http.MultipartRequest('POST', uri)
      ..fields.addAll(fields)
      ..headers.addAll(headers);

    for (var file in files) {
      request.files.add(file);
    }

    var streamedResponse = await request.send();
    if (streamedResponse.statusCode < 200 ||
        streamedResponse.statusCode >= 300) {
      final response = await http.Response.fromStream(streamedResponse);
      _checkForError(response);
    }

    return streamedResponse;
  }

  // New method for multipart request
  Future<http.StreamedResponse> multipartPutRequest(
    String endpoint, {
    required Map<String, String> fields,
    required Map<String, String> headers,
    required MultipartFile file,
  }) async {
    await _checkInternetConnection();

    var uri = Uri.parse('$baseUrl$endpoint');
    var request = http.MultipartRequest('PUT', uri)
      ..fields.addAll(fields)
      ..headers.addAll(headers)
      ..files.add(file);

    var streamedResponse = await request.send();
    if (streamedResponse.statusCode < 200 ||
        streamedResponse.statusCode >= 300) {
      final response = await http.Response.fromStream(streamedResponse);
      _checkForError(response);
    }

    return streamedResponse;
  }

  Future<void> _checkInternetConnection() async {
    if (!await _isConnected()) {
      Utils.flushBarErrorMessage(
        message: 'No internet connection',
        context: context,
        icon: Icons.wifi_off,
        color: Colors.white,
        backgroundColor: Colors.red,
      );
      throw Exception('No internet connection');
    }
  }

  void _checkForError(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      Utils.flushBarErrorMessage(
        message: 'Failed to load data: ${response.statusCode} ${response.body}',
        context: context,
        icon: Icons.error,
        color: Colors.white,
        backgroundColor: Colors.red,
      );
      Utils.flushBarErrorMessageBottom(
          message:
              'Failed to load data: ${response.statusCode} ${response.body}',
          context: context);
    }
  }
}
