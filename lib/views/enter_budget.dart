/*THIS IS BODY OF THE NAVIGATION_VIEW PAGE...*/
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ibuy_mac_1/services/database.dart';
import 'package:ibuy_mac_1/views/get_plans.dart';
import 'package:ibuy_mac_1/widgets/provider_widget.dart';
import 'package:provider/provider.dart';
import 'package:ibuy_mac_1/models/program.dart';
import 'package:fontisto_flutter/fontisto_flutter.dart';
import 'package:ibuy_mac_1/models/user_plan.dart';
import 'package:ibuy_mac_1/models/user_profile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ibuy_mac_1/fixed_functionalities.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'dart:math' show Random;

class EnterBudget extends StatefulWidget {
  final UserPlan userPlan;
  final UserProfile userProfile;

  EnterBudget({Key key, @required this.userPlan, @required this.userProfile})
      : super(key: key);

  @override
  _EnterBudgetState createState() => _EnterBudgetState();
}

class _EnterBudgetState extends State<EnterBudget> {
  final GlobalKey<FormState> _formKeyBudget = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _postalCodeController = TextEditingController();
  Position _position;

  Future getThisLocation() async {
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint('location: ${_position.latitude}');
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _inputBudgetController = TextEditingController();
    return Container(
      child: StreamProvider<List<Program>>.value(
        value: DatabaseService().programSnapshots,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 32, 16, 4),
                  child: Align(
                    child: Text(
                      'Enter your Monthly Grocery Budget?',
                      style: TextStyle(
                        fontSize: 20.ssp,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: Form(
                    key: _formKeyBudget,
                    child: TextFormField(
                      validator: budgetValidator,
                      controller: _inputBudgetController,
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Average Spend',
                        prefixIcon: Icon(
                          Istos.currency_dollar,
                          size: 22.r,
                          color: secondBase,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.07.sh,
                  width: 0.4.sw,
                  child: RaisedButton(
                    child: Text(
                      'Continue',
                      style: TextStyle(fontSize: 18.ssp),
                    ),
                    onPressed: () {
                      if (_formKeyBudget.currentState.validate()) {
                        widget.userPlan.budget =
                            double.parse(_inputBudgetController.text);
                        widget.userPlan.targetAchieved =
                            double.parse(_inputBudgetController.text) * (0);

                        if (widget.userProfile.postalCode == 'na') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                customDialogLocation(context),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GetPlans(
                                    userPlan: widget.userPlan,
                                    userProfile: widget.userProfile)),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customDialogLocation(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30.r),
            decoration: BoxDecoration(
                color: backLight,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
//                    color: Colors.black54,
                    blurRadius: 10.0.r,
                    offset: const Offset(0.0, 10.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // SizedBox(height: 24.0),
                AutoSizeText(
                  'Please share your location to find Cashback near you',
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.ssp,
                  ),
                ),
                SizedBox(height: 0.02.sw),
                SizedBox(
                  width: 0.65.sw,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 0.3.sw,
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'K8V L9Y L4J L9Z K0G'),
                              validator: postalCodeValidator,
                              onSaved: (String value) {
                                _postalCodeController.text = value
                                    .trim()
                                    .replaceAll(RegExp(r'[ -]'), '')
                                    .toUpperCase();
                              }),
                        ),
                      ),
                      SizedBox(width: 0.05.sw),
                      SizedBox(
                        height: 55.h,
                        width: 0.2.sw,
                        child: RaisedButton(
                          color: starBase,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0.r)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: AutoSizeText(
                              'Go',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 28.ssp,
                                fontWeight: FontWeight.w400,
//                          color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (!_formKey.currentState.validate()) {
                              return;
                            } else {
                              _formKey.currentState.save();
                              widget.userProfile.postalCode =
                                  _postalCodeController.text;
                              widget.userPlan.postalCode =
                                  _postalCodeController.text;

                              final query = _postalCodeController.text;
                              var addresses = await Geocoder.local
                                  .findAddressesFromQuery(query);
                              var first = addresses.first;
                              widget.userProfile.tempLat =
                                  first.coordinates.latitude;
                              widget.userProfile.tempLng =
                                  first.coordinates.longitude;

                              await updateProfile(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GetPlans(
                                        userPlan: widget.userPlan,
                                        userProfile: widget.userProfile)),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ), //Button
                SizedBox(height: 0.04.sh),
                AutoSizeText(
                  'OR, share current location',
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
//                    color: Colors.black,
                    fontSize: 20.ssp,
                  ),
                ),
                SizedBox(height: 0.02.sh),
                SizedBox(
                  height: 55.h,
                  width: 0.65.sw,
                  child: RaisedButton(
                    color: backDark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0.r)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: AutoSizeText(
                        'Current Location',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 28.ssp,
                          fontWeight: FontWeight.w400,
//                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await getThisLocation();
                      final coordinates =
                          Coordinates(_position.latitude, _position.longitude);
                      var addresses = await Geocoder.local
                          .findAddressesFromCoordinates(coordinates);
                      var first = addresses.first;
                      var currentPostalCode = first.postalCode;
                      // .replaceAll(RegExp(r"\s+\b|\b\s"), "");

                      widget.userPlan.postalCode = currentPostalCode;
                      widget.userProfile.postalCode = currentPostalCode;
                      widget.userProfile.userLat = _position.latitude;
                      widget.userProfile.userLng = _position.longitude;

                      await updateProfile(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GetPlans(
                                  userPlan: widget.userPlan,
                                  userProfile: widget.userProfile,
                                )),
                      );
                    },
                  ),
                ), //Button
                // showSecondaryButton(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  final textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    contentPadding: EdgeInsets.all(8.0),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: backLight, width: 1.0),
        borderRadius: BorderRadius.circular(3)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: leadBase, width: 2.0),
      borderRadius: BorderRadius.circular(3),
    ),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorBase, width: 2.0),
        borderRadius: BorderRadius.circular(3)),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorBase, width: 2.0),
        borderRadius: BorderRadius.circular(3)),
    errorStyle: TextStyle(
      color: errorBase,
      backgroundColor: starLight,
      fontSize: 16.ssp,
    ),
  );

  Future updateProfile(context) async {
    final uid = await CustomProvider.of(context).auth.getCurrentUID();
    final doc = CustomProvider.of(context).db.collection('userData').doc(uid);
    return await doc.setData(widget.userProfile.toJson());
  }
}
