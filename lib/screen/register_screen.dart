import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kanigara_course/constant/color_constant.dart' as Constant;
import 'package:kanigara_course/screen/login_screen.dart';

import 'home_screen.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
                color: Constant.colorPrimary,
                borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              )
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'REGISTRASI',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            'Registrasi Akun Secara Gratis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                /// KOLOM NAMA
                Container(
                  margin: EdgeInsets.only(top: 10,left: 16,right: 16),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    controller: _nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: 'Nama Lengkap',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nama Lengkap tidak boleh kosong';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),

                /// KOLOM EMAIL
                Container(
                  margin: EdgeInsets.only(top: 10,left: 16,right: 16),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email tidak boleh kosong';
                      } else if (!value.contains('@') || !value.contains('.')) {
                        return 'Format Email tidak sesuai';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),

                /// KOLOM PASSWORD
                Container(
                  margin: EdgeInsets.only(top: 10,left: 16,right: 16),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: 'Kata Sandi',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        child: Icon(_showPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                      ),
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Kata Sandi tidak boleh kosong';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),

                /// LOADING INDIKATOR
                Visibility(
                  visible: _visible,
                  child: SpinKitRipple(
                    color: Constant.colorPrimary,
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                /// TOMBOL REGISTRASI
                Container(
                  width: 200,
                  height: 40,
                  child: RaisedButton(
                      color: Constant.colorSecondary,
                      child: Text(
                        'Registrasi',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(29)),
                      onPressed: () async {
                        /// CEK APAKAH EMAIL DAN PASSWORD SUDAH TERISI DENGAN FORMAT YANG BENAR
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _visible = true;
                          });

                          bool shouldNavigate = await _registerHandler();

                          if (shouldNavigate) {
                            await _registeringUserToDatabase();

                            setState(() {
                              _visible = false;
                            });

                            _formKey.currentState!.reset();
                            Route route = MaterialPageRoute(
                                builder: (context) => HomeScreen());
                            Navigator.pushReplacement(context, route);
                          }
                        }
                      }),
                ),
                FlatButton(
                  onPressed: () {
                    Route route =
                        MaterialPageRoute(builder: (context) => LoginPage());
                    Navigator.push(context, route);
                  },
                  splashColor: Colors.grey[200],
                  child: Text(
                    'Ke Halaman Login',
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _registerHandler() async {
    try {
      await FirebaseAuth
          .instance
          .createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
      return true;
    } catch (error) {
      switch (error) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          toast('Email yang anda daftarkan telah terpakai');
          break;
        default:
          toast(
              'Terjadi error yang tidak diketahui, silahkan cek koneksi internet anda');
      }
      return false;
    }
  }

  _registeringUserToDatabase() {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore
      .instance
      .collection('users')
      .doc(uid)
      .set({
        "uid": uid,
        "name": _nameController.text,
        "email": _emailController.text,
      });
    } catch(error) {
      toast("Gagal melakukan pendaftaran, silahkan cek koneksi internet anda");
    }
  }
}

void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      fontSize: 16.0);
}
