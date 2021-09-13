import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ibuy_mac_1/widgets/custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ibuy_mac_1/fixed_functionalities.dart';

class FirstView extends StatelessWidget {
  final primaryColor = leadBase;

  @override
  Widget build(BuildContext context) {
    // final _width = MediaQuery.of(context).size.width;
    // final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: 1.0.sw,
        height: 1.0.sh,
        color: leadBase,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 0.1.sh),
                Text(
                  "Welcome",
                  style: TextStyle(fontSize: 44.ssp, color: Colors.white),
                ),
                SizedBox(height: 0.1.sh),
                AutoSizeText(
                  "Save BIG on groceries with iBuy",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40.ssp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 0.15.sh),
//                SizedBox(height: 0.07.sh, width: 0.65.sw,
                SizedBox(height: 55.h, width: 0.65.sw,
                  child: RaisedButton(
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          color: leadDark,
                          fontSize: 25.ssp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomDialog(
                          title: "Create an account?",
                          description:
                          "Find the BEST GROCERY SAVINGS near you",
                          primaryButtonText: "Create Account",
                          primaryButtonRoute: "/signUp",
                          secondaryButtonText: "Maybe Later",
                          secondaryButtonRoute: "/anonymousSignIn",
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 0.05.sh),
                FlatButton(
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white, fontSize: 25.ssp),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/signIn');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}