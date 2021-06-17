import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  Future<void> addData(newsData) async {
    print(newsData);
    FirebaseFirestore.instance.collection("Spor Haberleri")
    .add(newsData).then((value) => print(value)).catchError((e) {
      print(e);
      });
  }
 

 getData() async {
   return await FirebaseFirestore.instance.collection("Spor Haberleri").get();
 }
 }
  
