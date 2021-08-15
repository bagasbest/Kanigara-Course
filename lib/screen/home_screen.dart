import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanigara_course/constant/color_constant.dart' as Constant;
import 'package:kanigara_course/screen/login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomepageScreen(),
    );
  }
}

class HomepageScreen extends StatefulWidget {
  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Utama'),
        backgroundColor: Constant.colorPrimary,
        actions: [
          IconButton(
            onPressed: () {
              _showAlertDialogLogout(context);
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
    );
  }
}

void _showAlertDialogLogout(BuildContext context) {
  FirebaseAuth auth = FirebaseAuth.instance;

  _signOut(BuildContext context) async {
    await auth.signOut().then((_) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false);
    });
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Konfirmasi Logout'),
            Icon(
              Icons.logout,
              color: Constant.colorPrimary,
            ),
          ],
        ),
        content: Text('Apa anda yakin ingin Logout dari akun anda ?'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => _signOut(context),
          ),
        ],
      );
    },
  );
}
