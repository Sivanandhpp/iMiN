import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:imin/main.dart';
import 'package:imin/models/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:imin/models/globals.dart' as globals;

class TakeAdvancedAttendance extends StatefulWidget {
  const TakeAdvancedAttendance({Key? key}) : super(key: key);

  @override
  _TakeAdvancedAttendanceState createState() => _TakeAdvancedAttendanceState();
}

class _TakeAdvancedAttendanceState extends State<TakeAdvancedAttendance> {
  String databaseRefToPresentStu = "null";
  int numberOfStudents = 0;
  List presentStudents = [];

  final dateToday = DateTime.now();
  databaseRefToPresentStudents() {
    databaseRefToPresentStu =
        "class/timetable/${dateToday.year}/${dateToday.month}/${dateToday.day}/${globals.selSubforAttendance}/presentstudents";
    final database = dbReference.child(databaseRefToPresentStu);

    return database;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                        const Text(
                          "Attendance",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          globals.selSubforAttendance,
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
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
                  height: 30,
                ),
                Row(
                  children: [
                    const Text(
                      "Getting Students..",
                      style: TextStyle(
                          color: ThemeColor.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    // ignore: sized_box_for_whitespace
                    Container(
                      height: 15,
                      width: 15,
                      child: const CircularProgressIndicator(
                        color: ThemeColor.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                FirebaseAnimatedList(
                  physics: const NeverScrollableScrollPhysics(),
                  query: databaseRefToPresentStudents(),
                  shrinkWrap: true,
                  defaultChild: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  itemBuilder: (context, snapshot, animation, index) {
                    if (numberOfStudents < index + 1) {
                      numberOfStudents = index;
                    }

                    if (presentStudents.contains(snapshot.key)) {
                      // ignore: avoid_print
                      print("Already Added");
                    } else {
                      presentStudents.add(snapshot.key);
                    }

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
                              padding: const EdgeInsets.only(left: 10, top: 2),
                              child: ListTile(
                                trailing: InkWell(
                                  onTap: () {
                                    numberOfStudents = numberOfStudents - 1;
                                    databaseRefToPresentStudents()
                                        .child(snapshot.key)
                                        .remove();
                                  },
                                  child: Container(
                                    width: 70,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        color: ThemeColor.secondary,
                                        // gradient: const LinearGradient(
                                        //     colors: [secondary, primary]),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Center(
                                      child: Icon(LineIcons.trash,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  "${index + 1}:  ${snapshot.value}",
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
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          attendanceFetch();
          String databaseRefTo =
              "class/timetable/${dateToday.year}/${dateToday.month}/${dateToday.day}/${globals.selSubforAttendance}";
          final databaseattistaken =
              dbReference.child("$databaseRefTo/isnottaken");
          databaseattistaken.set(false);
          final databaseattislistening =
              dbReference.child("$databaseRefTo/islistening");
          databaseattislistening.set(false);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        label: const Text('      UPLOAD      '),
        backgroundColor: ThemeColor.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<bool?> attendanceFetch() async {
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
    int i = 0;
    String userUIDfromlist;
    while (i < numberOfStudents + 1) {
      userUIDfromlist = presentStudents[i];

      DatabaseReference ref = dbReference.child(
          "users/$userUIDfromlist/class/${globals.selSubforAttendance.toLowerCase()}");
      DataSnapshot isAdminDB = await ref.get();
      int numOfAttendance = int.parse(isAdminDB.value.toString());
      ref.set(numOfAttendance + 1);

      i++;
    }

    return false;
  }
}
