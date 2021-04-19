import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:raggalo/configuration.dart';
import 'package:raggalo/models/breed.dart';
import 'package:raggalo/pages/breeds_details.dart';
import 'package:raggalo/services/firebase.dart';
import 'package:raggalo/widgets/categories.dart';

class VetBreedsPage extends StatefulWidget {
  @override
  _VetBreedsPageState createState() => _VetBreedsPageState();
}

class _VetBreedsPageState extends State<VetBreedsPage> {
  String selectedAnimal = "Cows";
  final colors = [
    Colors.blueGrey[200],
    Colors.green[200],
    Colors.pink[100],
    Colors.brown[200],
    Colors.lightBlue[200],
  ];

  Random _random = new Random();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final randomColor = colors[_random.nextInt(colors.length)];
    return Scaffold(
      body: Column(
        children: [
          Categories(
            onTap: (String animal) {
              setState(() {
                selectedAnimal = animal;
              });
            },
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseService.firestore
                  .collection("breeds")
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
                      child: Text("No breeds found!"),
                    ),
                  );
                }
                var items = snapshot.data.docs
                    .map((item) => Breed.fromJson(item.data()))
                    .toList();
                return Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return BreedDetailsPage(
                                    breed: items[index],
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            height: 180,
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 16,
                                    bottom: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: size.width * 0.48,
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    items[index].name,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                items[index].animal,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: fadedBlack,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_pin,
                                                    size: 16,
                                                    color: primaryGreen,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Location: ${items[index].location}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: fadedBlack,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: customShadow,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: size.width * 0.48,
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: randomColor,
                                          boxShadow: customShadow,
                                          borderRadius:
                                              BorderRadius.circular(22),
                                        ),
                                      ),
                                      Hero(
                                        tag: items[index].id,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(22),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                items[index].image,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          height: 180,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }
}
