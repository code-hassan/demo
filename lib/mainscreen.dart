
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
 
  String pickedFile = "";
   XFile? _pickedImage;

  // Future pickImage() async {
  //   final picker = ImagePicker();
  //   final returnImage = await picker.pickImage(source: ImageSource.gallery);
  //   if(returnImage != null){
  //     pickedFile = returnImage.path.toString();
  //   }
  // }
 
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
           _pickedImage != null
            ? Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
          
                shape: BoxShape.circle,
                image: DecorationImage(
                  
                  image: FileImage(File(_pickedImage!.path)), fit: BoxFit.cover)
                  ),
                  ) : Container(),
            // CircleAvatar(
            //   radius:  50,
            //   backgroundImage: _pickedImage != null ? FileImage(File(_pickedImage!.path)) : null,
            //   foregroundImage:  _pickedImage != null ? FileImage(File(_pickedImage!.path)) : null,
            // ),
            SizedBox(height: 10,),
            CustomTextField(
                validationType: 1,
                controller: nameController,
                hintText: "Enter your name",
              ),
            SizedBox(height: 10,),
              CustomTextField(
                validationType: 2,
                controller: numberController,
                hintText: "Enter your number",
              ),
            SizedBox(height: 10,),
              CustomTextField(
                validationType: 3,
                controller: emailController,
                hintText: "Enter your email",
              ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                if(nameController.text.isEmpty && emailController.text.isEmpty && numberController.text.isEmpty){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SecondScreen()));
                }else{
                  addData();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SecondScreen()));
                  nameController.clear();
                  emailController.clear();
                  numberController.clear();
                }

                
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
              // pickImage();
               _pickImageFromGallery(context);
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

   Future<void> _pickImageFromGallery(BuildContext context) async {
    print("vvvvvvvvvvvvvvvvvvvvvvvvvvvv");
     final picker = ImagePicker();
     final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

     if (pickedFile != null) {
       setState(() {
         // Update the state with the selected image
         _pickedImage = pickedFile;
       });

     } else {
       // Handle the case when the user cancels image picking.
       print("Image picking was canceled.");
     }



}
}