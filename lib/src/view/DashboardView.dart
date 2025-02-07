import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  DashboardViewState createState() => DashboardViewState();
}

class DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Navigation Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Home
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Verified Users'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Settings
            },
          ),
          ListTile(
            leading: Icon(Icons.contacts),
            title: Text('Pending User Verification'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Contacts
            },
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontFamily: 'SmoochSans',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text('Dashboard View'),
      ),
    );
  }
}