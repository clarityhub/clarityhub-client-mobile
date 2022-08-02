import 'dart:async';
import 'dart:convert';

import 'package:clarityhub/domains/interviews/models/interview.dart';
import 'package:clarityhub/networking.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class InterviewsNetworkHelper {
  static Future<List<Interview>> getInterviews() async {
    try {
      final Response response = await NetworkHelper.performRequest(() async {
        String url = NetworkHelper.createUrl('interviews');
        final response = await http.get(url, headers: await NetworkHelper.createHeaders());
        return response;
      });

      Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      
      List<Interview> interviewItems = new List();
      List<dynamic> list = data["items"] as List;

      Interview interviewItem;
      for (int i = 0; i < list.length; i++) {
        interviewItem = new Interview();
        interviewItem = Interview.fromJson(list[i]);
        interviewItems.add(interviewItem);
      }

      return interviewItems;
    } catch (e) {
      throw NetworkHelper.transformCommonExceptions(e);
    }
  }

  static Future<Interview> getInterview(String interviewId) async {
    try {
      String url = NetworkHelper.createUrl('interviews/$interviewId');
      final response = await http.get(url, headers: await NetworkHelper.createHeaders());
    
      NetworkHelper.checkResponse(response);

      Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));

      return Interview.fromJson(data);
    } catch (e) {
      throw NetworkHelper.transformCommonExceptions(e);
    }
  }

  static Future<Interview> createInterview(String title, { String content }) async {
    try {
      Map bodyData = {
        'title': title,
        'content': content,
      };

      var body = json.encode(bodyData);

      String url = NetworkHelper.createUrl('interviews');
      final response = await http.post(url, headers: await NetworkHelper.createHeaders(), body: body);

      NetworkHelper.checkResponse(response);

      Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      
      Interview interviewItem = Interview.fromJson(data);
    
      return interviewItem;
    } catch (e) {
      throw NetworkHelper.transformCommonExceptions(e);
    }
  }

  static Future<Interview> editInterview(String id, String title) async {
    try {
      Map bodyData = {
        'title': title,
      };

      var body = json.encode(bodyData);

      String url = NetworkHelper.createUrl('interviews/$id');
      final response = await http.put(url, headers: await NetworkHelper.createHeaders(), body: body);

      NetworkHelper.checkResponse(response);

      Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      
      Interview interviewItem = Interview.fromJson(data);
    
      return interviewItem;
    } catch (e) {
      throw NetworkHelper.transformCommonExceptions(e);
    }
  }

  static Future<Interview> updateInterviewContent(String id, String content) async {
    try {
      Map bodyData = {
        'content': content,
      };

      var body = json.encode(bodyData);

      String url = NetworkHelper.createUrl('interviews/$id');
      final response = await http.put(url, headers: await NetworkHelper.createHeaders(), body: body);

      NetworkHelper.checkResponse(response);

      Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      
      Interview interviewItem = Interview.fromJson(data);
    
      return interviewItem;
    } catch (e) {
      throw NetworkHelper.transformCommonExceptions(e);
    }
  }
}
