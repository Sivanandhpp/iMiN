import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:imin/main.dart';
import 'package:imin/models/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:expandable/expandable.dart';

class ViewQueries extends StatefulWidget {
  const ViewQueries({Key? key}) : super(key: key);

  @override
  State<ViewQueries> createState() => _ViewQueriesState();
}

class _ViewQueriesState extends State<ViewQueries> {
  String queryTypeFromDB = "No Query found";
  String querySubjectFromDB = "----";
  String queryFromDB = "You didnt send any query";
  String queryStatusFromDB = "null";

  DatabaseReference queries = dbReference.child("class/queries");

  // getDataFromDB() async {
  //   DataSnapshot queries =
  //       await dbReference.child("class/queries/${globals.userID}").get();
  //   queryTypeFromDB = queries.child("QueryType").value.toString();
  //   querySubjectFromDB = queries.child("Subject").value.toString();
  //   queryFromDB = queries.child("Query").value.toString();
  //   queryStatusFromDB = queries.child("Status").value.toString();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                          "View Queries",
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
                  query: queries,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  defaultChild: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  itemBuilder: (context, snapshot, animation, index) {
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          // height: 125,
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
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                ExpandablePanel(
                                  header: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        snapshot
                                            .child("QueryType")
                                            .value
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 17,
                                            color: ThemeColor.primary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Container(
                                        child: snapshot.child("Status").value ==
                                                "Approved / Resolved"
                                            ? const Icon(LineIcons.check)
                                            : const Icon(LineIcons.syncIcon),

                                        //   if (snapshot.value="Approved / Resolved") {
                                        //   Icon(LineIcons.syncIcon)
                                        // } else {
                                        //   Icon(LineIcons.check)
                                        // }
                                      )
                                    ],
                                  ),
                                  collapsed: Text(
                                    // ignore: unnecessary_string_interpolations
                                    "${snapshot.child("Subject").value.toString()}",
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: ThemeColor.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  expanded: Column(
                                    children: [
                                      Text(
                                        "Student Name: ${snapshot.child("Name").value.toString()}",
                                        softWrap: true,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: ThemeColor.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        snapshot
                                            .child("Query")
                                            .value
                                            .toString(),
                                        softWrap: true,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: ThemeColor.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            queries
                                                .child("${snapshot.key}/Status")
                                                .set("Approved / Resolved");
                                          },
                                          child:
                                              const Text("Approve / Resolved")),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
