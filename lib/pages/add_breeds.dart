import 'dart:io';

import 'package:flutter/material.dart';
import 'package:raggalo/models/image_source_type.model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:raggalo/services/firebase.dart';

class AddBreedsPage extends StatefulWidget {
  @override
  _AddBreedsPageState createState() => _AddBreedsPageState();
}

class _AddBreedsPageState extends State<AddBreedsPage> {
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File _selectedImage;
  var animals = ["Cows", "Chicken", "Pigs"];
  String selectedAnimal = "Cows";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Breeds"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 32,
              ),
              Stack(
                children: [
                  if (_selectedImage == null)
                    Container(
                      width: 150,
                      height: 150,
                      color: Colors.grey,
                    ),
                  if (_selectedImage != null)
                    Image.file(
                      _selectedImage,
                      width: 150,
                      height: 150,
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      color: Theme.of(context).primaryColor,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          _askedToLead();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.photo_camera,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 32,
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "This shoud not be empty.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: locationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Location",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "This shoud not be empty.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  isDense: true,
                  labelText: "Animal",
                ),
                items: animals.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAnimal = value;
                  });
                },
                value: selectedAnimal,
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLoading)
                    Expanded(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          var image = await uploadImages();
                          await FirebaseService.addBreed(
                            nameController.text,
                            selectedAnimal,
                            image,
                            locationController.text,
                          );

                          setState(() {
                            isLoading = false;
                          });

                          Navigator.pop(context);
                        },
                        child: Text(
                          "Save".toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.only(
                          top: 12,
                          bottom: 12,
                        ),
                      ),
                    ),
                  if (isLoading) CircularProgressIndicator(),
                ],
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future _pickImage(ImageSource source) async {
    try {
      var compressedImage = await ImagePicker().getImage(
        maxHeight: 405,
        maxWidth: 720,
        source: source,
        imageQuality: 95,
      );
      if (compressedImage != null) {
        setState(() {
          _selectedImage = File(compressedImage.path);
        });
      }
    } catch (e) {}
  }

  Future<String> uploadImages() async {
    var firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('images/${nameController.text}-${DateTime.now().toString()}');
    var task = await firebaseStorageRef.putFile(_selectedImage);
    var url = await task.ref.getDownloadURL();
    return url.toString();
  }

  _askedToLead() {
    showDialog<ImageSourceType>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Choose image"),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
                child: ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text("Camera"),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
                child: ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text("Galery"),
                ),
              ),
            ],
          );
        });
  }
}
