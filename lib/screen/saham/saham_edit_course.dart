import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kanigara_course/constant/color_constant.dart' as Constant;
import 'package:kanigara_course/database/database_service.dart';

import '../register_screen.dart';

class SahamEditCourse extends StatefulWidget {
  final String uid;
  final String title;
  final String course;
  final String image;

  SahamEditCourse({
    required this.uid,
    required this.title,
    required this.course,
    required this.image,
  });

  @override
  _SahamEditCourseState createState() => _SahamEditCourseState();
}

class _SahamEditCourseState extends State<SahamEditCourse> {
  var _controllerTitle = TextEditingController();
  var _controllerCourse = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool visible = false;
  bool isImageAdd = false;
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _controllerTitle.text = widget.title;
    _controllerCourse.text = widget.course;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.colorSecondary,
      appBar: AppBar(
        title: Text(
          'Perbarui Materi Saham',
        ),
        backgroundColor: Constant.colorPrimary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Row(
                  children: [
                    (!isImageAdd)
                        ? GestureDetector(
                            onTap: () async {
                              _image =
                                  (await DatabaseService.getImageGallery())!;
                              if (_image == null) {
                                setState(() {
                                  print("Gagal ambil foto");
                                });
                              } else {
                                setState(() {
                                  isImageAdd = true;
                                  toast('Berhasil menambah foto');
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: (widget.image != '')
                                  ? Image.network(
                                      widget.image,
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                    )
                                  : DottedBorder(
                                      color: Colors.grey,
                                      strokeWidth: 1,
                                      dashPattern: [6, 6],
                                      child: Container(
                                        child: Center(
                                          child: Text("* Tambah Foto"),
                                        ),
                                      ),
                                    ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              File(_image!.path),
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        child: Row(
                          children: [
                            Text(
                              "Judul Materi Saham",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _controllerTitle,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: "Masukkan Judul Materi",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Judul Materi tidak boleh kosong";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        child: Row(
                          children: [
                            Text(
                              "Deskripsi Materi Saham",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      TextFormField(
                        controller: _controllerCourse,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Masukkan Deskripsi Materi Saham",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Deskripsi Materi Saham tidak boleh kosong";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(
                height: 7,
              ),
              Visibility(
                visible: visible,
                child: SpinKitRipple(
                  color: Colors.orange,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String? url = (_image != null)
                            ? await DatabaseService.uploadImageProductSaham(
                                _image!)
                            : null;

                        setState(() {
                          visible = true;
                        });

                        final DateTime now = DateTime.now();
                        final DateFormat formatter =
                            DateFormat('dd MMMM yyyy, hh:mm:ss');
                        final String formatted = formatter.format(now);
                        DatabaseService.updateCourseSaham(
                          _controllerTitle.text,
                          _controllerCourse.text,
                          (url != null) ? url : '',
                          formatted,
                          widget.uid,
                        );

                        setState(() {
                          visible = false;
                          _formKey.currentState!.reset();
                          _image = null;
                          isImageAdd = false;
                          showAlertDialog(context);
                        });
                      }
                    },
                    child: Text("Perbarui Materi Saham",
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    color: Colors.white,
                  ),
                ),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Constant.colorSecondary,
        content: Text(
          'Materi Saham berhasil diperbarui',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
