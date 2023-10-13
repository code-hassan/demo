
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/customtextfieldwidgets.dart';
import 'package:demo/secondScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FirestoreDemo extends StatefulWidget {
  @override
  _FirestoreDemoState createState() => _FirestoreDemoState();
}

class _FirestoreDemoState extends State<FirestoreDemo> {
   TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
 
  File? _pickedFile;

  Future pickImage() async {
    final picker = ImagePicker();
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    
      setState(() {
        _pickedFile = File(returnImage!.path);
      });

      print("image path${_pickedFile!.path}");
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              
           
      //    _pickedFile != null ? Container(height: 50,width: 50,child: Image.file(_pickedFile!),) : const Text("Please select an image"),
        


            CustomTextField(
                validationType: 1,
                controller: nameController,
                hintText: "Enter your name",
              ),
              CustomTextField(
                validationType: 2,
                controller: numberController,
                hintText: "Enter your number",
              ),
              CustomTextField(
                validationType: 3,
                controller: emailController,
                hintText: "Enter your email",
              ),
            ElevatedButton(
              onPressed: () {
                addData();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SecondScreen()));
                
              },
              child: Text('Add Data'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     // getData();
            //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SecondScreen()));
            //   },
            //   child: Text('Get Data'),
            // ),

            SizedBox(height: 10,),
           InkWell(
             onTap: (){
               pickImage();
             },
             child: Icon(Icons.image,color: Colors.lightBlue,size: 30,),
           ),


          ],
        ),
      ),
    );
  }

  Future<void> addData() async {
    await firestore.collection("users").add({
      'name': nameController.text,
      'email': emailController.text,
      "number": numberController.text,
    });

    print('Data added to Firestore.');

  }

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await firestore.collection("users").get();
    querySnapshot.docs.forEach((doc) {
      var fetchData = doc.data();
      print(fetchData);
    });
  }





}
