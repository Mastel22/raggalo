import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:raggalo/configuration.dart';
import 'package:raggalo/models/reserved_breed.dart';
import 'package:raggalo/models/user.dart';
import 'package:raggalo/models/vet_request.dart';
import 'package:raggalo/services/firebase.dart';

class Report<T> {
  int count = 0;
  List<T> items = [];
  Report(this.count, this.items);
}

class AdminReportPage extends StatefulWidget {
  @override
  _AdminReportPageState createState() => _AdminReportPageState();
}

class _AdminReportPageState extends State<AdminReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 32,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseService.firestore
                  .collection("reserved_breeds")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.docs.isEmpty) {
                  return Center(
                    child: Text("No reports found!"),
                  );
                }
                var items = snapshot.data.docs
                    .map((item) => ReservedBreed.fromJson(item.data()))
                    .toList();

                Report<ReservedBreed> breeds = Report(items.length, items);
                return ExpandableNotifier(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 90,
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                              ),
                              child: Row(
                                children: [
                                  // Image.asset(
                                  //   categories[index].iconPath,
                                  //   scale: 1,
                                  // ),
                                  Expanded(child: Container()),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Breeds requests",
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      Text("Total requests"),
                                      Text(breeds.count.toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ScrollOnExpand(
                            scrollOnExpand: true,
                            scrollOnCollapse: false,
                            child: ExpandablePanel(
                              theme: const ExpandableThemeData(
                                headerAlignment:
                                    ExpandablePanelHeaderAlignment.center,
                                tapBodyToCollapse: true,
                              ),
                              header: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "All requests",
                                    style: Theme.of(context).textTheme.body2,
                                  )),
                              collapsed: Text(
                                "Total: ${breeds.count}",
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              expanded: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  for (ReservedBreed _ in breeds.items)
                                    ListTile(
                                      leading: Image.network(
                                        _.image,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                      title: Text(_.name),
                                      subtitle: Text(_.animal),
                                      trailing: Text(
                                        DateFormat("M/D/y").format(
                                          DateTime.parse(_.createAt),
                                        ),
                                      ),
                                      onTap: () {},
                                    )
                                ],
                              ),
                              builder: (_, collapsed, expanded) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: Expandable(
                                    collapsed: collapsed,
                                    expanded: expanded,
                                    theme: const ExpandableThemeData(
                                        crossFadePoint: 0),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 32,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseService.firestore
                  .collection("users")
                  .where("role", isEqualTo: "Vet")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.docs.isEmpty) {
                  return Center(
                    child: Text("No reports found!"),
                  );
                }
                var items = snapshot.data.docs
                    .map((item) => User.fromJson(item.data()))
                    .toList();

                Report<User> users = Report(items.length, items);
                return ExpandableNotifier(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 90,
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                              ),
                              child: Row(
                                children: [
                                  // Image.asset(
                                  //   categories[index].iconPath,
                                  //   scale: 1,
                                  // ),
                                  Expanded(child: Container()),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Vet requests",
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      Text("Total users"),
                                      Text(users.count.toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ScrollOnExpand(
                            scrollOnExpand: true,
                            scrollOnCollapse: false,
                            child: ExpandablePanel(
                              theme: const ExpandableThemeData(
                                headerAlignment:
                                    ExpandablePanelHeaderAlignment.center,
                                tapBodyToCollapse: true,
                              ),
                              header: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "All requests",
                                    style: Theme.of(context).textTheme.body2,
                                  )),
                              collapsed: Text(
                                "Total: ${users.count}",
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              expanded: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  for (User _ in users.items)
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          _.image ??
                                              "https://res.cloudinary.com/dlwzb2uh3/image/upload/v1611644493/PngItem_307416_ciwoqc.png",
                                        ),
                                      ),
                                      title: Text(_.names),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(_.role),
                                          Text(_.requests.toString()),
                                        ],
                                      ),
                                      onTap: () {},
                                    )
                                ],
                              ),
                              builder: (_, collapsed, expanded) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: Expandable(
                                    collapsed: collapsed,
                                    expanded: expanded,
                                    theme: const ExpandableThemeData(
                                      crossFadePoint: 0,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// class ReportCard extends StatelessWidget {
//   final Report report;
//   final String animal;
//   final int index;

//   const ReportCard({Key key, this.report, this.animal, this.index})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return ExpandableNotifier(
//         child: Padding(
//       padding: const EdgeInsets.all(10),
//       child: Card(
//         clipBehavior: Clip.antiAlias,
//         child: Column(
//           children: <Widget>[
//             SizedBox(
//               height: 90,
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.rectangle,
//                 ),
//                 child: Row(
//                   children: [
//                     Image.asset(
//                       categories[index].iconPath,
//                       scale: 1,
//                     ),
//                     Expanded(child: Container()),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "$animal breeds",
//                           style: TextStyle(
//                             fontSize: 22,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                         ),
//                         Text("Total requests"),
//                         Text(report.count.toString()),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             ScrollOnExpand(
//               scrollOnExpand: true,
//               scrollOnCollapse: false,
//               child: ExpandablePanel(
//                 theme: const ExpandableThemeData(
//                   headerAlignment: ExpandablePanelHeaderAlignment.center,
//                   tapBodyToCollapse: true,
//                 ),
//                 header: Padding(
//                     padding: EdgeInsets.all(10),
//                     child: Text(
//                       "All requests",
//                       style: Theme.of(context).textTheme.body2,
//                     )),
//                 collapsed: Text(
//                   "Total: ${report.count}",
//                   softWrap: true,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 expanded: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     for (ReservedBreed _ in report.items)
//                       ListTile(
//                         leading: Image.network(
//                           _.image,
//                           width: 50,
//                           height: 50,
//                           fit: BoxFit.cover,
//                         ),
//                         title: Text(_.name),
//                         subtitle: Text(_.animal),
//                         trailing: Text(
//                           DateFormat("M/D/y").format(
//                             DateTime.parse(_.createAt),
//                           ),
//                         ),
//                         onTap: () {},
//                       )
//                   ],
//                 ),
//                 builder: (_, collapsed, expanded) {
//                   return Padding(
//                     padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                     child: Expandable(
//                       collapsed: collapsed,
//                       expanded: expanded,
//                       theme: const ExpandableThemeData(crossFadePoint: 0),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
// }
