import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kanigara_course/constant/color_constant.dart' as Constant;
import 'package:kanigara_course/screen/saham/saham_add_course.dart';
import 'package:kanigara_course/screen/saham/saham_list.dart';
import 'package:kanigara_course/screen/saham/saham_quiz.dart';

class SahamScreen extends StatefulWidget {
  String role;

  SahamScreen({required this.role});

  @override
  _SahamScreenState createState() => _SahamScreenState();
}

class _SahamScreenState extends State<SahamScreen> {
  int totalCourse = 0;

  _getTotalCourse() async {
    QuerySnapshot getTotalCourse =
        await FirebaseFirestore.instance.collection('saham').get();
    setState(() {
      if (getTotalCourse.size > 0) {
        totalCourse = getTotalCourse.size;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getTotalCourse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Belajar Investasi Saham',
        ),
        backgroundColor: Constant.colorPrimary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      floatingActionButton: (widget.role == 'admin')
          ? FloatingActionButton(
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (context) => SahamAddCourse());
                Navigator.push(context, route);
              },
              child: Icon(Icons.add),
            )
          : Container(),
      body: Stack(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
              color: Constant.colorSecondary,
            ),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 10),
                    child: Text(
                      'Ingin Menguji Pengetahuan Anda, terkait Saham?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 200,
                    child: RaisedButton(
                      onPressed: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => SahamQuiz(role: widget.role));
                        Navigator.push(context, route);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      color: Constant.colorBrown,
                      child: Text(
                        'Ambil Quiz',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 116),
            child: Text(
              'Terdapat total $totalCourse materi tersedia',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 146),
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('saham').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return (snapshot.data!.size > 0)
                      ? ListOfCourseSaham(
                          document: snapshot.data!.docs,
                        )
                      : _emptyData();
                } else {
                  return _emptyData();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _emptyData() {
    return Container(
      child: Center(
        child: Text(
          'Tidak Ada Materi Saham',
          style: TextStyle(
              color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}
