import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static String appName = FlutterConfig.get('APP_NAME');
  static String termsAndConditionsUrl = FlutterConfig.get('TERMS_URL');
  static String privacyPolicyUrl = FlutterConfig.get('PRIVACY_URL');

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  static Color primary = Color.fromRGBO(86, 106, 210, 1.0);
  static Color brand = Color.fromRGBO(255, 106, 92, 1.0);
  static Color error = Color.fromRGBO(200, 100, 100, 1);

  static init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;


  }

  static setTheme() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.grey.shade50,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark),
    );

    return ThemeData(
      accentColor: MyTheme.primary,
      errorColor: MyTheme.error,
      buttonColor: MyTheme.primary,
      buttonTheme: ButtonThemeData(
        buttonColor: MyTheme.primary,
        textTheme: ButtonTextTheme.primary,
        colorScheme: ColorScheme.dark(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: MyTheme.primary,
        focusColor: MyTheme.primary,
        labelStyle: TextStyle(
          decorationColor: MyTheme.primary,
        ),
      ),
      appBarTheme: AppBarTheme(
        textTheme: GoogleFonts.robotoTextTheme(
          TextTheme(
            title: TextStyle(
              color: Colors.white,
            ),
          )
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        color: primary,
        brightness: Brightness.light,
        elevation: 0,
      ),
      scaffoldBackgroundColor: Colors.grey.shade50,
      backgroundColor: Colors.grey.shade50,
      primarySwatch: Colors.indigo, // TODO should be a series of MyTheme.primary colors
      textTheme: GoogleFonts.openSansTextTheme(TextTheme(
        body1: TextStyle(
          fontSize: 16,
        )
      )),
    );
  }

  static headingSize() {
    return safeBlockHorizontal * 5;
  }

  static largeText() {
    return safeBlockHorizontal * 7;
  }

  static normalTextSize() {
    return safeBlockHorizontal * 4;
  }

  static tinyTextSize() {
    return safeBlockHorizontal * 3.5;
  }

  static extraTinyTextSize() {
    return safeBlockHorizontal * 2.5;
  }
}
