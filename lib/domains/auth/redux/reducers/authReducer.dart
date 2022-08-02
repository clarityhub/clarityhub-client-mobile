import 'package:clarityhub/domains/auth/redux/actions/actions.dart';
import 'package:clarityhub/domains/auth/redux/store/authState.dart';
import 'package:redux/redux.dart';

final authReducer = TypedReducer<AuthState, dynamic>(_authReducer);

AuthState _authReducer(AuthState state, dynamic action) {
  if (action is LoginAuth0Success) {
    return state.copyWith(
      auth0Token: action.idToken,
    );
  } else if (action is LoginAuth0Failure) {
    return state.copyWith(
      error: action.error,
    );
  } else if (action is LoginWorkspaceLoading) {
    return state.copyWith(
      isLoading: true,
    );
  } else if (action is LoginWorkspaceSuccess) {
    return state.copyWith(
      isLoading: false,
      refreshToken: action.refreshToken,
      accessToken: action.accessToken,
      workspaceStatus: action.workspaceStatus,
    );
  } else if (action is LoginWorkspaceFailure) {
    return state.copyWith(
      isLoading: false,
      error: action.error,
    );
  } else if (action is LogoutWorkspace) {
    // Return a new auth state to clear the store
    return AuthState();
  }

  return state ?? new AuthState();
}