import 'package:dialogs/dialogs/message_dialog.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:imin/main.dart';
import 'package:imin/models/colors.dart';
import 'package:imin/user/give_attendance.dart';
import 'package:line_icons/line_icons.dart';
import 'package:imin/models/globals.dart' as globals;

class DisplayClassS extends StatefulWidget {
  const DisplayClassS({Key? key}) : super(key: key);

  @override
  _DisplayClassSState createState() => _DisplayClassSState();
}

class _DisplayClassSState extends State<DisplayClassS> {
  getDate() {
    final dateToday = DateTime.now();
    String dateForDB =
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
                          "Today's",
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
                   
                    String classMode = 'Online';
                    String classModeDB =
                        (snapshot.child("mode").value).toString();
                    if (classModeDB == 'true') {
                      classMode = 'Offline';
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
                                        globals.timeOfClass = snapshot
                                            .child("time")
                                            .value
                                            .toString();
                                        globals.classMode = classMode;
                                        globals.streamStarted = false;
                                        var islistening =
                                            snapshot.child("islistening").value;
                                            var isnottaken =
                                            snapshot.child("isnottaken").value;
                                        if (islistening == true&&isnottaken==true) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const GiveAttendance()),
                                          );
                                        } else {
                                          MessageDialog messageDialog =
                                              MessageDialog(
                                            dialogBackgroundColor: Colors.white,
                                            buttonOkColor: ThemeColor.primary,
                                            title: 'Can\'t put attendance!',
                                            titleColor: Colors.black,
                                            message:
                                                'You dont have permissing to put attendance or its already taken. \n Try contacting your teacher.',
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
