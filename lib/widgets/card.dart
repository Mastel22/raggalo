import 'dart:math';
import 'package:flutter/material.dart';
import 'package:raggalo/models/feedstuff.dart';
import 'package:raggalo/pages/details.dart';

import '../configuration.dart';

class CustomCard extends StatelessWidget {
  Feedstuff feedstuff;

  CustomCard({
    this.feedstuff,
  });

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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return DetailsPage(
                feedstuff: feedstuff,
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
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                feedstuff.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            feedstuff.animal,
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
                                'Location: ${feedstuff.location}',
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
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  Hero(
                    tag: feedstuff.id,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        image: DecorationImage(
                          image: NetworkImage(
                            feedstuff.image,
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
    );
  }
}
