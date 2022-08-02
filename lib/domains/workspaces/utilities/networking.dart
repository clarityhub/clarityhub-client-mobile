import 'dart:async';
import 'dart:convert';

import 'package:clarityhub/domains/workspaces/models/workspace.dart';
import 'package:clarityhub/networking.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class WorkspaceNetworkHelper {
  static Future<List<Workspace>> getWorkspaces() async {
    try {
      final Response response = await NetworkHelper.performRequest(() async {
        String url = NetworkHelper.createUrl('workspaces-auth');
        final response = await http.get(url, headers: await NetworkHelper.createHeaders());
        return response;
      });
      
      List list = json.decode(utf8.decode(response.bodyBytes));
      
      List<Workspace> workspaces = new List();

      Workspace workspace;
      for (int i = 0; i < list.length; i++) {
        workspace = new Workspace();
        workspace = Workspace.fromJson(list[i]);
        workspaces.add(workspace);
      }

      return workspaces;
    } catch (e) {
      throw NetworkHelper.transformCommonExceptions(e);
    }
  }

  static Future<List<Workspace>> getWorkspacesAuth0() async {
    try {
      String url = NetworkHelper.createUrl('workspaces');
      final response = await http.get(url, headers: await NetworkHelper.createAuth0Headers());

      NetworkHelper.checkResponse(response);

      List list = json.decode(response.body);
      
      List<Workspace> workspaces = new List();

      Workspace workspace;
      for (int i = 0; i < list.length; i++) {
        workspace = new Workspace();
        workspace = Workspace.fromJson(list[i]);
        workspaces.add(workspace);
      }

      return workspaces;
    } catch (e) {
      throw NetworkHelper.transformCommonExceptions(e);
    }
  }

  static Future<Workspace> createWorkspaceAuth0(String name) async {
    try {
       Map bodyData = {
        'name': name,
      };

      var body = json.encode(bodyData);

      String url = NetworkHelper.createUrl('workspaces');
      final response = await http.post(url, headers: await NetworkHelper.createAuth0Headers(), body: body);

      NetworkHelper.checkResponse(response);

      Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));

      Workspace workspace = Workspace.fromJson(data);

      return workspace;
    } catch (e) {
      throw NetworkHelper.transformCommonExceptions(e);
    }
  }
}