import 'dart:collection';

import 'package:clarityhub/domains/auth/redux/store/authState.dart';
import 'package:clarityhub/domains/interviews/redux/store/interviewState.dart';
import 'package:clarityhub/domains/medias/models/media.dart';
import 'package:clarityhub/domains/medias/redux/store/mediaState.dart';
import 'package:clarityhub/domains/workspaces/redux/store/workspaceState.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final AuthState authState;
  final WorkspaceState workspaceState;
  final InterviewState interviewState;
  final MediaState mediaState;

  const AppState({
    @required this.authState,
    @required this.workspaceState,
    @required this.interviewState,
    @required this.mediaState,
  });

  @override
  String toString() {
    return 'AppState: {$authState\n$workspaceState\n$interviewState\n$mediaState}';
  }

  factory AppState.initialState() => AppState(
      authState: AuthState(),
      workspaceState: WorkspaceState(),
      interviewState: InterviewState(),
      mediaState: MediaState(
        medias: new LinkedHashMap<String, Media>(),
        mediaErrors: new LinkedHashMap<String, dynamic>()
      ),
  );

  static AppState fromJson(dynamic json) {
    if (json == null) {
      return AppState.initialState();
    }

    return AppState(
      authState: AuthState.fromJson(json['authState']),
      workspaceState: WorkspaceState.fromJson(json['workspaceState']),
      interviewState: InterviewState.fromJson(json['interviewState']),
      mediaState: MediaState.fromJson(json['mediaState']),
    );
  }

  dynamic toJson() {
    return {
      'authState': this.authState.toJson(),
      'workspaceState': this.workspaceState.toJson(),
      'interviewState': this.interviewState.toJson(),
      'mediaState': this.mediaState.toJson(),
    };
  }
}