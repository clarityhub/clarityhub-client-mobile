import 'dart:async';

import 'package:clarityhub/domains/app/pages/dashboard.dart';
import 'package:clarityhub/domains/app/redux/store/appState.dart';
import 'package:clarityhub/domains/auth/pages/login.dart';
import 'package:clarityhub/domains/auth/pages/pickWorkspace.dart';
import 'package:clarityhub/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _navigate(builder) {
    Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: builder));
  }

  void checkAuthAndReroute() async {
    final store = StoreProvider.of<AppState>(context);

    if (store.state.authState.accessToken != null) {
      // User is logged in, go home
      _navigate((BuildContext context) => new Dashboard());
    } else if (store.state.authState.accessToken == null && store.state.authState.auth0Token != null) {
      // The user has not logged into a workspace
      _navigate((BuildContext context) => new PickWorkspace());
    } else if (store.state.authState.auth0Token == null) {
      // The user has not logged into auth0
      _navigate((BuildContext context) => new Login());
    } else {
      _navigate((BuildContext context) => new Login());
    }
  }

  startTimeout() async {
    var duration = const Duration(seconds: 1);
    return new Timer(duration, checkAuthAndReroute);
  }

  @override
  void initState() {
    super.initState();
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    MyTheme.init(context);

    return Scaffold(
      backgroundColor: MyTheme.brand,
      body: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             new Stack(
              children: <Widget>[
                new Container(
                  width: 190.0,
                  height: 190.0,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  )
                ),
                new Positioned(
                  child: new Image(
                    fit: BoxFit.fitWidth,
                    image: new AssetImage("assets/images/icon.png"),
                    width: 150.0,
                    height: 150.0,
                  ),
                  top: 20.0,
                  left: 20.0,
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                MyTheme.appName ?? '',
                style: GoogleFonts.roboto(
                  fontSize: MyTheme.largeText(),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
