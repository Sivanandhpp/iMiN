// ignore_for_file: unnecessary_string_interpolations, avoid_print

import 'package:dialogs/dialogs/message_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:imin/main.dart';
import 'package:imin/models/colors.dart';
import 'package:imin/models/main_button.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
// import 'package:location/location.dart' as loc;
import 'package:imin/models/globals.dart' as globals;

class GiveAttendance extends StatefulWidget {
  const GiveAttendance({Key? key}) : super(key: key);

  @override
  _GiveAttendanceState createState() => _GiveAttendanceState();
}

class _GiveAttendanceState extends State<GiveAttendance> {
  //FOR DATE
  final dateToday = DateTime.now();

  getDate() {
    String formattedDate = DateFormat.yMMMMd('en_US').format(dateToday);
    return formattedDate;
  }

  String pickedTime = "HH:MM";
  String amORpm = 'AM';
  String hh = 'HH';
  String mm = 'MM';

  // var _time;
  TimeOfDay _time = const TimeOfDay(hour: 9, minute: 0);
  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;

      hh = _time.hour.toString();
      int inthh = _time.hour.toInt();
      //To check AM or PM
      if (_time.hour.toInt() > 11) {
        amORpm = 'PM';
      }
      //To convert to 12 hr format
      if (_time.hour.toInt() > 12) {
        inthh = (_time.hour.toInt() - 12);
        hh = inthh.toString();
      }
      //To add 0 at the beginning if time is less than 9
      if (inthh <= 9) {
        hh = "0$inthh";
      }

      mm = _time.minute.toString();
      pickedTime = "$hh:00 - $amORpm";
    });
  }
  //DAT : UNTILL HERE

  double distanceBetweenInMeter = 0.0;
  var accordingToDistance = ThemeColor.black;
  bool allowAtt = false;

  StreamSubscription? _getPositionSubscription;

  LocationSettings locationOptions =
      const LocationSettings(accuracy: LocationAccuracy.high);

  _getLocation() {
    _getPositionSubscription =
        Geolocator.getPositionStream(locationSettings: locationOptions).listen(
      (Position position) {
        double distanceInMeters = Geolocator.distanceBetween(position.latitude,
            position.longitude, globals.latitude, globals.longitude);
        setState(() {
          distanceBetweenInMeter = distanceInMeters;
        });
      },
    );
  }

  @override
  void initState() {
    // _checklocationServices();
    _getLocation();
    super.initState();
  }

  @override
  void dispose() {
    _getPositionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    if (distanceBetweenInMeter < 25) {
      allowAtt = true;
      accordingToDistance = ThemeColor.primary;
    } else if (distanceBetweenInMeter < 50) {
      allowAtt = true;
      accordingToDistance = ThemeColor.greenForLoc;
    } else if (distanceBetweenInMeter < 100) {
      allowAtt = false;
      accordingToDistance = ThemeColor.orangeForLoc;
    } else if (distanceBetweenInMeter > 100) {
      allowAtt = false;
      accordingToDistance = ThemeColor.redForLoc;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
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
                          "Advanced",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Attendance',
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
                Row(
                  children: [
                    const Text(
                      "Fetching your location..",
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
                Container(
                  height: 60,
                  width: double.infinity,
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
                  child: Center(
                    child: Text(
                      "You are ${distanceBetweenInMeter.toStringAsFixed(2)} meter away from campus",
                      style: TextStyle(
                          color: accordingToDistance,
                          fontSize: 15,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 250,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        globals.selSubforAttendance,
                        style: const TextStyle(
                            color: ThemeColor.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(globals.classMode),
                      Text(globals.timeOfClass),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: MainButton(
                            backgroundColor: accordingToDistance,
                            text: "SUBMIT",
                            onTap: () {
                              if (allowAtt) {
                                String dateForDB =
                                    "${dateToday.year}/${dateToday.month}/${dateToday.day}/${globals.selSubforAttendance}";

                                final classReferance = dbReference.child(
                                    'class/timetable/$dateForDB/presentstudents');
                                classReferance.update({
                                  "${globals.userID}": "${globals.userName}"
                                }).then((value) => Navigator.pop(context));
                              } else {
                                MessageDialog messageDialog = MessageDialog(
                                  dialogBackgroundColor: Colors.white,
                                  buttonOkColor: ThemeColor.primary,
                                  title: 'Can\'t give you attendance',
                                  titleColor: Colors.black,
                                  message:
                                      'You are ${distanceBetweenInMeter.toStringAsFixed(2)} away from campus! \n Do you think this a mistake contact: admin@imin.com',
                                  messageColor: Colors.black,
                                  buttonOkText: 'Ok',
                                  dialogRadius: 30.0,
                                  buttonRadius: 15.0,
                                );
                                messageDialog.show(context,
                                    barrierColor: Colors.white);
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future _checklocationServices() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     loc.Location.instance.requestService;
  //     print('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       print('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     print(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  // }
}
