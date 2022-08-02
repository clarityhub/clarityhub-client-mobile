import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:clarityhub/domains/auth/redux/actions/actions.dart';
import 'package:clarityhub/exceptions.dart';
import 'package:clarityhub/preferences.dart';
import 'package:clarityhub/store.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart';

class NetworkHelper {
  static Future<Map<String, String>> createAuth0Headers() async {
    String accessToken = await Preferences.getAuth0Token();

    return HashMap.from({
      "Accept": "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      // 'x-api-key': FlutterConfig.get('X_API_KEY'),
      HttpHeaders.contentTypeHeader: "application/json"
    });
  }

  static Future<Map<String, String>> createHeaders() async {
    String accessToken = await Preferences.getAccessToken();

    return HashMap.from({
      "Accept": "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      // 'x-api-key': FlutterConfig.get('X_API_KEY'),
      HttpHeaders.contentTypeHeader: "application/json"
    });
  }

  static Future<Map<String, String>> createRefreshHeaders() async {
    String refreshToken = await Preferences.getRefreshToken();

    return HashMap.from({
      "Accept": "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $refreshToken',
      'x-api-key': FlutterConfig.get('X_API_KEY'),
      HttpHeaders.contentTypeHeader: "application/json"
    });
  }

  static String createUrl(String partial) {
    return FlutterConfig.get('API_URL') + partial;
  }

  static Future<void> refreshToken() async {
    var store = await ClarityHubStore.getStore();
    await store.dispatch(refresh());
  }

  static Future<Response> performRequest(Function callback, [int attempt = 0]) async {
    if (attempt > 3) {
      throw new Exception('Too many attempts');
    }

    Response response = await callback();

    try {
      checkResponse(response);
    } catch (e, s) {
      if (e is RefreshTokenException) {
        await refreshToken();

        return performRequest(callback, attempt + 1);
      } else {
        print("Caught: $e");
        print("Stack: $s");
        throw e;
      }
    }

    return response;
  }

  static checkResponse(Response response) {
    if (response.statusCode > 299 || response.statusCode < 200) {
      Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 401) {

        if (body['message'] == 'Expired token') {
          throw new RefreshTokenException('Expired token');
        }
      }

      print('checkResponse had the following error');
      print('response.statusCode: ${response.statusCode}');
      print('response.body: ${response.body}');

      throw new Exception(
        body['message'] ?? 'Something bad happened'
      );
    }
  
    return response;
  }

  static transformCommonExceptions(e) {
    print('transformCommonExceptions encountered the following exception:');
    print(e);

    if (e is HandshakeException) {
      return new Exception(
        'Failed to establish server connection'
      );
    } else {
      return e;
    }
  }
}
