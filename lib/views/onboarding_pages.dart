import 'package:flutter/material.dart';
import 'package:ibuy_mac_1/views/first_view.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ibuy_mac_1/fixed_functionalities.dart';

class OnboardingPages extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 0.05.sh),
            Expanded(
              child: IntroductionScreen(
                showSkipButton: true,
                skip: Text(
                  'Skip',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.ssp,
                    color: Colors.blueGrey[800]
                  ),
                ),
                // skip: Icon(Icons.arrow_back_ios, size: 30.h,),
                onSkip: () {
                  Navigator.of(context).popAndPushNamed('/firstView');
                },
                showNextButton: true,
                next: Icon(Icons.arrow_forward_ios, size: 30.h, color: Colors.blueGrey[800],),
                done: Text(
                    'Done',
                  style: TextStyle(
                    color: Colors.blueGrey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20.ssp,
                  ),
                ),
                onDone: () {
                  Navigator.of(context).popAndPushNamed('/firstView');
                },
                pages: getPages(),
                globalBackgroundColor: Colors.white,
                curve: Curves.easeIn,
              ),
            ),
            SizedBox(height: 0.05.sh),
          ],
        ),
      ),
    );
  }

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        titleWidget: Text(
          '',
          style: TextStyle(
              fontSize: 30.ssp,
          ),
        ),
        image: Image.asset(
          'assets/images/onboarding_logo.png',
          scale: 3.5,
        ),
        bodyWidget: Text(
          'Cashback on EVERY DOLLAR \n that you spend on Groceries',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.ssp,
            color: Colors.blueGrey[800],
//            backgroundColor: starDark,
          ),
        ),
      ),
      PageViewModel(
        titleWidget: Text(
          'Select a Retailer',
          style: TextStyle(
            fontSize: 30.ssp,
            color: Colors.blueGrey[800],
          ),
        ),
        image: Image.asset(
          'assets/images/onboarding_store.png',
          scale: .5,
        ),
        bodyWidget: Text(
          'See which grocer is offering \nthe higher cashback',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.ssp,
            color: Colors.blueGrey[800],
          ),
        ),
      ),
      PageViewModel(
        titleWidget: Text(
          'Upload Receipts',
          style: TextStyle(
            fontSize: 30.ssp,
            color: Colors.blueGrey[800],
          ),
        ),
        image: Image.asset(
          'assets/images/onboarding_receipt.png',
          scale: .5,
        ),
        bodyWidget: Text(
          'Upload your receipts after\nevery grocery shopping',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.ssp,
            color: Colors.blueGrey[800],
          ),
        ),
      ),
      PageViewModel(
        titleWidget: Text(
          'Get Cashback!',
          style: TextStyle(
            fontSize: 30.ssp,
            color: Colors.blueGrey[800],
          ),
        ),
        image: Image.asset(
          'assets/images/onboarding_mail.png',
          scale: .5,
        ),
        bodyWidget: Text(
          'Gift voucher or check?\nBoth mailed to your address',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.ssp,
            color: Colors.blueGrey[800],
          ),
        ),
      ),
    ];
  }
}
