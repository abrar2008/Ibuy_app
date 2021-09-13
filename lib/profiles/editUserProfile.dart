import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ibuy_mac_1/models/user_profile.dart';
import 'package:ibuy_mac_1/widgets/provider_widget.dart';

class EditProfileScreen extends StatelessWidget {
  final UserProfile userProfile;

  EditProfileScreen(this.userProfile);
  @override
  Widget build(BuildContext context) {
    TextEditingController usernamecontroller = TextEditingController();
    TextEditingController addressline1controller = TextEditingController();
    TextEditingController addressline2controller = TextEditingController();
    TextEditingController addressline3controller = TextEditingController();
    TextEditingController citycontroller = TextEditingController();
    TextEditingController statecontroller = TextEditingController();
    TextEditingController countrycontroller = TextEditingController();
    TextEditingController last4controller = TextEditingController();
    TextEditingController cardtypecontroller = TextEditingController();
    TextEditingController postalcode = TextEditingController();

    usernamecontroller.text = userProfile.userName;
    addressline1controller.text = userProfile.address1;
    addressline2controller.text = userProfile.address2;
    addressline3controller.text = userProfile.address3;
    citycontroller.text = userProfile.city;
    statecontroller.text = userProfile.state;
    countrycontroller.text = userProfile.country;
    last4controller.text = userProfile.cardNumberLastFour;
    postalcode.text = userProfile.postalCode;
    double userlatit = 0.0;

    double userlongi = userProfile.userLng;
    print(userProfile.userLng.toString());
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter username';
                    } else {
                      return null;
                    }
                  },
                  controller: usernamecontroller,
                  decoration: InputDecoration(
                      labelText: 'User Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      hintText: getText(userProfile.userName, 'your name')),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Address 1';
                    } else {
                      return null;
                    }
                  },
                  controller: addressline1controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelText: 'Address 1',
                      hintText:
                          getText(userProfile.address1, 'your line address ')),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Address 2';
                    } else {
                      return null;
                    }
                  },
                  controller: addressline2controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelText: 'Address 2',
                      hintText:
                          getText(userProfile.address2, 'your line address 2')),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Address 3';
                    } else {
                      return null;
                    }
                  },
                  controller: addressline3controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelText: 'Address 3',
                      hintText:
                          getText(userProfile.address3, 'your line address 3')),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your city';
                    } else {
                      return null;
                    }
                  },
                  controller: citycontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelText: 'Your City',
                      hintText: getText(userProfile.city, 'your city')),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your state';
                    } else {
                      return null;
                    }
                  },
                  controller: statecontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelText: 'Your State',
                      hintText: getText(userProfile.state, 'Enter your state')),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your country';
                    } else {
                      return null;
                    }
                  },
                  controller: countrycontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelText: 'Your Country',
                      hintText:
                          getText(userProfile.country, 'Enter country name')),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter last 4 of your card';
                    } else {
                      return null;
                    }
                  },
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  controller: last4controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelText: 'Last 4 of your Card',
                      hintText: getText(userProfile.cardNumberLastFour,
                          'last 4 of your card')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter card type';
                    } else {
                      return null;
                    }
                  },
                  controller: cardtypecontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelText: 'Card Type',
                      hintText: getText(userProfile.cardType, 'Card Type')),
                ),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.amber)),
                  onPressed: () async {
                    final uid =
                        await CustomProvider.of(context).auth.getCurrentUID();
                    await FirebaseFirestore.instance
                        .collection('userData')
                        .doc(uid)
                        .update({
                      'userName': usernamecontroller.text,
                      'address1': addressline1controller.text,
                      'address2': addressline2controller.text,
                      'address3': addressline3controller.text,
                      'city': citycontroller.text,
                      'state': statecontroller.text,
                      'country': countrycontroller.text,
                      'cardNumberLastFour': last4controller.text,
                      'cardType': cardtypecontroller.text,
                    });
                    if (_formKey.currentState.validate()) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Data Saved')));
                    }
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  String getText(hintText, message) {
    if (hintText == 'na')
      return 'Enter $message';
    else
      return hintText;
  }
}
