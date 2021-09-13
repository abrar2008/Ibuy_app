/*THIS IS BODY OF THE NAVIGATION_VIEW PAGE...*/
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ibuy_mac_1/services/database.dart';
import 'package:provider/provider.dart';
import 'package:ibuy_mac_1/widgets/program_list.dart';
import 'package:ibuy_mac_1/models/program.dart';
import 'package:ibuy_mac_1/models/user_plan.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ibuy_mac_1/models/user_profile.dart';
import 'package:ibuy_mac_1/fixed_functionalities.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/program_distance.dart';
import 'package:darq/darq.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class GetPlans extends StatefulWidget {
  final UserPlan userPlan;
  final UserProfile userProfile;

  GetPlans({Key key, @required this.userPlan, @required this.userProfile})
      : super(key: key);

  @override
  _GetPlansState createState() => _GetPlansState();
}

class _GetPlansState extends State<GetPlans> {
  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _mapController;
  MarkerId markerId2 = MarkerId('2');
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("0"),
          icon: BitmapDescriptor.defaultMarkerWithHue(0.0),
          position:
              LatLng(widget.userProfile.userLat, widget.userProfile.userLng),
          // position: LatLng(widget.positionVar.coordinates.latitude,widget.positionVar.coordinates.longitude),
          infoWindow: InfoWindow(
            title: "Georgetown",
            snippet: "It Rocks!!",
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    final String user = FirebaseAuth.instance.currentUser.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Plan"),
      ),
      body: Container(
        color: Colors.white,
        child: StreamProvider<List<Program>>.value(
          value: DatabaseService().programSnapshots,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('userData')
                  .doc(user)
                  .snapshots(),
              builder: (context, snapshot1) {
                if (!snapshot1.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('planSummary')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      dynamic document = snapshot.data.docs;
                      List<ProgramDistance> db = [];
                      for (int i = 0; i < document.length; i++) {
                        db.add((ProgramDistance(
                          distanceBetween: Geolocator.distanceBetween(
                                snapshot1.data.data()['userLat'],
                                snapshot1.data.data()['userLng'],
                                double.parse(document[i]['latitude']),
                                double.parse(document[i]['logitude']),
                              ) /
                              1000,
                          latituteRetailer:
                              double.parse(document[i]['latitude']),
                          retailerpartnername: document[i]
                              ['retailerpartnetname'],
                          cashbackrange: document[i]['cashbackrange'],
                          addressStore: document[i]['storeaddressline1'],
                        )));
                      }
                      db.sort((a, b) {
                        return a.distanceBetween.compareTo(b.distanceBetween);
                      });

                      for (int i = 0; i < document.length; i++)
                        print(db[i].distanceBetween);

                      if (!snapshot.hasData) {
                        Center(child: CircularProgressIndicator());
                      }
                      final PanelController _pc = new PanelController();
                      return SlidingUpPanel(
                          color: Colors.amber[100],
                          backdropEnabled: true,
                          controller: _pc,
                          panelSnapping: true,
                          body: Container(
                            color: Colors.blue,
                            child: GoogleMap(
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(widget.userProfile.userLat,
                                    widget.userProfile.userLng),
                                zoom: 13,
                              ),
                              markers: _markers,
                            ),
                          ),
                          parallaxEnabled: true,
                          isDraggable: true,
                          parallaxOffset: .5,
                          panelBuilder: (ScrollController sc) {
                            return ClipRRect(
                              borderRadius: radius,
                              child: ListView.builder(
                                  controller: sc,
                                  shrinkWrap: true,
                                  // reverse: true,
                                  itemCount: document.length,
                                  itemBuilder: (context, index) {
                                    return ProgramList(
                                      userPlan: widget.userPlan,
                                      userProfile: widget.userProfile,
                                      retailername:
                                          db[index].retailerpartnername,
                                      storeaddress: db[index].addressStore,
                                      cashbackrangefire:
                                          db[index].cashbackrange.toString(),
                                      storelatitude: double.parse(
                                          document[index]['latitude']),
                                      storelogitude: double.parse(
                                          document[index]['logitude']),
                                      distanceBetween: db[index]
                                          .distanceBetween
                                          .roundToDouble(),
                                      retailerID: document[index]['id'],
                                    );
                                  }),
                            );
                          });
                    });
              }),
        ),
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
  );
  // Future updateProfile(context) async {
  //   final uid = await CustomProvider
  //       .of(context)
  //       .auth
  //       .getCurrentUID();
  //   final doc = CustomProvider
  //       .of(context)
  //       .db
  //       .collection('userData')
  //       .doc(uid);
  //   return await doc.setData(widget.userProfile.toJson());
  // }
}
