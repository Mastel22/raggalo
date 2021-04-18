import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:raggalo/models/image_source_type.model.dart';
import 'package:raggalo/models/user.dart';
import 'package:raggalo/providers/profile.dart';
import 'package:raggalo/services/firebase.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  Profile _profile;
  TextEditingController emailController = TextEditingController();
  TextEditingController namesController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File _selectedImage;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _profile = Provider.of<Profile>(context, listen: false);
      namesController.text = _profile.user.names;
      emailController.text = _profile.user.email;
      phoneController.text = _profile.user.phone;
      idController.text = _profile.user.id;
      bioController.text = _profile.user.bio;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _profile = Provider.of<Profile>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("PROFILE"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Stack(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(_profile.user.image ??
                              "https://res.cloudinary.com/dlwzb2uh3/image/upload/v1610558268/StaffPhoto_LaToya_vuqmja.png"),
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
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        left: 25.0,
                        right: 25.0,
                        top: 25.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Personal Information',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (_status)
                                GestureDetector(
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 14.0,
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 16.0,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _status = false;
                                    });
                                  },
                                )
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Names',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: namesController,
                              decoration: const InputDecoration(
                                hintText: "Enter Your Name",
                              ),
                              enabled: !_status,
                              autofocus: !_status,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "This shoud not be empty.";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Email',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                hintText: "Enter Email",
                              ),
                              enabled: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Mobile',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 25.0,
                        right: 25.0,
                        top: 2.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: phoneController,
                              decoration: const InputDecoration(
                                hintText: "Enter Mobile Number",
                              ),
                              enabled: !_status,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "This shoud not be empty.";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 25.0,
                        right: 25.0,
                        top: 25.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                'RAB ID',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            flex: 2,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: TextFormField(
                                  controller: idController,
                                  decoration: const InputDecoration(
                                    hintText: "Enter RAB ID",
                                  ),
                                  enabled: !_status,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "This shoud not be empty.";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              flex: 2,
                            ),
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 25.0,
                        right: 25.0,
                        top: 25.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                'Bio',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            flex: 2,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: TextFormField(
                                  controller: bioController,
                                  decoration: const InputDecoration(
                                    hintText: "Your specialization",
                                  ),
                                  enabled: !_status,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "This shoud not be empty.";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              flex: 2,
                            ),
                          ],
                        )),
                    if (!_status)
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Container(
                                    child: RaisedButton(
                                  child: Text("Save"),
                                  textColor: Colors.white,
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    var user = _profile.user;
                                    user.phone = phoneController.text;
                                    user.names = namesController.text;
                                    user.id = idController.text;
                                    user.bio = bioController.text;
                                    _profile.setUser = user;
                                    FirebaseService.updateUser(
                                      phoneController.text,
                                      namesController.text,
                                      idController.text,
                                      bioController.text,
                                      _profile.user.uid,
                                    );
                                    setState(() {
                                      _status = true;
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                )),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Container(
                                  child: FlatButton(
                                    child: Text("Cancel"),
                                    textColor: Colors.grey,
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        _status = true;
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                              ),
                              flex: 2,
                            ),
                          ],
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
        uploadImages();
      }
    } catch (e) {}
  }

  Future<void> uploadImages() async {
    var firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('images/${namesController.text}-${DateTime.now().toString()}');
    var task = await firebaseStorageRef.putFile(_selectedImage);
    var url = await task.ref.getDownloadURL();
    var user = _profile.user;
    user.image = url;
    _profile.setUser = user;
    FirebaseService.updateUserImage(_profile.user.uid, url);
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

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }
}
