import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kanigara_course/constant/color_constant.dart' as Constant;
import 'package:kanigara_course/screen/saham/saham_quiz_edit.dart';

import '../register_screen.dart';


class ListOfQuizSaham extends StatefulWidget {
  final List<DocumentSnapshot> document;
  final List chooseAnswer;

  ListOfQuizSaham({
    required this.document,
    required this.chooseAnswer,
  });

  @override
  _ListOfQuizSahamState createState() => _ListOfQuizSahamState();
}

class _ListOfQuizSahamState extends State<ListOfQuizSaham> {

  List choose = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ];
  List _answer = [
    'A',
    'B',
    'C',
    'D',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.document.length,
      itemBuilder: (BuildContext context, int i) {
        String uid = widget.document[i]['uid'].toString();
        String question = widget.document[i]['question'].toString();
        String a = widget.document[i]['a'].toString();
        String b = widget.document[i]['b'].toString();
        String c = widget.document[i]['c'].toString();
        String d = widget.document[i]['d'].toString();
        String validator = widget.document[i]['validator'].toString();
        return GestureDetector(
          onTap: () {
            _showAlertDialog(
              uid,
              question,
              a,
              b,
              c,
              d,
              validator,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${i + 1} $question',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'a. $a',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                'b. $b',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                'c. $c',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                'd. $d',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              DropdownButton(
                hint: Text('Pilih Jawaban ${i + 1}'),
                value: choose[i],
                isExpanded: true,
                underline: SizedBox(),
                items: _answer.map((value) {
                  return DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(
                        () {
                      if (widget.chooseAnswer.length > i) {
                        widget.chooseAnswer.removeAt(i);
                      }
                      widget.chooseAnswer.insert(i, value);
                      choose[i] = value;
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _showAlertDialog(
      String uid,
      String question,
      String a,
      String b,
      String c,
      String d,
      validator,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Constant.colorSecondary,
          content: Container(
            height: 150,
            child: Column(
              children: [
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Route route = MaterialPageRoute(
                      builder: (context) => SahamQuizEdit(
                        uid: uid,
                        question: question,
                        a: a,
                        b: b,
                        c: c,
                        d: d,
                        validator: validator,
                      ),
                    );
                    Navigator.push(context, route);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    'Perbarui Soal',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Constant.colorBrown,
                ),
                RaisedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('quiz_saham')
                        .doc(uid)
                        .delete()
                        .then(
                          (value) => {
                        toast('Berhasil Menghapus Soal'),
                      },
                    );

                    Navigator.of(context).pop();

                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    'Hapus Soal',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Constant.colorBrown,
                ),
                RaisedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    'Batalkan',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Constant.colorBrown,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
