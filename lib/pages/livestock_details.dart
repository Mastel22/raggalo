import 'package:flutter/material.dart';
import 'package:raggalo/configuration.dart';
import 'package:raggalo/pages/feedstuff_data.dart';

class LivestockDetailsPage extends StatefulWidget {
  @override
  _LivestockDetailsPageState createState() => _LivestockDetailsPageState();
}

class _LivestockDetailsPageState extends State<LivestockDetailsPage> {
  int selectedCategory;
  String selectedPeriodValue = "";
  int selectedFoodNameIndex = 1;
  int selectedFoodQuantity = 0;
  int selectedFoodFrancs = 0;
  String selectedFoodNameValue = "";
  TextEditingController countController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Livestock details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories
                    .asMap()
                    .map(
                      (index, category) => MapEntry(
                        index,
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = index;
                                  });
                                  // widget.onTap(categories[index]['name']);
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  margin: EdgeInsets.symmetric(horizontal: 18),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: customShadow,
                                    border: selectedCategory == index
                                        ? Border.all(
                                            color: secondaryGreen,
                                            width: 2,
                                          )
                                        : null,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Image.asset(
                                    category.iconPath,
                                    scale: 1.8,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
              SizedBox(height: 50),
              if (selectedCategory != null)
                Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Color(0xffE5E5E5).withOpacity(0.35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: countController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText:
                              "Number of ${categories[selectedCategory].name}",
                          suffixIcon: Icon(
                            Icons.countertops,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "This shoud not be empty.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: "Age range",
                        ),
                        items: categories[selectedCategory]
                            .data
                            .periods
                            .map((item) => item.range)
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          var period = categories[selectedCategory]
                              .data
                              .periods
                              .where((item) => item.range == value)
                              .toList()
                              .first;
                          selectedFoodQuantity = period.quantity;
                          setState(() {
                            selectedPeriodValue = period.range;
                          });
                        },
                        value: selectedPeriodValue,
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: "Feedstuff",
                        ),
                        items: categories[selectedCategory]
                            .data
                            .food
                            .map((item) => item.name)
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          var food = categories[selectedCategory]
                              .data
                              .food
                              .where((item) => item.name == value)
                              .toList()
                              .first;
                          selectedFoodFrancs = food.francs;
                          setState(() {
                            selectedFoodNameValue = food.name;
                          });
                        },
                        value: selectedFoodNameValue,
                      ),
                      SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => FeedstuffDataPage(
                                      category: categories[selectedCategory],
                                      numberOfAnimals: int.parse(
                                        countController.text,
                                      ),
                                      selectedFoodFrancs: selectedFoodFrancs,
                                      selectedFoodQuantity:
                                          selectedFoodQuantity,
                                    ),
                                  ),
                                );
                              },
                              child: Text("Submit".toUpperCase()),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor,
                                ),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 46,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 9),
            ],
          ),
        ),
      ),
    );
  }
}
