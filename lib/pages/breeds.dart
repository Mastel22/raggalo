import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:raggalo/models/breed.dart';
import 'package:raggalo/pages/add_breeds.dart';
import 'package:raggalo/services/firebase.dart';

class BreedsPage extends StatefulWidget {
  @override
  _BreedsPageState createState() => _BreedsPageState();
}

class _BreedsPageState extends State<BreedsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseService.firestore.collection("breeds").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data.docs.isEmpty) {
              return Center(
                child: Text("No breeds found!"),
              );
            }
            var breeds = snapshot.data.docs
                .map((item) => Breed.fromJson(item.data()))
                .toList();
            return ListView.builder(
              itemCount: breeds.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Image.network(
                    breeds[index].image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(breeds[index].name),
                  subtitle: Text(breeds[index].animal),
                  onTap: () {},
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => AddBreedsPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
