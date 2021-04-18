import 'package:flutter/material.dart';
import 'package:raggalo/configuration.dart';

class FeedstuffDataPage extends StatefulWidget {
  final Category category;
  final int selectedFoodQuantity;
  final int numberOfAnimals;
  final int selectedFoodFrancs;

  const FeedstuffDataPage(
      {Key key,
      this.category,
      this.selectedFoodQuantity,
      this.numberOfAnimals,
      this.selectedFoodFrancs})
      : super(key: key);
  @override
  _FeedstuffDataPageState createState() => _FeedstuffDataPageState();
}

class _FeedstuffDataPageState extends State<FeedstuffDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedstuff"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Daily feedstuff",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffE5E5E5).withOpacity(0.35),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "The total compilation of feedstock for your livestock on a daily basis basing on the quantity and price.",
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Total quantity",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "${widget.selectedFoodQuantity * widget.numberOfAnimals}",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text("Bags of feedstuff")
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Total quantity",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "${(widget.selectedFoodQuantity * widget.numberOfAnimals) * widget.selectedFoodFrancs}",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text("Rwandan francs")
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 32,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Weekly feedstuff",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffF1C7C8).withOpacity(0.25),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "The total compilation of feedstock for your livestock on a weekly basis basing on the quantity and price.",
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Total quantity",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "${widget.selectedFoodQuantity * widget.numberOfAnimals * 7}",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text("Bags of feedstuff")
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Total quantity",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "${(widget.selectedFoodQuantity * widget.numberOfAnimals * 7) * widget.selectedFoodFrancs}",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text("Rwandan francs")
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 32,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Monthly feedstuff",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xff6F9F4B).withOpacity(0.25),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "The total compilation of feedstock for your livestock on a monthly basis basing on the quantity and price.",
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Total quantity",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "${widget.selectedFoodQuantity * widget.numberOfAnimals * 30}",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text("Bags of feedstuff")
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Total quantity",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "${(widget.selectedFoodQuantity * widget.numberOfAnimals * 30) * widget.selectedFoodFrancs}",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text("Rwandan francs")
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
