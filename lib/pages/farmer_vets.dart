import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:raggalo/models/user.dart';
import 'package:raggalo/providers/profile.dart';
import 'package:raggalo/services/firebase.dart';

class VetServicesPage extends StatefulWidget {
  @override
  _VetServicesPageState createState() => _VetServicesPageState();
}

class _VetServicesPageState extends State<VetServicesPage> {
  TextEditingController reasonController = TextEditingController();

  TextEditingController createdAtController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  bool withFollowup = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 356)));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        createdAtController.text = DateFormat("M/d/y").format(picked);
      });
  }

  @override
  Widget build(BuildContext context) {
    var _profile = Provider.of<Profile>(context);
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
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
              child: Text("No users found!"),
            );
          }
          var users = snapshot.data.docs
              .map((item) => User.fromJson(item.data()))
              .toList();
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: ClipOval(
                  child: Image.network(
                    users[index].image ??
                        "https://res.cloudinary.com/dlwzb2uh3/image/upload/v1610558268/StaffPhoto_LaToya_vuqmja.png",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(users[index].names),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(users[index].bio),
                    SizedBox(
                      height: 2,
                    ),
                    Text("Fee: ${users[index].fee}"),
                    SizedBox(
                      height: 2,
                    ),
                    Text("Follow up Fee: ${users[index].followupFee}"),
                  ],
                ),
                trailing: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text("Request visit"),
                          content: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: reasonController,
                                  decoration: InputDecoration(
                                    labelText: "Reason",
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "This shoud not be empty.";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 8),
                                CheckboxListTile(
                                  value: withFollowup,
                                  title: Text("Include follow up"),
                                  onChanged: (value) {
                                    setState(() {
                                      withFollowup = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 8),
                                TextFormField(
                                  controller: createdAtController,
                                  decoration: InputDecoration(
                                    labelText: "Date",
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.calendar_today),
                                      onPressed: () {
                                        _selectDate(context);
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "This shoud not be empty.";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                          actions: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  if (!_formKey.currentState.validate()) {
                                    return;
                                  }
                                  FirebaseService.requestVisit(
                                      _profile.user.uid,
                                      users[index].uid,
                                      reasonController.text,
                                      withFollowup,
                                      DateTime.now().toString());
                                  reasonController.clear();
                                  createdAtController.clear();
                                  Navigator.pop(context);
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                      "Your request has been sent successfully!",
                                    ),
                                  ));
                                },
                                child: Text("Submit"),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: Text("Request Visit"),
                ),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}
