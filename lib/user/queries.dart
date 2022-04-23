import 'package:dialogs/dialogs/message_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imin/main.dart';
import 'package:imin/models/colors.dart';
import 'package:imin/models/font_size.dart';
import 'package:imin/models/main_button.dart';
import 'package:line_icons/line_icons.dart';
import 'package:imin/models/globals.dart' as globals;

class AddQueries extends StatefulWidget {
  const AddQueries({Key? key}) : super(key: key);

  @override
  State<AddQueries> createState() => _AddQueriesState();
}

class _AddQueriesState extends State<AddQueries> {
  String dropdownValue = 'Select Query';

  String queryTypeFromDB = "No Query found";
  String querySubjectFromDB = "----";
  String queryFromDB = "You didnt send any query";
  String queryStatusFromDB = "null";

  //Queries
  List<String> queries = [
    'Leave Application',
    'Attendance Query',
    'Internal Mark Query',
    'Class Timetable Query',
    'Other Query'
  ];

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  getDataFromDB() async {
    DataSnapshot queries =
        await dbReference.child("class/queries/${globals.userID}").get();

    querySubjectFromDB = queries.child("Subject").value.toString();
    queryTypeFromDB = queries.child("QueryType").value.toString();
    queryStatusFromDB = queries.child("Status").value.toString();
    queryFromDB = queries.child("Query").value.toString();
    
  }

  final TextEditingController _queryController = TextEditingController();

  final TextEditingController _subjectController = TextEditingController();

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
                          "Queries",
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
                      items: queries
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
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _subjectController,
                  cursorColor: ThemeColor.primary,
                  decoration: InputDecoration(
                    fillColor: ThemeColor.textFieldBgColor,
                    filled: true,
                    labelText: "Subject",
                    hintText: "Subject in short words",
                    hintStyle: GoogleFonts.poppins(
                      color: ThemeColor.textFieldHintColor,
                      fontSize: FontSize.medium,
                      fontWeight: FontWeight.w400,
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _queryController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  cursorColor: ThemeColor.primary,
                  decoration: InputDecoration(
                    fillColor: ThemeColor.textFieldBgColor,
                    labelText: "Query",
                    filled: true,
                    hintText: "Explain your Query",
                    hintStyle: GoogleFonts.poppins(
                      color: ThemeColor.textFieldHintColor,
                      fontSize: FontSize.medium,
                      fontWeight: FontWeight.w400,
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MainButton(
                  text: 'Submit',
                  onTap: () {
                    dbReference.child("class/queries/${globals.userID}").set({
                      "Name": globals.userName,
                      "QueryType": dropdownValue,
                      "Subject": _subjectController.value.text,
                      "Query": _queryController.value.text,
                      "Status": "Pending"
                    });
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MainButton(
                  text: "Submitted Query",
                  backgroundColor: ThemeColor.black,
                  onTap: () {
                    MessageDialog messageDialog = MessageDialog(
                      dialogBackgroundColor: Colors.white,
                      buttonOkColor: ThemeColor.primary,
                      title: queryTypeFromDB,
                      titleColor: Colors.black,
                      message:
                          "Query Subject: $querySubjectFromDB  \n \n   $queryFromDB \n \n Query Status:  $queryStatusFromDB",
                      messageColor: Colors.black,
                      buttonOkText: 'Back',
                      dialogRadius: 30.0,
                      buttonRadius: 15.0,
                    );
                    messageDialog.show(context, barrierColor: Colors.white);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
