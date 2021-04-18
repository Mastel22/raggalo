import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:raggalo/models/vet_request.dart';
import 'package:raggalo/providers/filter_requests.dart';
import 'package:raggalo/providers/profile.dart';
import 'package:raggalo/services/firebase.dart';

class RequestsPage extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  Widget build(BuildContext context) {
    var _profile = Provider.of<Profile>(context);
    var _status = Provider.of<FilterProvider>(context);
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseService.firestore
            .collection("vet_requests")
            .where("vetUid", isEqualTo: _profile.user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text("No breeds found!"),
              ),
            );
          }

          List<VetRequest> items = [];

          snapshot.data.docs.forEach((item) {
            var element = VetRequest.fromJson(item.data());
            if (_status.currentStatus == "All") {
              items.add(element);
            }
            if (_status.currentStatus == element.status) {
              items.add(VetRequest.fromJson(item.data()));
            }
          });
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseService.firestore
                    .collection("users")
                    .doc(items[index].requesertUid)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  if (!snapshot.data.exists) {
                    return Container();
                  }
                  return ListTile(
                    title: Text(snapshot.data.get("names")),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(items[index].reason),
                        Text(
                          items[index].status,
                          style: TextStyle(
                            color: items[index].status == "Accepted"
                                ? Colors.green
                                : items[index].status == "Rejected"
                                    ? Colors.red
                                    : Colors.yellow,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      DateFormat("M/D/y").format(
                        DateTime.parse(items[index].createAt),
                      ),
                    ),
                    isThreeLine: true,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text("Update status"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [],
                            ),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: RaisedButton(
                                  color: Colors.red,
                                  onPressed: () {
                                    FirebaseService.updateRequestStatus(
                                        items[index].id, "Rejected");
                                    Navigator.pop(context);
                                  },
                                  child: Text("Reject"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    FirebaseService.updateRequestStatus(
                                        items[index].id, "Accepted");
                                    Navigator.pop(context);
                                  },
                                  child: Text("Accept"),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
