import 'package:clarityhub/domains/app/redux/store/appState.dart';
import 'package:clarityhub/domains/auth/redux/reducers/authReducer.dart';
import 'package:clarityhub/domains/interviews/redux/reducers/interviewReducer.dart';
import 'package:clarityhub/domains/medias/redux/reducers/mediaReducer.dart';
import 'package:clarityhub/domains/workspaces/redux/reducers/workspaceReducer.dart';

AppState appReducer(AppState currentState, dynamic action) {
  return AppState(
    authState: authReducer(currentState.authState, action),
    workspaceState: workspaceReducer(currentState.workspaceState, action),
    interviewState: interviewReducer(currentState.interviewState, action),
    mediaState: mediaReducer(currentState.mediaState, action),
  );
}