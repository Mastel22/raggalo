import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:raggalo/models/breed.dart';
import 'package:raggalo/models/user.dart';
import 'package:raggalo/services/firebase.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseService.firestore.collection("users").snapshots(),
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
                subtitle: Text(users[index].role),
                trailing: PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: "Admin",
                        child: Text("Change to Admin"),
                      ),
                      PopupMenuItem(
                        value: "Farmer",
                        child: Text("Change to Farmer"),
                      ),
                      PopupMenuItem(
                        value: "Vet",
                        child: Text("Change to Vet"),
                      ),
                    ];
                  },
                  onSelected: (String value) {
                    FirebaseService.updateUserRole(users[index].uid, value);
                  },
                ),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
