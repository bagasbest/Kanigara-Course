import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kanigara_course/constant/color_constant.dart' as Constant;
import 'package:kanigara_course/screen/reksadana/reksadana_edit_course.dart';

import '../register_screen.dart';

class ReksadanaDetail extends StatefulWidget {
  final String uid;
  final String title;
  final String course;
  final String addedDate;
  final String updateDate;
  final String image;

  ReksadanaDetail({
    required this.uid,
    required this.title,
    required this.course,
    required this.addedDate,
    required this.updateDate,
    required this.image,
  });

  @override
  _ReksadanaDetailState createState() => _ReksadanaDetailState();
}

class _ReksadanaDetailState extends State<ReksadanaDetail> {
  String role = '';

  _initializeRole() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      setState(() {
        role = value.data()!['role'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kelas Reksadana',
        ),
        backgroundColor: Constant.colorPrimary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          (role == 'admin')
              ? PopupMenuButton(
                  onSelected: _handleClick,
                  itemBuilder: (BuildContext context) {
                    return {'Edit Materi', 'Hapus Materi'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                )
              : Container()
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              (widget.image != '')
                  ? widget.image
                  : 'https://images.unsplash.com/photo-1579621970795-87facc2f976d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          widget.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        widget.course,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Diunggah pada: ${widget.addedDate}',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Diperbarui pada: ${widget.updateDate}',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleClick(String value) {
    switch (value) {
      case 'Edit Materi':
        Route route = MaterialPageRoute(
            builder: (context) => ReksadanaEditCourse(
                  uid: widget.uid,
                  title: widget.title,
                  course: widget.course,
                  image: widget.image,
                ));
        Navigator.push(context, route);
        break;
      case 'Hapus Materi':
        _deleteCourse(context, widget.uid);
        break;
    }
  }

  _deleteCourse(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text('Konfirmasi Menghapus'),
              Icon(
                Icons.delete,
                color: Constant.colorSecondary,
              ),
            ],
          ),
          content: Text(
              'Apakah anda yakin ingin menghapus materi "${widget.title}" ?'),
          actions: [
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('reksadana')
                    .doc(uid)
                    .delete()
                    .then(
                      (value) => {
                        toast(
                          'Berhasil Menghapus Materi ${widget.title}',
                        ),
                      },
                    )
                    .catchError(
                  (error) {
                    toast('Gagal Menghapus Materi ${widget.title}');
                  },
                );
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
