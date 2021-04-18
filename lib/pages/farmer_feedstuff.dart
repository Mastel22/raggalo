import 'package:flutter/material.dart';
import 'package:raggalo/widgets/categories.dart';
import 'package:raggalo/widgets/category_display.dart';

class FarmerFeedstuffPage extends StatefulWidget {
  @override
  _FarmerFeedstuffPageState createState() => _FarmerFeedstuffPageState();
}

class _FarmerFeedstuffPageState extends State<FarmerFeedstuffPage> {
  String selectedIndex = "Cows";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Categories(
            onTap: (String animal) {
              setState(() {
                selectedIndex = animal;
              });
            },
          ),
          CategoryDisplay(selectedAnimal: selectedIndex),
        ],
      ),
    );
  }
}
