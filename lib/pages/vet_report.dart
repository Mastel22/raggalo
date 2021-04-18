import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:raggalo/configuration.dart';
import 'package:raggalo/models/reserved_breed.dart';
import 'package:raggalo/providers/profile.dart';
import 'package:raggalo/services/firebase.dart';

class Report<T> {
  int count = 0;
  List<T> items = [];
  Report(this.count, this.items);
}

class VetReportPage extends StatefulWidget {
  @override
  _VetReportPageState createState() => _VetReportPageState();
}

class _VetReportPageState extends State<VetReportPage> {
  @override
  Widget build(BuildContext context) {
    var _profile = Provider.of<Profile>(context);
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseService.firestore
            .collection("reserved_breeds")
            .where("uid", isEqualTo: _profile.user.uid)
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

          Report<ReservedBreed> cows = Report(0, []);
          Report<ReservedBreed> chicken = Report(0, []);
          Report<ReservedBreed> pigs = Report(0, []);

          items.forEach((element) {
            if (element.animal == "Cows") {
              cows.count += 1;
              cows.items.add(element);
            } else if (element.animal == "Chicken") {
              chicken.count += 1;
              chicken.items.add(element);
            } else if (element.animal == "Pigs") {
              pigs.count += 1;
              pigs.items.add(element);
            }
          });
          return SingleChildScrollView(
            child: Column(
              children: [
                ReportCard(
                  report: cows,
                  index: 0,
                  animal: "Cow",
                ),
                ReportCard(
                  report: chicken,
                  index: 1,
                  animal: "Chicken",
                ),
                ReportCard(
                  report: pigs,
                  index: 2,
                  animal: "Pig",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final Report report;
  final String animal;
  final int index;

  const ReportCard({Key key, this.report, this.animal, this.index})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                    Image.asset(
                      categories[index].iconPath,
                      scale: 1,
                    ),
                    Expanded(child: Container()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$animal breeds",
                          style: TextStyle(
                            fontSize: 22,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text("Total requests"),
                        Text(report.count.toString()),
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
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "All requests",
                      style: Theme.of(context).textTheme.body2,
                    )),
                collapsed: Text(
                  "Total: ${report.count}",
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (ReservedBreed _ in report.items)
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
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
