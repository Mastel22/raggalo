import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Color primaryGreen = Color(0xff416d6d);
Color secondaryGreen = Color(0xff16a085);
Color fadedBlack = Colors.black.withAlpha(150);
List<BoxShadow> customShadow = [
  BoxShadow(
    color: Colors.grey[300],
    blurRadius: 30,
    offset: Offset(0, 10),
  ),
];

// List<Map> categories = [
//   {"name": "Cows", "iconPath": "images/horse.png", "": []},
//   {"name": "Chicken", "iconPath": "images/dog.png"},
//   {"name": "Pigs", "iconPath": "images/bird.png"},
// ];

List<Category> categories = [
  Category(
    "Cows",
    "images/horse.png",
    Data(
      [
        Period("", 0),
        Period("0 - 6 months", 1),
      ],
      [
        Food(
          "",
          0,
          0,
        ),
        Food(
          "Ibirayi",
          1,
          552,
        ),
      ],
    ),
  ),
  Category(
    "Chicken",
    "images/dog.png",
    Data(
      [
        Period("", 0),
        Period("0 - 6 months", 1),
      ],
      [
        Food(
          "",
          0,
          0,
        ),
        Food(
          "Ibirayi",
          1,
          552,
        ),
      ],
    ),
  ),
  Category(
    "Pigs",
    "images/bird.png",
    Data(
      [
        Period("", 0),
        Period("0 - 6 months", 1),
      ],
      [
        Food(
          "",
          0,
          0,
        ),
        Food(
          "Ibirayi",
          1,
          552,
        ),
      ],
    ),
  ),
];

class Category {
  final String name;
  final String iconPath;
  final Data data;

  Category(this.name, this.iconPath, this.data);
}

class Data {
  final List<Period> periods;
  final List<Food> food;

  Data(this.periods, this.food);
}

class Period {
  final String range;
  final int quantity;

  Period(this.range, this.quantity);
}

class Food {
  final String name;
  final int quantity;
  final int francs;

  Food(this.name, this.quantity, this.francs);
}
