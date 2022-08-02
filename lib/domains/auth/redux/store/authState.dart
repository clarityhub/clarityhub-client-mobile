import 'package:meta/meta.dart';

@immutable
class AuthState {
  final String auth0Token;
  final String accessToken;
  final String refreshToken;
  final error;
  final bool workspaceStatus;
  final bool isLoading;

  const AuthState({
    this.auth0Token,
    this.accessToken,
    this.refreshToken,
    this.workspaceStatus = false,
    this.error,
    this.isLoading = false,
  });
  AuthState copyWith({
    auth0Token,
    accessToken,
    refreshToken,
    workspaceStatus,
    error,
    isLoading,
  }) {
    return new AuthState(
        auth0Token: auth0Token ?? this.auth0Token,
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        workspaceStatus: workspaceStatus ?? this.workspaceStatus,
        error: error, // always clear unless it is set
        isLoading: isLoading ?? this.isLoading,
    );
  }

  static AuthState fromJson(dynamic json) => AuthState(
    auth0Token: json['auth0Token'],
    accessToken: json['accessToken'],
    refreshToken: json['refreshToken'],
    workspaceStatus: json['workspaceStatus'],
  );

  dynamic toJson() => {
    'auth0Token': auth0Token,
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'workspaceStatus': workspaceStatus,
  };
}