

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {


final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<List<UserData>> getUserData() async {
  //   List<UserData> userDataList = [];
  //   try {

  //     QuerySnapshot querySnapshot = await _firestore.collection('users').get();
  //     querySnapshot.docs.forEach((doc) {
  //       var fetchData = doc.data();
  //      if (fetchData != null) {
  //         userDataList.add(UserData.fromJson(fetchData as Map<String, dynamic>));
  //       }
  //     });

  //     return userDataList;


  //   } catch (e) {
  //     print('Error fetching data: $e');
  //     throw e;
  //   }
  // }

Stream<List<UserData>> streamUserData() {
    return _firestore.collection('users').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        var fetchData = doc.data();
        return UserData.fromJson(fetchData);
      }).toList();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    streamUserData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text("Get Data in Firebase",style: TextStyle(color: Colors.white),),
        ),
      body: 
    //   FutureBuilder<List<UserData>>(
    //   future: getUserData(),
    //  builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return CircularProgressIndicator();
    //     } else if (snapshot.hasError) {
    //       return Text('Error: ${snapshot.error}');
    //     } else if (snapshot.hasData) {
    //       final userDataList = snapshot.data;
    //       return ListView.builder(
    //         itemCount: userDataList?.length,
    //         itemBuilder: (context, index) {
    //           final data = userDataList?[index];
    //           return ListTile(
    //             title: Text(data!.name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
    //             subtitle: Column(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [       
    //               Text(data.email,style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal),),
    //               Text(data.number,style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal),),
                  
    //             ],) 
                
              
    //           );
    //         },
    //       );
    //     }else {
    //       return Text('No data yet');
    //     }
    //   },
    //  ),
   
   StreamBuilder<List<UserData>>(
      stream: streamUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}',style: TextStyle(color: Colors.red),);
        } else if (snapshot.hasData) {
          final userDataList = snapshot.data ?? [];
          return UserDataListWidget(userDataList: userDataList);
        } else {
          return Text('No data yet');
        }
      },
    ),
    );
  }
}

class UserData {
  final String name;
  final String number;
  final String email;

  UserData({required this.name, required this.number, required this.email});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      number: json['number'],
      email: json['email'],
    );
  }
}


class UserDataListWidget extends StatelessWidget {
  final List<UserData> userDataList;

  const UserDataListWidget({required this.userDataList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userDataList.length,
      itemBuilder: (context, index) {
        final data = userDataList[index];
        return ListTile(
          title: Text(data.name),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(data.email),
            Text(data.number),
          ],)
          
        );
      },
    );
  }
}