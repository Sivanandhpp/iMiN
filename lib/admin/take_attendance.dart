import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:imin/main.dart';
import 'package:imin/models/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:imin/models/globals.dart' as globals;

class TakeAttendance extends StatefulWidget {
  const TakeAttendance({Key? key}) : super(key: key);

  @override
  _TakeAttendanceState createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {
  final dateToday = DateTime.now();
  final database = dbReference.child("users");
  String userID = 'UID';
  int numberOfStudents = 0;
  // Map<int, String> absentOrPresent = {};
  // Map<int, String> absentOrPresentUID = {};
  List<bool> isPresent = [];
  List<String> isPresentUID = [];

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
                      children: [
                        Text(
                          globals.selSubforAttendance,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Attendance',
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
                  itemBuilder: (context, snapshot, animation, index) {
                    userID = snapshot.key.toString();

                    if (numberOfStudents < index + 1) {
                      numberOfStudents = index;
                      isPresent.add(false);
                      isPresentUID.add(userID);
                    }

                    Future<String> databaseNameValue() async {
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
                                      color: ThemeColor.white,
                                      boxShadow: const [
                                        BoxShadow(
                                            color: ThemeColor.shadow,
                                            blurRadius: 10,
                                            spreadRadius: 0.1,
                                            offset: Offset(0, 10)),
                                      ],
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 2),
                                    child: ListTile(
                                      trailing: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isPresent[index] == true
                                                ? isPresent[index] = false
                                                : isPresent[index] = true;
                                          });
                                        },
                                        child: Container(
                                          width: 70,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              color: isPresent[index] == true
                                                  ? ThemeColor.green
                                                  : ThemeColor.red,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: isPresent[index] == true
                                                ? const Icon(
                                                    LineIcons.check,
                                                    size: 30.0,
                                                    color: Colors.white,
                                                  )
                                                : const Icon(
                                                    LineIcons.times,
                                                    size: 30.0,
                                                    color: Colors.white,
                                                  ),
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
                            margin: const EdgeInsets.only(top: 20),
                            child: const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey,
                                color: ThemeColor.primary,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ThemeColor.primary,
        label: const Text(
          '      UPLOAD      ',
        ),
        onPressed: () {
          attendanceFetch();
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<bool?> attendanceFetch() async {
    int i = 0;
    String userIDAF = 'n';
    // String databaseRefTo =
    //     "class/timetable/${dateToday.year}/${dateToday.month}/${dateToday.day}/${globals.selSubforAttendance}";
    // final databaseattislistening =
        dbReference.child("class/timetable/${dateToday.year}/${dateToday.month}/${dateToday.day}/${globals.selSubforAttendance}/islistening").set(false);
    // databaseattislistening.set(false);
    //To increment classes
    DatabaseReference classRef = dbReference.child(
        "class/numberofclass/${globals.selSubforAttendance.toLowerCase()}");
    DataSnapshot subSnapshot = await classRef.get();
    int numOfClass = int.parse(subSnapshot.value.toString());
    if (numOfClass > 0) {
      classRef.set(numOfClass + 1);
    } else {
      classRef.set(1);
    }

    //To add attendance
    while (i < numberOfStudents + 1) {
      userIDAF = isPresentUID[i];

      if (isPresent[i] == true) {
        DatabaseReference ref = dbReference.child(
            "users/$userIDAF/class/${globals.selSubforAttendance.toLowerCase()}");
        DataSnapshot isAdminDB = await ref.get();
        int numOfAttendance = int.parse(isAdminDB.value.toString());
        ref.set(numOfAttendance + 1);
      }

      i++;
    }

    return false;
  }
}
