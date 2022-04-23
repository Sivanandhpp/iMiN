import 'package:dialogs/dialogs/message_dialog.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:imin/admin/location_based_att.dart';
import 'package:imin/admin/take_attendance.dart';
import 'package:imin/main.dart';
import 'package:imin/models/colors.dart';
import 'package:imin/models/globals.dart' as globals;
import 'package:line_icons/line_icons.dart';

class ViewClasses extends StatefulWidget {
  const ViewClasses({Key? key}) : super(key: key);

  @override
  State<ViewClasses> createState() => _ViewClassesState();
}

class _ViewClassesState extends State<ViewClasses> {
  List classExpand = [];
  int numberOfClass = -1;
  String dateForDB = "null";

  getDate() {
    final dateToday = DateTime.now();
    dateForDB =
        "class/timetable/${dateToday.year}/${dateToday.month}/${dateToday.day}/";
    final database = dbReference.child(dateForDB);

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
                      children: const [
                        Text(
                          "BCA/5/B",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Classes',
                          style: TextStyle(
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
                FirebaseAnimatedList(
                  physics: const NeverScrollableScrollPhysics(),
                  query: getDate(),
                  shrinkWrap: true,
                  defaultChild:
                      const Center(child: CircularProgressIndicator()),
                  itemBuilder: (context, snapshot, animation, index) {
                    // print(snapshot.child("subject").value);
                    if (index > numberOfClass) {
                      classExpand.add(false);
                      numberOfClass += 1;
                    }

                    String classMode = 'Online';
                    String classModeDB =
                        (snapshot.child("mode").value).toString();
                    if (classModeDB == 'true') {
                      classMode = 'Offline';
                    }

                    if (classExpand.isNotEmpty && classExpand[index] == true) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: double.infinity,
                            height: 125,
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: ThemeColor.shadow,
                                    blurRadius: 100,
                                    spreadRadius: 10,
                                    offset: Offset(0, 60)),
                              ],
                              borderRadius: BorderRadius.circular(15),
                              color: ThemeColor.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 24,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TakeAttendance()),
                                    );
                                  },
                                  child: Container(
                                    width: 70,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        color: ThemeColor.green,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Center(
                                      child: Icon(LineIcons.paperPlane,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),

                                //2nd button
                                InkWell(
                                  onTap: () {
                                    dbReference
                                        .child(
                                            "$dateForDB/${snapshot.key}/islistening")
                                        .set(true);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TakeAdvancedAttendance()),
                                    );
                                  },
                                  child: Container(
                                    width: 70,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        color: ThemeColor.primary,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Center(
                                      child: Icon(LineIcons.fighterJet,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        classExpand[index] = false;
                                      });
                                    },
                                    icon: const Icon(LineIcons.times),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }
                    return Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: double.infinity,
                          height: 125,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: ThemeColor.shadow,
                                  blurRadius: 100,
                                  spreadRadius: 10,
                                  offset: Offset(0, 60)),
                            ],
                            borderRadius: BorderRadius.circular(15),
                            color: ThemeColor.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  color: ThemeColor.primary,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 25,
                                        ),
                                        const Icon(
                                          LineIcons.clock,
                                          color: ThemeColor.white,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          snapshot
                                              .child("time")
                                              .value
                                              .toString(),
                                          style: const TextStyle(
                                              color: ThemeColor.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: const [
                                        Text(
                                          "Lecture",
                                          style: TextStyle(
                                              color: ThemeColor.lightGrey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, right: 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Subject: ${snapshot.child("subject").value.toString()}",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Class mode: $classMode",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        globals.selSubforAttendance = snapshot
                                            .child("subject")
                                            .value
                                            .toString();
                                        var isnottaken =
                                            snapshot.child("isnottaken").value;
                                        if (isnottaken == true) {
                                          setState(() {
                                            classExpand[index] = true;
                                          });
                                        } else {
                                          MessageDialog messageDialog =
                                              MessageDialog(
                                            dialogBackgroundColor: Colors.white,
                                            buttonOkColor: ThemeColor.primary,
                                            title: 'Can\'t take attendance!',
                                            titleColor: Colors.black,
                                            message:
                                                'Attendance already taken\n Do you think this is a mistake contact: admin@imin.com',
                                            messageColor: Colors.black,
                                            buttonOkText: 'Ok',
                                            dialogRadius: 30.0,
                                            buttonRadius: 15.0,
                                          );
                                          messageDialog.show(context,
                                              barrierColor: Colors.white);
                                        }
                                      },
                                      child: Container(
                                        width: 70,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color: ThemeColor.primary,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: const Center(
                                          child: Icon(LineIcons.arrowRight,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
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
    );
  }
}
