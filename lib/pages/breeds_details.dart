import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:raggalo/configuration.dart';
import 'package:raggalo/models/breed.dart';
import 'package:raggalo/providers/menu.dart';
import 'package:raggalo/providers/profile.dart';
import 'package:raggalo/services/firebase.dart';
import 'package:raggalo/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BreedDetailsPage extends StatefulWidget {
  Breed breed;
  BreedDetailsPage({this.breed});

  @override
  _BreedDetailsPageState createState() => _BreedDetailsPageState();
}

class _BreedDetailsPageState extends State<BreedDetailsPage> {
  TextEditingController quantityController = TextEditingController();
  TextEditingController createdAtController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 356)));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        createdAtController.text = DateFormat("M/d/y").format(picked);
      });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var _profile = Provider.of<Profile>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 60, horizontal: 30),
                        // color: color,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Hero(
                                tag: widget.breed.id,
                                child: Image.network(
                                  widget.breed.image,
                                  width: size.width * 0.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 32,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.breed.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Text(
                                "Animal: ${widget.breed.animal}",
                                style: TextStyle(
                                  color: fadedBlack,
                                  height: 1.7,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Text(
                                "Location: ${widget.breed.location}",
                                style: TextStyle(
                                  color: fadedBlack,
                                  height: 1.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 42,
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(CupertinoIcons.chevron_left),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 20, left: 20),
                          child: CustomButton(
                            label: 'Reserve',
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      title: Text("Reserve"),
                                      content: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: createdAtController,
                                              decoration: InputDecoration(
                                                labelText: "Pickup Date",
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                      Icons.calendar_today),
                                                  onPressed: () {
                                                    _selectDate(context);
                                                  },
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return "This shoud not be empty.";
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(height: 8),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 16),
                                          child: RaisedButton(
                                            color:
                                                Theme.of(context).primaryColor,
                                            onPressed: () {
                                              if (!_formKey.currentState
                                                  .validate()) {
                                                return;
                                              }
                                              FirebaseService.reserveBreed(
                                                widget.breed.name,
                                                widget.breed.image,
                                                widget.breed.animal,
                                                _profile.user.uid,
                                                DateTime.now().toString(),
                                              );
                                              createdAtController.clear();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Provider.of<MenuProvider>(
                                                context,
                                                listen: false,
                                              ).updateCurrentPage(2);
                                            },
                                            child: Text("Submit"),
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
