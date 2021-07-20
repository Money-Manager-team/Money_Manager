import 'package:flutter/material.dart';
import 'package:money_manager/router.dart';
import 'package:splashscreen/splashscreen.dart';

import 'constants.dart';

void main()
{
  runApp(MAIN());
}

class MAIN extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child:MaterialApp
      (
        debugShowCheckedModeBanner: false,
        title: "flutter_navigation_sample",
        theme: ThemeData(primarySwatch: Colors.indigo),
        initialRoute: splashScreen1,
        onGenerateRoute: createRoute,
      ),
    );
  }
}

class splashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      backgroundColor: Colors.white,
      image: Image.asset("images/logo.png"),
      photoSize: 140,
      loaderColor: Colors.green[200],
      seconds: 4,
      loadingText: Text("Loading...",),
      navigateAfterSeconds: homeRoute,

    );
  }
}