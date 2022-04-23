import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:imin/main.dart';
import 'package:imin/models/colors.dart';
import 'package:line_icons/line_icons.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final database = dbReference.child("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "BCA/5/B",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Students',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                          child: Icon(LineIcons.arrowLeft),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                FirebaseAnimatedList(
                  physics: const NeverScrollableScrollPhysics(),
                  query: database,
                  shrinkWrap: true,
                  defaultChild: const Center(child: CircularProgressIndicator(),),
                  itemBuilder: (context, snapshot, animation, index) {
                    String userID = 'UID';
                    Future<String> databaseNameValue() async {
                      userID = snapshot.key.toString();
                      // DatabaseReference ref =
                      //     FirebaseDatabase.instance.ref("users/$userID/name");
                      DataSnapshot userName =
                          await dbReference.child("users/$userID/name").get();
                      String userNameDB = userName.value.toString();
                      return userNameDB;
                    }

                    return FutureBuilder(
                      future: databaseNameValue(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            color: ThemeColor.shadow,
                                            blurRadius: 10,
                                            spreadRadius: 0.1,
                                            offset: Offset(0, 10)),
                                      ],
                                      color: ThemeColor.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 2),
                                    child: ListTile(
                                      trailing: InkWell(
                                        onTap: () {
                                          database.child(userID).remove();
                                        },
                                        child: Container(
                                          width: 70,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              color: ThemeColor.secondary,
                                            
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: const Center(
                                            child: Icon(LineIcons.trash,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        "${index + 1}:  ${snapshot.data}",
                                        style: const TextStyle(
                                            fontSize: 17,
                                            color: ThemeColor.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Container(
                            color: Colors.white,
                            // alignment: Alignment.bottomCenter,
                            margin: const EdgeInsets.only(top: 20),
                            child: const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey,
                                color: Colors.blue,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
