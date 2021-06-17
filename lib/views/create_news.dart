
import 'dart:io';

import 'package:haber_portal/services/crud.dart';
// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:random_string/random_string.dart';


class CreateNews extends StatefulWidget {

  @override
  _CreateNewsState createState() => _CreateNewsState();
}

class _CreateNewsState extends State<CreateNews> {

   File selectedImage;

  final picker = ImagePicker();

  bool isLoading = false;

  CrudMethods crudMethods = new CrudMethods();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if(pickedFile != null)
      {
        selectedImage = File(pickedFile.path);
      }else {
        print("No Image Selected");
      }
    });
  }
  Future<void> uploadNews() async{
    // ignore: unnecessary_null_comparison
    if (selectedImage != null){
      setState((){
        isLoading = true;
      });
      Reference firebaseStorageRef = FirebaseStorage.instance
      .ref().child("News Images").child("${randomAlphaNumeric(9)}.jpg");

      final UploadTask task = firebaseStorageRef.putFile(selectedImage);

      var imageUrl;
      await task.whenComplete(() async {
        try {
          imageUrl = await firebaseStorageRef.getDownloadURL();
        }
        catch (onError) {
          print("Error");
        }
        print(imageUrl);
      });

      Map<String, dynamic> newsData = {
        "imgUrl": imageUrl,
        "author": authorTextEditingController.text,
        "title": titleTextEditingController.text,
        "desc": descTextEditingController.text,
      };
      crudMethods.addData(newsData).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      });
    }
  }

  TextEditingController titleTextEditingController = 
      new TextEditingController();
    TextEditingController descTextEditingController = 
      new TextEditingController();
    TextEditingController authorTextEditingController = 
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create News"),
      actions: [
        GestureDetector(onTap: () {
          uploadNews();
        },
        child: Padding(padding: EdgeInsets.symmetric(horizontal:16),
        child: Icon(Icons.file_upload)),
        )
      ],
      ),
      body:  isLoading ? Container(child: Center(child: CircularProgressIndicator(),)) :
      SingleChildScrollView(child: Container(margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        GestureDetector(onTap: () {
          getImage();
        },
        // ignore: unnecessary_null_comparison
        child: selectedImage != null ? Container(
          height: 150,
          margin:  EdgeInsets.symmetric(vertical: 24),
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: 
             BorderRadius.all(Radius.circular(8)),
             child: Image.file(
               selectedImage,
               fit: BoxFit.cover,
             ),
          ),
        )
        : Container(height: 150,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius:
           BorderRadius.all(Radius.circular(8))),
           margin:  EdgeInsets.symmetric(vertical: 24),
           width: MediaQuery.of(context).size.width,
           child: Icon(Icons.camera_alt,
           color: Colors.white,
           ),
        ),
        ),
        TextField(controller: titleTextEditingController,
        decoration: InputDecoration(hintText: "Haber Başlığı giriniz"),
        ),
        TextField(
          controller: descTextEditingController,
          decoration: InputDecoration(hintText: "Haber Tanımı"),
        ),
        TextField(
          controller:  authorTextEditingController,
          decoration:  InputDecoration(hintText: "Yazar ismi"),
        ),
      ],
      )),
      ),
    );
  }
}

      