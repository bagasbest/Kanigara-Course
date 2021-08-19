import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kanigara_course/constant/color_constant.dart' as Constant;
import 'package:kanigara_course/screen/reksadana/reksadana_quiz_add.dart';
import 'package:kanigara_course/screen/reksadana/reksadana_quiz_list.dart';

class ReksadanaQuiz extends StatefulWidget {
  final String role;

  ReksadanaQuiz({required this.role});

  @override
  _ReksadanaQuizState createState() => _ReksadanaQuizState();
}

class _ReksadanaQuizState extends State<ReksadanaQuiz> {

  List chooseAnswer = [
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
    null,
  ];
  List validator = [];
  int cnt = 0;
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Quiz Reksadana',
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
                  Route route = MaterialPageRoute(
                      builder: (context) => ReksadanaQuizAdd());
                  Navigator.push(context, route);
                },
                child: Icon(Icons.add),
              )
            : Container(),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('quiz_reksadana')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return (snapshot.data!.size > 0)
                          ? ListOfQuizReksadana(
                              document: snapshot.data!.docs,
                              chooseAnswer: chooseAnswer,
                            )
                          : _emptyData();
                    } else {
                      return _emptyData();
                    }
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 200,
                  height: 40,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    child: Text(
                      'Lihat Skor',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Constant.colorSecondary,
                    onPressed: () async {
                      await getDocs();
                      print(validator);
                      print(chooseAnswer);

                      await getCorrectAnswer();

                      _showResultDialog(context);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }

  Future getDocs() async {
    if(cnt == 0) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("quiz_reksadana").get();
      for (int i = 0; i < querySnapshot.size; i++) {
        validator.insert(i, querySnapshot.docs[i]['validator']);
      }
      cnt++;
    }
  }

  Future getCorrectAnswer() async {
    if(chooseAnswer.length > 0) {
      for(int i = 0; i < validator.length; i++) {
        if(validator[i] == chooseAnswer[i]){
          score++;
        }
      }
    }
  }

  void _showResultDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Constant.colorSecondary,
          content: Text(
            'Jawaban Benar: $score\n\nJawaban Salah: ${validator.length - score}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () {
                score = 0;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}



Widget _emptyData() {
  return Container(
    child: Center(
      child: Text(
        'Tidak Ada Quiz Reksadana Tersedia',
        style: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ),
  );
}


