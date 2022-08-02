import 'package:clarityhub/domains/app/redux/store/appState.dart';
import 'package:clarityhub/domains/auth/pages/pickWorkspace.dart';
import 'package:clarityhub/domains/auth/redux/actions/actions.dart';
import 'package:clarityhub/theme.dart';
import 'package:clarityhub/widgets/customtext.dart';
import 'package:clarityhub/widgets/headerText.dart';
import 'package:clarityhub/widgets/linkbutton.dart';
import 'package:clarityhub/widgets/outlineButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  dynamic currentWebAuth;
  bool isLoading = false;

  void webLogin() async {
    try {
      setState(() {
        isLoading = true;
      });
      final store = StoreProvider.of<AppState>(context);

      setState(() {
        isLoading = true;
      });

      var result = await store.dispatch(loginAuth0());

      if (result != null) {
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (BuildContext context) => new PickWorkspace()));
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: 'Failed to log in.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: MyTheme.error,
        textColor: Colors.white,
        fontSize: 16.0
      );
      print('Error: $e');
    }
  }

  void _handleTermsTap() async {
    String url = MyTheme.termsAndConditionsUrl;
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _handlePrivacyTap() async {
    String url = MyTheme.privacyPolicyUrl;
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    MyTheme.init(context);

    return Scaffold(
      body: new Center(
        child: isLoading ? CircularProgressIndicator() : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            HeaderText(MyTheme.appName),
            Padding(
              padding: const EdgeInsets.fromLTRB(70, 70, 70, 70),
              child: Container(
                width: double.infinity,
                child: CHOutlineButton(
                  text: 'LOGIN',
                  onPressed: webLogin,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: CustomText(
                alignment: TextAlign.center,
                title:
                    'By clicking on "Login" above, you acknowledge that you have read, understood, and agree to:',
                size: MyTheme.tinyTextSize(),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LinkButton(
                  title: 'Terms and Conditions',
                  onPressed: _handleTermsTap,
                  size: MyTheme.tinyTextSize(),
                ),
                LinkButton(
                  title: 'Privacy Policy',
                  onPressed: _handlePrivacyTap,
                  size: MyTheme.tinyTextSize(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
