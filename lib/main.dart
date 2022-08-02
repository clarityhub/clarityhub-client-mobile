import 'package:clarityhub/domains/app/pages/splashscreen.dart';
import 'package:clarityhub/store.dart';
import 'package:clarityhub/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'domains/app/redux/store/appState.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LicenseRegistry.addLicense(() async* {
    final robotoLicense = await rootBundle.loadString('assets/fonts/LICENSE-roboto.txt');
    final opensansLicense = await rootBundle.loadString('assets/fonts/LICENSE-opensans.txt');
    yield LicenseEntryWithLineBreaks(['assets/fonts/roboto'], robotoLicense);
    yield LicenseEntryWithLineBreaks(['assets/fonts/opensans'], opensansLicense);
  });

  runZoned<Future<Null>>(() async {
    Store<AppState> store = await ClarityHubStore.getStore();

    await FlutterConfig.loadEnvVariables();
    runApp(StoreProvider(store: store, child: ClarityHubApp()));
  }, onError: (error, stackTrace) async {
    debugPrint(error.toString());
  });
}

class ClarityHubApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clarity Hub',
      theme: MyTheme.setTheme(),
      home: SplashScreen(),
    );
  }
}
