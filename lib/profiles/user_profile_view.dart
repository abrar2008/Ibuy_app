import 'package:flutter/material.dart';
import 'package:ibuy_mac_1/widgets/provider_widget.dart';
import 'package:intl/intl.dart';
import 'package:ibuy_mac_1/models/user_profile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './editUserProfile.dart';

class UserProfileView extends StatefulWidget {
  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  UserProfile userProfile = UserProfile('na', 'na', 'na', 'na', 'na', 'na',
      'na', 'na', 0.0, 0.0, 0.0, 0.0, 'na', 'na');

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: CustomProvider.of(context).auth.getCurrentUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return displayUserInformation(context, snapshot);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget displayUserInformation(context, snapshot) {
    final user = snapshot.data;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Email - ${user.email ?? 'Anonymous'}",
              style: TextStyle(fontSize: 20.ssp)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("UID - ${user.uid ?? 'Anonymous'}",
              style: TextStyle(fontSize: 15.ssp)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              "Creation - ${DateFormat("MM/dd/yyyy").format(user.metadata.creationTime)}",
              style: TextStyle(fontSize: 20.ssp)),
        ),
        FutureBuilder(
            future: _getProfileData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                _postalCodeController.text = userProfile.postalCode;
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Postal Code - ${userProfile.postalCode}",
                    style: TextStyle(fontSize: 20.ssp)),
              );
            }),
        FutureBuilder(
            future: _getProfileData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                _userNameController.text = userProfile.userName;
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Name - ${userProfile.userName}",
                    style: TextStyle(fontSize: 20.ssp)),
              );
            }),
        showSignOut(context, user.isAnonymous),
        RaisedButton(
          child: Text('Edit Profile'),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditProfileScreen(userProfile)),
            );
          },
        ),
      ],
    );
  }

  _getProfileData() async {
    final uid = await CustomProvider.of(context).auth.getCurrentUID();
    await CustomProvider.of(context)
        .db
        .collection('userData')
        .doc(uid)
        .get()
        .then((result) {
      userProfile.userName = result.data()['userName'];
      userProfile.address1 = result.data()['address1'];
      userProfile.address2 = result.data()['address2'];
      userProfile.address3 = result.data()['address3'];
      userProfile.city = result.data()['city'];
      userProfile.state = result.data()['state'];
      userProfile.country = result.data()['country'];
      userProfile.postalCode = result.data()['postalCode'];
      userProfile.cardNumberLastFour = result.data()['cardNumberLastFour'];
      userProfile.cardType = result.data()['cardType'];
    });
  }

  Widget showSignOut(context, bool isAnonymous) {
    if (isAnonymous == true) {
      return RaisedButton(
        child: Text("Sign In To Save Your Data"),
        onPressed: () {
          Navigator.of(context).pushNamed("/convertUser");
        },
      );
    } else {
      return RaisedButton(
        child: Text("Sign Out"),
        onPressed: () async {
          try {
            await CustomProvider.of(context).auth.signOut();
            Navigator.of(context).pushNamed('/signIn');
          } catch (e) {
            print(e);
          }
        },
      );
    }
  }

  void _userEditBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 0.6.sh,
            child: Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Update Profile"),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.cancel),
                        color: Colors.orange,
                        iconSize: 25.r,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: TextField(
                            controller: _userNameController,
                            decoration: InputDecoration(
                              helperText: "Name",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: TextField(
                            controller: _postalCodeController,
                            decoration: InputDecoration(
                              helperText: "Postal Code",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                          child: Text('Save'),
                          color: Colors.green,
                          textColor: Colors.white,
                          onPressed: () async {
                            setState(() {
                              userProfile.userName = _userNameController.text;
                              userProfile.postalCode =
                                  _postalCodeController.text;
                            });
                            await updateProfile(context);
                            Navigator.of(context).pop();
                          })
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future updateProfile(context) async {
    final uid = await CustomProvider.of(context).auth.getCurrentUID();
    final doc = CustomProvider.of(context).db.collection('userData').doc(uid);
    return await doc.setData(userProfile.toJson());
  }
}
