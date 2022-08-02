
import 'dart:collection';

import 'package:clarityhub/domains/medias/models/media.dart';
import 'package:clarityhub/domains/medias/redux/actions/actions.dart';
import 'package:clarityhub/domains/medias/redux/store/mediaState.dart';
import 'package:redux/redux.dart';

final mediaReducer = TypedReducer<MediaState, dynamic>(_mediaReducer);

MediaState _mediaReducer(MediaState state, dynamic action) {
  if (action is GetMediaLoading) {
    return state.copyWith(
      isLoading: true,
      error: null,
    );
  } else if (action is GetMediaSuccess) {
    Map medias = state.medias;
    medias[action.media.id] = action.media;

    var mediaErrors = state.mediaErrors;
    mediaErrors[action.media.id] = null;

    return state.copyWith(
      isLoading: false,
      error: null,
      medias: medias,
      mediaErrors: mediaErrors
    );
  } else if (action is GetMediaFailure) {
    var mediaErrors = state.mediaErrors;

    mediaErrors[action.mediaId] = action.error;
    return state.copyWith(
      isLoading: false,
      mediaErrors: mediaErrors
    );
  } else if (action is CreateMediaLoading) {
    // nothing to update
    return state;
  } else if (action is CreateMediaSuccess) {
    Map medias = state.medias;
    medias[action.media.id] = action.media;
    return state.copyWith(
      medias: medias,
    );
  } else if (action is CreateMediaFailure) {
    return state.copyWith(
      error: action.error,
    );
  } else if (action is UploadCompleteMediaLoading) {
    // nothing to update
    return state;
  } else if (action is UploadCompleteMediaSuccess) {
    Map medias = state.medias;
    medias[action.media.id] = action.media;
    return state.copyWith(
      medias: medias,
    );
  } else if (action is UploadCompleteMediaFailure) {
    Map mediaErrors = state.mediaErrors;
    mediaErrors[action.mediaId] = action.error;
    return state.copyWith(
      mediaErrors: mediaErrors
    );
  }

  return state ?? new MediaState(
    medias: new LinkedHashMap<String, Media>(),
    mediaErrors: new LinkedHashMap<String, dynamic>(),
  );
}