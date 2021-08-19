import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanigara_course/constant/color_constant.dart' as Constant;
import 'package:kanigara_course/screen/login_screen.dart';
import 'package:kanigara_course/screen/reksadana/reksadana_screen.dart';
import 'package:kanigara_course/screen/saham/saham_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = '';
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String role = '';

  _initializeData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      setState(() {
        name = value.data()!['name'];
        role = value.data()!['role'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Kanigara Course'),
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),

                /// TAMPILKAN NAMA PENGGUNA
                child: Text(
                  'Hai, $name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            /// REKSADANA
            Padding(
              padding: EdgeInsets.only(
                  left: 16.0,
                  top: MediaQuery.of(context).size.height * 0.07,
                  right: 16,
                  bottom: 16),
              child: GestureDetector(
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => ReksadanaScreen(role: role));
                  Navigator.push(context, route);
                },
                child: Stack(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: [
                              Constant.colorPrimary,
                              Constant.colorSecondary
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Constant.colorSecondary,
                              blurRadius: 7,
                              offset: Offset(0, 6),
                            )
                          ]),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      top: 0,
                      child: CustomPaint(
                        size: Size(100, 150),
                        painter: CustomCardShapePainter(
                          radius: 24,
                          startColor: Constant.colorSecondary,
                          endColor: Constant.colorPrimary,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 30),
                          child: Image.asset(
                            'assets/reksadana.png',
                            height: 80,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  'Belajar Investasi Reksadana',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                'Reksada merupakan instrumen investasi, dimana dana anda akan dikelola oleh manager investasi',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),

            /// SAHAM
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => SahamScreen(role: role));
                  Navigator.push(context, route);
                },
                child: Stack(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: [
                              Constant.colorPrimary,
                              Constant.colorSecondary
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Constant.colorSecondary,
                              blurRadius: 7,
                              offset: Offset(0, 6),
                            )
                          ]),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      top: 0,
                      child: CustomPaint(
                        size: Size(100, 150),
                        painter: CustomCardShapePainter(
                          radius: 24,
                          startColor: Constant.colorSecondary,
                          endColor: Constant.colorPrimary,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 30),
                          child: Image.asset(
                            'assets/saham.png',
                            height: 80,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  'Belajar Investasi Saham',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                'Investasi saham merupakan salah satu produk investasi yang tersedia untuk menunjang pengembangan kekuatan finansial Anda',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.119),
              decoration: BoxDecoration(
                color: Constant.colorSecondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
            )
          ],
        ),
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

class CustomCardShapePainter extends CustomPainter {
  late final double radius;
  late final Color startColor;
  late final Color endColor;

  CustomCardShapePainter({
    required this.radius,
    required this.startColor,
    required this.endColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;
    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
