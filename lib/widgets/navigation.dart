import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raggalo/pages/livestock_details.dart';
import 'package:raggalo/pages/profile.dart';
import 'package:raggalo/pages/signin.dart';
import 'package:raggalo/providers/menu.dart';
import 'package:raggalo/providers/profile.dart';
import 'package:raggalo/services/firebase.dart';

class NavigationWidget extends StatefulWidget {
  final List<MenuItem> mainMenu;
  final Function(int) callback;
  final int current;

  NavigationWidget(
    this.mainMenu, {
    Key key,
    this.callback,
    this.current,
  });

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<NavigationWidget> {
  final widthBox = SizedBox(
    width: 16.0,
  );

  Profile _profile;

  @override
  Widget build(BuildContext context) {
    var menuProvider = Provider.of<MenuProvider>(context);
    _profile = Provider.of<Profile>(context);
    final TextStyle androidStyle = const TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
    final TextStyle iosStyle = const TextStyle(color: Colors.white);
    final style = kIsWeb
        ? androidStyle
        : Platform.isAndroid
            ? androidStyle
            : iosStyle;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => ProfilePage(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 24.0,
                    left: 24.0,
                    right: 24.0,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      _profile.user.image ??
                          "https://res.cloudinary.com/dlwzb2uh3/image/upload/v1610558268/StaffPhoto_LaToya_vuqmja.png",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 36.0,
                  left: 24.0,
                  right: 24.0,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    _profile.user.names,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ...widget.mainMenu
                      .map(
                        (item) => FlatButton(
                          onPressed: () {
                            widget.callback(item.index);
                          },
                          color: menuProvider.currentPage == item.index
                              ? Color(0x44000000)
                              : null,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                item.icon,
                                color: Colors.white,
                                size: 24,
                              ),
                              widthBox,
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: style,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  if (_profile.user.role == "Farmer")
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => LivestockDetailsPage(),
                          ),
                        );
                      },
                      color: null,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.dashboard_customize,
                            color: Colors.white,
                            size: 24,
                          ),
                          widthBox,
                          Expanded(
                            child: Text(
                              "Livestock details",
                              style: style,
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: OutlineButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Logout",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  onPressed: () {
                    _profile.user = null;
                    FirebaseService.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => SigninPage(),
                      ),
                    );
                  },
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  final int index;
  final Widget view;

  const MenuItem(this.title, this.icon, this.index, this.view);
}
