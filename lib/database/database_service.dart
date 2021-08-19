import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kanigara_course/screen/register_screen.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseService {
  static Future<XFile?> getImageGallery() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if ((image != null)) {
      return image;
    } else {
      return null;
    }
  }

  static Future<String?> uploadImageProduct(XFile imageFile) async {
    String filename = basename(imageFile.path);

    FirebaseStorage storage = FirebaseStorage.instance;
    final Reference reference =
        storage.ref().child('course/reksadana/$filename');
    await reference.putFile(File(imageFile.path));

    String downloadUrl = await reference.getDownloadURL();
    if (downloadUrl != null) {
      return downloadUrl;
    } else {
      return null;
    }
  }

  static void setCourse(
      String title, String course, String url, String formatted) {
    try {
      var timeInMillis = DateTime.now().millisecondsSinceEpoch;
      FirebaseFirestore.instance
          .collection('reksadana')
          .doc(timeInMillis.toString())
          .set({
        'uid': timeInMillis.toString(),
        'title': title,
        'description': course,
        'dateAdded': formatted,
        'dateUpdated': formatted,
        'image': url,
      });
    } catch (error) {
      toast(
          'Gagal Membuat Materi Reksadana, silahkan cek koneksi anda dan coba lagi nanti');
    }
  }

  static void updateCourse(
      String title, String course, String url, String formatted, String uid) {
    try {
      FirebaseFirestore.instance.collection('reksadana').doc(uid).update({
        'title': title,
        'description': course,
        'dateUpdated': formatted,
        'image': url,
      });
    } catch (error) {
      toast(
          'Gagal Memperbarui Materi Reksadana, silahkan cek koneksi anda dan coba lagi nanti');
    }
  }

  static uploadImageProductSaham(XFile imageFile) async {
    String filename = basename(imageFile.path);

    FirebaseStorage storage = FirebaseStorage.instance;
    final Reference reference = storage.ref().child('course/saham/$filename');
    await reference.putFile(File(imageFile.path));

    String downloadUrl = await reference.getDownloadURL();
    if (downloadUrl != null) {
      return downloadUrl;
    } else {
      return null;
    }
  }

  static void setCourseSaham(
      String title, String course, String url, String formatted) {
    try {
      var timeInMillis = DateTime.now().millisecondsSinceEpoch;
      FirebaseFirestore.instance
          .collection('saham')
          .doc(timeInMillis.toString())
          .set({
        'uid': timeInMillis.toString(),
        'title': title,
        'description': course,
        'dateAdded': formatted,
        'dateUpdated': formatted,
        'image': url,
      });
    } catch (error) {
      toast(
          'Gagal Membuat Materi Saham, silahkan cek koneksi anda dan coba lagi nanti');
    }
  }

  static void updateCourseSaham(
      String title, String course, String url, String formatted, String uid) {
    try {
      FirebaseFirestore.instance.collection('saham').doc(uid).update({
        'title': title,
        'description': course,
        'dateUpdated': formatted,
        'image': url,
      });
    } catch (error) {
      toast(
          'Gagal Memperbarui Materi Reksadana, silahkan cek koneksi anda dan coba lagi nanti');
    }
  }

  static setQuiz(
    String option,
    int timeInMillis,
    String question,
    String a,
    String b,
    String c,
    String d,
    chooseAnswer,
  ) {
    try {
      if (option == 'reksadana') {
        FirebaseFirestore.instance
            .collection('quiz_reksadana')
            .doc(timeInMillis.toString())
            .set({
          'question': question,
          'uid': timeInMillis.toString(),
          'a': a,
          'b': b,
          'c': c,
          'd': d,
          'validator': chooseAnswer,
        });
      } else {
        FirebaseFirestore.instance
            .collection('quiz_saham')
            .doc(timeInMillis.toString())
            .set({
          'question': question,
          'uid': timeInMillis.toString(),
          'a': a,
          'b': b,
          'c': c,
          'd': d,
          'validator': chooseAnswer,
        });
      }
    } catch (error) {
      toast(
        'Gagal Membuat Quiz Reksadana',
      );
      return;
    }
  }

  static updateQuiz( String option,
      String uid,
      String question,
      String a,
      String b,
      String c,
      String d,
      validator) {
    try {
      if (option == 'reksadana') {
        FirebaseFirestore.instance
            .collection('quiz_reksadana')
            .doc(uid)
            .update({
          'question': question,
          'a': a,
          'b': b,
          'c': c,
          'd': d,
          'validator': validator,
        });
      } else {
        FirebaseFirestore.instance
            .collection('quiz_saham')
            .doc(uid)
            .update({
          'question': question,
          'a': a,
          'b': b,
          'c': c,
          'd': d,
          'validator': validator,
        });
      }
    } catch (error) {
      toast(
        'Gagal Memperbarui Quiz Reksadana',
      );
      return;
    }
  }
}
