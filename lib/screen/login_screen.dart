import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kanigara_course/constant/color_constant.dart' as Constant;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kanigara_course/screen/register_screen.dart';

import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPageScreen(),
    );
  }
}

class LoginPageScreen extends StatefulWidget {
  @override
  _LoginPageScreenState createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
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
              'LOGIN',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              'Dengan Memasukkan Email & Kata Sandi',
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
                  /// TOMBOL LOGIN
                  Container(
                    width: 200,
                    height: 40,
                    child: RaisedButton(
                        color: Constant.colorSecondary,
                        child: Text(
                          'Login',
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

                            /// CEK APAKAH EMAIL DAN PASSWORD SUDAH TERDAFTAR / BELUM
                            bool shouldNavigate = await _signInHandler(
                              _emailController.text,
                              _passwordController.text,
                            );

                            if (shouldNavigate) {
                              setState(() {
                                _visible = false;
                              });

                              _formKey.currentState!.reset();

                              /// MASUK KE HOMEPAGE JIKA SUKSES
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
                          MaterialPageRoute(builder: (context) => RegisterPage());
                      Navigator.push(context, route);
                    },
                    splashColor: Colors.grey[200],
                    child: Text(
                      'Saya Ingin Mendaftar',
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
      ),
    );
  }

  _signInHandler(String email, String password) async {
    try {
      (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;

      return true;
    } catch (error) {
      String errorType = '';
      if (Platform.isAndroid) {
        switch (error) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorType = 'Akun tidak terdaftar';
            break;
          case 'The password is invalid or the user does not have a password.':
            errorType = 'password salah';
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorType = 'Sedang terdapat gangguan pada jaringan';
            break;

          default:
            print('Case $error is not yet implemented');
        }
      }
      toast(errorType);
      return false;
    }
  }

  void toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Constant.colorPrimary,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
