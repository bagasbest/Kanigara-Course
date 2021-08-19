import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kanigara_course/constant/color_constant.dart' as Constant;
import 'package:kanigara_course/database/database_service.dart';


class SahamQuizEdit extends StatefulWidget {
  final String uid;
  final String question;
  final String a;
  final String b;
  final String c;
  final String d;
  final String validator;

  SahamQuizEdit({
    required this.uid,
    required this.question,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.validator,
  });


  @override
  _SahamQuizEditState createState() => _SahamQuizEditState();
}

class _SahamQuizEditState extends State<SahamQuizEdit> {
  var _controllerQuestion = TextEditingController();
  var _controllerAnswerA = TextEditingController();
  var _controllerAnswerB = TextEditingController();
  var _controllerAnswerC = TextEditingController();
  var _controllerAnswerD = TextEditingController();
  var validator;


  List _answer = [
    'A',
    'B',
    'C',
    'D',
  ];

  final _formKey = GlobalKey<FormState>();

  bool visible = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  _initializeData() {
    setState(() {
      _controllerQuestion.text = widget.question;
      _controllerAnswerA.text = widget.a;
      _controllerAnswerB.text = widget.b;
      _controllerAnswerC.text = widget.c;
      _controllerAnswerD.text = widget.d;
      validator = widget.validator;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.colorSecondary,
      appBar: AppBar(
        title: Text(
          'Tambahkan Quiz Saham',
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        child: Row(
                          children: [
                            Text(
                              "Soal Saham",
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
                        controller: _controllerQuestion,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: "Masukkan Soal Saham",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Soal Saham tidak boleh kosong";
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        child: Row(
                          children: [
                            Text(
                              "Pilihan Ganda Saham",
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
                      Column(
                        children: [
                          TextFormField(
                            controller: _controllerAnswerA,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Masukkan Deskripsi Pilihan A",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Deskripsi Pilihan A tidak boleh kosong";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _controllerAnswerB,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Masukkan Deskripsi Pilihan B",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Deskripsi Pilihan B tidak boleh kosong";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _controllerAnswerC,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Masukkan Deskripsi Pilihan C",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Deskripsi Pilihan C tidak boleh kosong";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _controllerAnswerD,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Masukkan Deskripsi Pilihan D",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Deskripsi Pilihan D tidak boleh kosong";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.list),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: DropdownButton(
                            value: validator,
                            items: _answer.map((valueItem) {
                              return DropdownMenuItem(
                                value: valueItem,
                                child: Text(valueItem),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                validator = value;
                              });
                            },
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            hint: Row(
                              children: [
                                Text(
                                  "Jawaban Dari Soal Ini",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          visible = true;
                        });

                        await DatabaseService.updateQuiz(
                            'saham',
                            widget.uid,
                            _controllerQuestion.text,
                            _controllerAnswerA.text,
                            _controllerAnswerB.text,
                            _controllerAnswerC.text,
                            _controllerAnswerD.text,
                            validator
                        );

                        setState(() {
                          visible = false;
                          _formKey.currentState!.reset();
                          showAlertDialog(context);
                        });
                      }
                    },
                    child: Text("Perbarui Quiz Saham",
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
          'Soal Quiz Saham Berhasil Diperbarui',
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
            },
          ),
        ],
      );
    },
  );
}
