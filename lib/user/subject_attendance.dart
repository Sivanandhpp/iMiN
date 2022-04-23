import 'package:flutter/material.dart';
import 'package:imin/models/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:imin/models/globals.dart' as globals;

class SubejctAttendance extends StatelessWidget {
  const SubejctAttendance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "BCA/5/B",
                        style: TextStyle(fontSize: 14, color: ThemeColor.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Attendance',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ThemeColor.black),
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
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      color: ThemeColor.shadow,
                                      blurRadius: 100,
                                      spreadRadius: 1,
                                      offset: Offset(0, 10)),
                                ],
                                color: ThemeColor.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, top: 2),
                              child: ListTile(
                                trailing: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    "${globals.subjectsAttendance[index]}/${globals.subjectsTotalClass[index]}",
                                  
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: ThemeColor.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                title: Text(
                                  "${index + 1}:  ${globals.subjects[index]}",
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: ThemeColor.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
