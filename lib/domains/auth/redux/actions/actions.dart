// Login Auth0
import 'package:clarityhub/domains/app/redux/store/appState.dart';
import 'package:clarityhub/domains/auth/models/auth.dart';
import 'package:clarityhub/domains/auth/utilities/jwt.dart';
import 'package:clarityhub/domains/auth/utilities/networking.dart';
import 'package:clarityhub/preferences.dart';
import 'package:redux/redux.dart';

class LoginAuth0Success {
  final String idToken;

  LoginAuth0Success({ final this.idToken });
}
class LoginAuth0Failure {
  final error;

  LoginAuth0Failure({ final this.error });
}

Future<String> Function(Store<AppState>) loginAuth0() {
  return (Store<AppState> store) async {
    try {
      var idToken = await Auth.getInstance().loginAuth0();
      await Preferences.setAuth0Token(idToken);
      await AuthNetworkHelper.loginUser();

      store.dispatch(new LoginAuth0Success(idToken: idToken));

      return idToken;
    } catch (e) {
      store.dispatch(new LoginAuth0Failure(error: e));

      throw e;
    }
  };
}

// LoginWorkspace
class LoginWorkspaceLoading {}
class LoginWorkspaceSuccess {
  final String accessToken;
  final String refreshToken;
  final bool workspaceStatus;

  LoginWorkspaceSuccess({ final this.accessToken, final this.refreshToken, final this.workspaceStatus });
}

class LoginWorkspaceFailure {
  final error;

  LoginWorkspaceFailure({ final this.error });
}

bool hasExpired(token) {
  var decoded = parseJwt(token);
  String exp = decoded["exp"].toString();
  DateTime expiresAt = DateTime.fromMillisecondsSinceEpoch(int.parse(exp) * 1000);
  DateTime now = DateTime.now();

  return expiresAt.isBefore(now);
}

Future<void> verifyAuth0Token(store) async {
  String accessToken = await Preferences.getAuth0Token();

  if (accessToken == null || hasExpired(accessToken)) {
    await store.dispatch(loginAuth0());
  }
}

Future<Map<String, dynamic>> Function(Store<AppState>) loginWorkspace(workspaceId) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new LoginWorkspaceLoading());

      await verifyAuth0Token(store);

      Map<String, dynamic> response = await AuthNetworkHelper.loginWorkspace(workspaceId);

      Preferences.setToken(response['accessToken'], response['refreshToken']);

      store.dispatch(new LoginWorkspaceSuccess(
        accessToken: response['accessToken'].toString(),
        refreshToken: response['refreshToken'].toString(),
        workspaceStatus: getWorkspaceStatus(response['accessToken']),
      ));

      return response;
    } catch (e, stack) {
      print(e.toString());
      print(stack);
      store.dispatch(new LoginWorkspaceFailure(error: e));

      return null;
    }
  };
}

bool getWorkspaceStatus(token) {
  var decoded = parseJwt(token);
  return decoded['workspaceStatus'].toString() == 'true';
}

class RefreshLoading {}
class RefreshFailure {}
Future<Map<String, dynamic>> Function(Store<AppState>) refresh() {
  return (Store<AppState> store) async {
    try {
      Map<String, dynamic> response = await AuthNetworkHelper.refresh();

      Preferences.setToken(response['accessToken'], response['refrshToken']);

      store.dispatch(new LoginWorkspaceSuccess(
        accessToken: response['accessToken'],
        refreshToken: response['refreshToken'],
        workspaceStatus: getWorkspaceStatus(response['accessToken']),
      ));

      return response;
    } catch (e) {
      // TODO log the user out
      // store.dispatch(new RefreshFailure(error: e));

      return null;
    }
  };
}

class LogoutWorkspace {}

Future<void> Function(Store<AppState>) logout() {
  return (Store<AppState> store) async {
    await Auth.getInstance().logoutAuth0();

    store.dispatch(new LogoutWorkspace());
  };
}