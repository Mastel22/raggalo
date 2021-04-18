import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raggalo/models/feedstuff.dart';
import 'package:raggalo/services/firebase.dart';
import 'package:raggalo/widgets/card.dart';

import '../configuration.dart';

class CategoryDisplay extends StatelessWidget {
  final String selectedAnimal;
  const CategoryDisplay({Key key, this.selectedAnimal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseService.firestore
            .collection("feedstuffs")
            .where("animal", isEqualTo: selectedAnimal)
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
                child: Text("No feedstuff found!"),
              ),
            );
          }
          var feedstuffs = snapshot.data.docs
              .map((item) => Feedstuff.fromJson(item.data()))
              .toList();
          return Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: feedstuffs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: CustomCard(
                    feedstuff: feedstuffs[index],
                  ),
                );
              },
            ),
          );
        });
  }
}
