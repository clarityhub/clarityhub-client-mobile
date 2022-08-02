import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';


import 'package:clarityhub/domains/medias/models/media.dart';
import 'package:clarityhub/networking.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class MediaNetworkHelper {
  static Future<Media> getMedia(String mediaId) async {
    try {
      final Response response = await NetworkHelper.performRequest(() async {
        String url = NetworkHelper.createUrl('medias/$mediaId');
        final response = await http.get(url, headers: await NetworkHelper.createHeaders());
        return response;
      });

      Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      
      return Media.fromJson(data);
    } catch (e) {
      throw NetworkHelper.transformCommonExceptions(e);
    }
  }

  static Future<Media> createMedia(Map payload) async {
    try {
      var body = json.encode(payload);

      String url = NetworkHelper.createUrl('medias');
      final response = await http.post(url, headers: await NetworkHelper.createHeaders(), body: body);

      NetworkHelper.checkResponse(response);

      Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      
      Media mediaItem = Media.fromJson(data);
    
      return mediaItem;
    } catch (e) {
      throw NetworkHelper.transformCommonExceptions(e);
    }
  }

  static Future<Map> getPresignedUrl(String id) async {
    try {
      String url = NetworkHelper.createUrl('medias/$id/actions/upload');
      final response = await http.post(url, headers: await NetworkHelper.createHeaders());

      NetworkHelper.checkResponse(response);

      Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      
      return data['presignedUrl'];
    } catch (e) {
      throw NetworkHelper.transformCommonExceptions(e);
    }
  }

  static Future<Media> uploadComplete(String id) async {
    try {
      String url = NetworkHelper.createUrl('medias/$id/actions/complete');
      final response = await http.post(url, headers: await NetworkHelper.createHeaders());

      NetworkHelper.checkResponse(response);

      Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      
      Media mediaItem = Media.fromJson(data);
    
      return mediaItem;
    } catch (e) {
      throw NetworkHelper.transformCommonExceptions(e);
    }
  }

  static Future<bool> foregroundUploadFile({
    Map<String, dynamic> presignedUrl,
    String fileName,
    String filePath, 
    String fileType
  }) async {
    String url = presignedUrl['url'];

    print('presignedUrl: $presignedUrl');
    var fileTypeParts = fileType.split('/');

    try {
      MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));
      
      presignedUrl['fields'].forEach((String key, dynamic value) {
        request.fields[key] = value.toString();
      });
      request.fields.addAll({
        'Content-Type': fileType
      });
      request.headers['Content-Type'] = 'multipart/form-data';
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          filePath,
          contentType: new MediaType(fileTypeParts[0], fileTypeParts[1]),
        )
      );

      StreamedResponse res = await request.send();

      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (e, s) {
      print('upload file failed: $e');
      print('stack: $s');
      return false;
    }
  }


  static Future<void> uploadFile({
    Map<String, dynamic> presignedUrl,
    String fileName,
    String filePath,
    String fileType,
    Function onComplete,
    Function(dynamic e, dynamic s) onFailure,
  }) async {
    if (Platform.isIOS) {
      bool result = await foregroundUploadFile(
        presignedUrl: presignedUrl,
        fileName: fileName,
        filePath: filePath,
        fileType: fileType
      );

      if (result) {
        onComplete(result);
      } else {
        onFailure(null, null);
      }
      return;
    }

    String url = presignedUrl['url'];

    try {
      final uploader = FlutterUploader();

      Map<String, String> data = new Map<String, String>();

      presignedUrl['fields'].forEach((String key, dynamic value) {
        data[key] = value.toString();
      });
      data.addAll({
        'Content-Type': fileType
      });

      var file = path.basename(filePath);
      var directory = path.dirname(filePath);
  
      print('file: $file');
      print('directory: $directory');

      final taskId = await uploader.enqueue(
        url: url,
        files: [FileItem(
          filename: file,
          savedDir: directory,
          fieldname: 'file',
        )],
        method: UploadMethod.POST,
        headers: {
          'Content-Type': 'multipart/form-data'
        },
        data: data,
        showNotification: true,
        tag: file,
      );

      uploader.result.listen((res) {
        if (res.taskId == taskId) {
          onComplete(res.statusCode >= 200 && res.statusCode < 300);
        }
      }, onError: (ex, stacktrace) {
        onFailure(ex, stacktrace);
      });

      return;
    } catch (e, s) {
      print('upload file failed: $e');
      print('stack: $s');
      onFailure(e, s);
      return;
    }
  }
}