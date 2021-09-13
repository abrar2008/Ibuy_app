import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDialog extends StatelessWidget {
  final primaryColor = const Color(0xFF37474F);
  final blueColor = const Color(0xFF2196F3);
//  final backColor = const Color(0xFF607D8B);
  final backColor = const Color(0xFFFFFFFF);
//  final buttonColor = const Color(0xFFFFC107);
  final buttonColor = const Color(0xFFFFC107);

  final String title,
      description,
      primaryButtonText,
      primaryButtonRoute,
      secondaryButtonText,
      secondaryButtonRoute;

  CustomDialog(
      {@required this.title,
        @required this.description,
        @required this.primaryButtonText,
        @required this.primaryButtonRoute,
        this.secondaryButtonText,
        this.secondaryButtonRoute});

  static const double padding = 30.0;

  @override
  Widget build(BuildContext context) {
    // final _width = MediaQuery.of(context).size.width;
    // final _height = MediaQuery.of(context).size.height;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
                color: backColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(padding),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0.r,
                    offset: const Offset(0.0, 10.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // SizedBox(height: 24.0),
                // AutoSizeText(
                //   title,
                //   maxLines: 2,
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     color: primaryColor,
                //     fontSize: 28.ssp,
                //   ),
                // ),
                SizedBox(height:  0.02.sh),
                AutoSizeText(
                  description,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 20.ssp,
                  ),
                ),
                SizedBox(height: 0.07.sh),
                SizedBox(height: 55.h, width: 0.65.sw,
                  child: RaisedButton(
                    color: buttonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0.r)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: AutoSizeText(
                        primaryButtonText,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 28.ssp,
                          fontWeight: FontWeight.w400,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushReplacementNamed(primaryButtonRoute);
                    },
                  ),
                ),
                SizedBox(height: 0.02.sh),
                showSecondaryButton(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  showSecondaryButton(BuildContext context) {
    if (secondaryButtonRoute != null && secondaryButtonText != null ){
      return FlatButton(
        child: AutoSizeText(
          secondaryButtonText,
          maxLines: 1,
          style: TextStyle(
            fontSize: 20.ssp,
            color: primaryColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(secondaryButtonRoute);
        },
      );
    } else {
      return SizedBox(height: 10.h);
    }
  }
}