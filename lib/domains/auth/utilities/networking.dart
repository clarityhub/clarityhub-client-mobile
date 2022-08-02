import 'dart:async';
import 'dart:convert';

import 'package:clarityhub/networking.dart';
import 'package:clarityhub/preferences.dart';
import 'package:http/http.dart' as http;

class AuthNetworkHelper {
  static Future<bool> loginUser() async {
    try {
      String url = NetworkHelper.createUrl('auth/login');
      final response = await http.post(url, headers: await NetworkHelper.createAuth0Headers());

      NetworkHelper.checkResponse(response);

      Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      bool result = data["result"] == 'sucess';

      return result;
    } catch (e) {
      throw NetworkHelper.transformCommonExceptions(e);
    }
  }

  static Future<Map<String, dynamic>> loginWorkspace(String workspaceId) async {
    try {
      Map bodyData = {
        'workspaceId': workspaceId,
      };

      var body = json.encode(bodyData);
    
      String url = NetworkHelper.createUrl('auth/login/workspace');
      final response = await http.post(url, headers: await NetworkHelper.createAuth0Headers(), body: body);

      NetworkHelper.checkResponse(response);

      Map<String, dynamic> data = json.decode(response.body);

      String result = data["result"];
      String accessToken = data["accessToken"];
      String refreshToken = data["refreshToken"];
  
      Preferences.setToken(accessToken, refreshToken);

      return {
        'result': result,
        'accessToken': accessToken,
        'refreshToken': refreshToken
      };
    } catch (e) {
      throw NetworkHelper.transformCommonExceptions(e);
    }
  }

  static Future<Map<String, dynamic>> refresh() async {
    try {
      String url = NetworkHelper.createUrl('auth/refresh');
      final response = await http.post(url, headers: await NetworkHelper.createRefreshHeaders());

      NetworkHelper.checkResponse(response);

      Map<String, dynamic> data = json.decode(response.body);

      String result = data["result"];
      String accessToken = data["accessToken"];
      String refreshToken = data["refreshToken"];
  
      Preferences.setToken(accessToken, refreshToken);

      return {
        'result': result,
        'accessToken': accessToken,
        'refreshToken': refreshToken
      };
    } catch (e) {
      throw NetworkHelper.transformCommonExceptions(e);
    }
  }
}