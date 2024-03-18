import 'package:flutter/material.dart';

import '../service/sharedPref.dart';
import 'home.dart';
import 'login.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void delayNav() async {
    await Future.delayed(const Duration(milliseconds: 250));
    String loggedID = await SharedPref.getLoggedUserID();
    if (loggedID.isNotEmpty) {
      print("got logged id ${loggedID}");
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(userID: loggedID)));
      }
    } else {
      print("didnt get any logged id");
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    delayNav();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset(
      "assets/icon.png",
      width: 200,
      height: 200,
    ));
  }
}
