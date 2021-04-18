import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:raggalo/models/feedstuff.dart';
import 'package:raggalo/pages/add_feedstuff.dart';
import 'package:raggalo/services/firebase.dart';

class FeedstuffsPage extends StatefulWidget {
  @override
  _FeedstuffsPageState createState() => _FeedstuffsPageState();
}

class _FeedstuffsPageState extends State<FeedstuffsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseService.firestore.collection("feedstuffs").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.docs.isEmpty) {
            return Center(
              child: Text("No feedstuff found!"),
            );
          }
          var feedstuffs = snapshot.data.docs
              .map((item) => Feedstuff.fromJson(item.data()))
              .toList();
          return ListView.builder(
            itemCount: feedstuffs.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Image.network(
                  feedstuffs[index].image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(feedstuffs[index].name),
                subtitle: Text(feedstuffs[index].ingredients),
                trailing: Text("${feedstuffs[index].quantity.toString()} Kgs"),
                onTap: () {},
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => AddFeedstuffPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
