import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imin/main.dart';
import 'package:imin/models/colors.dart';
import 'package:imin/models/font_size.dart';
import 'package:imin/models/globals.dart' as globals;
import 'package:line_icons/line_icons.dart';

class UploadIA extends StatefulWidget {
  const UploadIA({Key? key}) : super(key: key);

  @override
  _UploadIAState createState() => _UploadIAState();
}

class _UploadIAState extends State<UploadIA> {
  List<String> iaMark = [];
  List<String> userUID = [];
  String dropdownValue = 'Select Subject';
  final database = dbReference.child("users");
  int numberOfStudents = 0;
  @override
  Widget build(BuildContext context) {
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
                          "BCA/5/B",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Upload IA Marks",
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
                  height: 20,
                ),
                DecoratedBox(
                  decoration: const ShapeDecoration(
                    color: ThemeColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                        isDense: true,
                        borderRadius: BorderRadius.circular(30),
                        hint: Text(
                          dropdownValue,
                          style: const TextStyle(
                              color: ThemeColor.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        items: globals.subjects
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Center(
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                        color: ThemeColor.primary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            dropdownValue = value.toString();
                          });
                        }),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FirebaseAnimatedList(
                  physics: const NeverScrollableScrollPhysics(),
                  query: database,
                  shrinkWrap: true,
                  defaultChild: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  itemBuilder: (context, snapshot, animation, index) {
                    String userID = 'UID';
                    userID = snapshot.key.toString();

                    if (numberOfStudents < index + 1) {
                      numberOfStudents = index;
                      userUID.add(userID);
                      iaMark.add("0");
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
                                // ignore: sized_box_for_whitespace
                                trailing: Container(
                                  width: 50,
                                  height: 50,
                                  child: TextField(
                                    onChanged: (value) {
                                      iaMark[index] = value;
                                    },
                                    cursorColor: ThemeColor.primary,
                                    decoration: InputDecoration(
                                      fillColor: ThemeColor.textFieldBgColor,
                                      filled: true,
                                      hintText: "IA",
                                      hintStyle: GoogleFonts.poppins(
                                        color: ThemeColor.textFieldHintColor,
                                        fontSize: FontSize.medium,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18)),
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(),
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: ThemeColor.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                title: Text(
                                  "${index + 1}:  ${snapshot.child("name").value}",
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
        backgroundColor: ThemeColor.primary,
        label: const Text(
          '      UPLOAD      ',
        ),
        onPressed: () {
          iaFetch();
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future iaFetch() async {
    int i = 0;
    while (i < numberOfStudents + 1) {
      dbReference.child("users/${userUID[i]}/ia-marks/$dropdownValue").set(iaMark[i]);
      i++;
    }
  }
}
