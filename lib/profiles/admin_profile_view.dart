import 'package:flutter/material.dart';
import 'package:ibuy_mac_1/widgets/provider_widget.dart';


class AdminProfileView extends StatefulWidget {
  @override
  _AdminProfileViewState createState() => _AdminProfileViewState();
}

class _AdminProfileViewState extends State<AdminProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: Center(
        child: Text('build logic'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Sign Out'),
        onPressed: () async {
    try {
      await CustomProvider.of(context).auth.signOut();
      Navigator.of(context).pushNamed('/signIn');
    } catch (e) {
      print(e);
    }
  },
      ),
    );
  }
}
