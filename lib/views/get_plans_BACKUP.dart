/*THIS IS BODY OF THE NAVIGATION_VIEW PAGE...*/
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:ibuy_mac_1/services/database.dart';
import 'package:provider/provider.dart';
import 'package:ibuy_mac_1/widgets/program_list.dart';
import 'package:ibuy_mac_1/models/program.dart';
import 'package:ibuy_mac_1/models/user_plan.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ibuy_mac_1/models/user_profile.dart';
import 'package:ibuy_mac_1/fixed_functionalities.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoder/geocoder.dart';

class GetPlans extends StatefulWidget {
  final UserPlan userPlan;
  final UserProfile userProfile;

  GetPlans({Key key, @required this.userPlan, @required this.userProfile}) : super(key: key);

  @override
  _GetPlansState createState() => _GetPlansState();
}

class _GetPlansState extends State<GetPlans> {

  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    setState(() {
      _markers.add(Marker(
        markerId: MarkerId("0"),
        position: LatLng(43.650204, -79.903625),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Plan"),
      ),
      body: Container(
        color: Colors.white,
        child: StreamProvider<List<Program>>.value(
          value: DatabaseService().programSnapshots,
          child: Column(
            children: [
              Container(
                color: Colors.blue,
                height: 1.0.sw,
                width: 1.0.sw,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(43.650204, -79.903625),
                    zoom: 13,
                  ),
                  markers: _markers,
                ),
              ),
              Expanded(child: ProgramList(userPlan: widget.userPlan, userProfile: widget.userProfile)),
            ],
          ),
        ),
      ),
    );
  }

  final textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    contentPadding: EdgeInsets.all(8.0),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: backLight, width: 1.0), borderRadius: BorderRadius.circular(3)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: leadBase, width: 2.0), borderRadius: BorderRadius.circular(3),),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: errorBase, width: 2.0), borderRadius: BorderRadius.circular(3)),
    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: errorBase, width: 2.0), borderRadius: BorderRadius.circular(3)),
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