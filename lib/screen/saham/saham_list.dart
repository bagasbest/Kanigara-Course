import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanigara_course/constant/color_constant.dart' as Constant;
import 'package:flutter/material.dart';
import 'package:kanigara_course/screen/saham/saham_detail.dart';

class ListOfCourseSaham extends StatelessWidget {
  final List<DocumentSnapshot> document;

  ListOfCourseSaham({required this.document});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String uid = document[i]['uid'].toString();
        String title = document[i]['title'].toString();
        String course = document[i]['description'].toString();
        String dateAdded = document[i]['dateAdded'].toString();
        String dateUpdated = document[i]['dateUpdated'].toString();
        String image = document[i]['image'].toString();

        return GestureDetector(
          onTap: (){
            Route route = MaterialPageRoute(
                builder: (context) => SahamDetail(
                  uid: uid,
                  title: title,
                  course: course,
                  addedDate: dateAdded,
                  updateDate: dateUpdated,
                  image: image,
                ));
            Navigator.push(context, route);
          },
          child: Container(
            height: 120,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Constant.colorSecondary,
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  child: Image.network(
                    (image != '')
                        ? image
                        : 'https://images.unsplash.com/photo-1579621970795-87facc2f976d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80',
                    height: 120,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 116),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          course,
                          style: TextStyle(color: Colors.white,),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
