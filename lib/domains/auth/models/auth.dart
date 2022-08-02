import 'package:flutter_auth0/flutter_auth0.dart';
import 'package:flutter_config/flutter_config.dart';

class Auth {
  static Auth _instance;

  final String clientId = FlutterConfig.get('AUTH0_CLIENTID');
  final String domain = FlutterConfig.get('AUTH0_DOMAIN');
  Auth0 auth;

  Auth._internal() {
    auth = Auth0(baseUrl: 'https://$domain/', clientId: clientId);
  }

  static Auth getInstance() {
    if (_instance == null) {
      _instance = Auth._internal();
    }

    return _instance;
  }

  Future<String> loginAuth0() async {
    var response = await auth.webAuth.authorize({
      'audience': 'https://$domain/userinfo',
      'scope': 'openid email offline_access',
      'response_type': 'token id_token',
    });
    
    return response['id_token'];
  }

  Future<void> logoutAuth0() async {
    await auth.webAuth.clearSession();
  }
}
