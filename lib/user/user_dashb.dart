import 'package:flutter/material.dart';
import 'package:imin/main.dart';
import 'package:imin/services/auth_service.dart';
import 'package:imin/user/display_classes.dart';
import 'package:imin/user/queries.dart';
import 'package:imin/user/subject_attendance.dart';
import 'package:imin/user/view_ia_marks.dart';
import 'package:provider/provider.dart';
import 'package:imin/models/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:imin/models/globals.dart' as globals;

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  Future<String> getTotalAttendance() async {
    String attendancePercent = '0';
    int i = 0;
    int totalOfAttendance = 0;
    int totalOfClass = 0;

    while (i < 6) {
      await dbReference
          .child(
              'users/${globals.userID}/class/${globals.subjects[i].toString().toLowerCase()}')
          .once()
          .then(
        (valueattendance) {
          var data = valueattendance.snapshot.value;
          globals.subjectsAttendance.add(int.parse(data.toString()));
          totalOfAttendance = totalOfAttendance + int.parse(data.toString());
        },
      );
      await dbReference
          .child(
              'class/numberofclass/${globals.subjects[i].toString().toLowerCase()}')
          .once()
          .then(
        (valuetotal) {
          var datatotal = valuetotal.snapshot.value;
          globals.subjectsTotalClass.add(int.parse(datatotal.toString()));
          totalOfClass = totalOfClass + int.parse(datatotal.toString());
        },
      );
      i++;
    }
    var temp = 0.0;
    if (totalOfClass > 0) {
      temp = (totalOfAttendance * 100) / totalOfClass;
    }
    globals.attendancePercent = temp.toStringAsFixed(0);

    return attendancePercent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    final authService = Provider.of<AuthService>(context);
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
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
                      const Text(
                        "Welcome Back",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        globals.userName,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      await authService.signOut();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                        child: Icon(LineIcons.alternateSignOut),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                height: 145,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: ThemeColor.shadow,
                        blurRadius: 100,
                        spreadRadius: 1,
                        offset: Offset(0, 10)),
                  ],
                  color: ThemeColor.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: FutureBuilder(
                  future: getTotalAttendance(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Flexible(
                              child: SizedBox(
                                width: (size.width),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Attendance",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: ThemeColor.white),
                                    ),
                                    const Text(
                                      "5th Sem BCA",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: ThemeColor.white),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SubejctAttendance()),
                                        );
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color: ThemeColor.secondary,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: const Center(
                                          child: Text(
                                            "Detailed",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: ThemeColor.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ThemeColor.secondary),
                              child: Center(
                                child: Text(
                                  "${globals.attendancePercent}%",
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: ThemeColor.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: ThemeColor.white,
                      ));
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
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
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Today's Classes",
                        style: TextStyle(
                            fontSize: 17,
                            color: ThemeColor.black,
                            fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DisplayClassS()),
                          );
                        },
                        child: Container(
                          width: 70,
                          height: 35,
                          decoration: BoxDecoration(
                              color: ThemeColor.primary,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Center(
                            child: Icon(LineIcons.arrowRight,
                                color: ThemeColor.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
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
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "View IA Marks",
                        style: TextStyle(
                            fontSize: 17,
                            color: ThemeColor.black,
                            fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ViewIaMarks()),
                          );
                        },
                        child: Container(
                          width: 70,
                          height: 35,
                          decoration: BoxDecoration(
                              color: ThemeColor.primary,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Center(
                            child: Icon(LineIcons.arrowRight,
                                color: ThemeColor.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
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
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Queries",
                        style: TextStyle(
                            fontSize: 17,
                            color: ThemeColor.black,
                            fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddQueries()),
                          );
                        },
                        child: Container(
                          width: 70,
                          height: 35,
                          decoration: BoxDecoration(
                              color: ThemeColor.primary,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Center(
                            child: Icon(LineIcons.arrowRight,
                                color: ThemeColor.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
