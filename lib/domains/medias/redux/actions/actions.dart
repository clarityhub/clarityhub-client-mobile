
import 'package:clarityhub/domains/app/redux/store/appState.dart';
import 'package:clarityhub/domains/interviews/redux/actions/actions.dart';
import 'package:clarityhub/domains/medias/models/media.dart';
import 'package:clarityhub/domains/medias/utilities/networking.dart';
import 'package:redux/redux.dart';
import 'package:path/path.dart' as path;

class GetMediaLoading {}
class GetMediaSuccess {
  final Media media;
  GetMediaSuccess({ this.media });
}
class GetMediaFailure {
  final error;
  final mediaId;

  GetMediaFailure({ this.error, this.mediaId });
}

Future<Media> Function(Store<AppState>) getMedia(String mediaId) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new GetMediaLoading());
      
      Media media = await MediaNetworkHelper.getMedia(mediaId);

      store.dispatch(new GetMediaSuccess(media: media)); 

      return media;
    } catch (e) {
      print(e);

      store.dispatch(new GetMediaFailure(error: e, mediaId: mediaId ));

      return null;
    }
  };
}

class CreateMediaLoading {}
class CreateMediaSuccess {
  final Media media;
  CreateMediaSuccess({ this.media });
}
class CreateMediaFailure {
  final error;

  CreateMediaFailure({ this.error });
}

Future<Media> Function(Store<AppState>) createMedia(String fileType, String fileName, String action) {
  Map<String, String> payload = {
    'action': action != null ? '$action' : '',
    'status': 'uploading',
    'fileType': fileType, 
    'filename': fileName,
  };

  return (Store<AppState> store) async {
    try {
      store.dispatch(new CreateMediaLoading());
      
      Media media = await MediaNetworkHelper.createMedia(payload);

      store.dispatch(new CreateMediaSuccess(media: media)); 

      return media;
    } catch (e) {
      print(e);

      store.dispatch(new CreateMediaFailure(error: e));

      return null;
    }
  };
}


class UploadCompleteMediaLoading {}
class UploadCompleteMediaSuccess {
  final Media media;
  UploadCompleteMediaSuccess({ this.media });
}
class UploadCompleteMediaFailure {
  final error;
  final mediaId;

  UploadCompleteMediaFailure({ this.error, this.mediaId });
}

Future<Media> Function(Store<AppState>) uploadComplete(String id) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new UploadCompleteMediaLoading());
      
      Media media = await MediaNetworkHelper.uploadComplete(id);

      store.dispatch(new UploadCompleteMediaSuccess(media: media)); 

      return media;
    } catch (e) {
      print(e);

      store.dispatch(new UploadCompleteMediaFailure(error: e, mediaId: id));

      return null;
    }
  };
}


Future<Media> Function(Store<AppState>) addMediaToInterview(String interviewId, { localPath, fileType, action }) {
  return (Store<AppState> store) async {
    String fileName = path.basename(localPath);
    Media media = await store.dispatch(createMedia(
      fileType,
      fileName,
      action,
    ));

    await store.dispatch(
      updateInterviewContentMedia(interviewId, media)
    );

    Map<String, dynamic> presignedUrl = await MediaNetworkHelper.getPresignedUrl(media.id);
    
    Function onComplete = (bool result) {
      if (result) {
        store.dispatch(uploadComplete(media.id));
      } else {
        // TODO
      }
    };

    Function onFailure = (e, s) {
      // TODO
    };

    await MediaNetworkHelper.uploadFile(
      presignedUrl: presignedUrl,
      fileName: fileName,
      filePath: localPath,
      fileType: fileType,
      onComplete: onComplete,
      onFailure: onFailure,
    );

    return media;
  };
}