import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raggalo/pages/home.dart';
import 'package:raggalo/pages/signup.dart';
import 'package:raggalo/providers/filter_requests.dart';
import 'package:raggalo/providers/menu.dart';
import 'package:raggalo/providers/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:raggalo/services/firebase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = await FirebaseService.getUserDetails();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MenuProvider()),
        ChangeNotifierProvider(create: (context) => Profile(user: user)),
        ChangeNotifierProvider(create: (context) => FilterProvider()),
      ],
      child: MaterialApp(
        title: 'Raggalo',
        theme: ThemeData(
          primaryColor: Color(0xff07543D),
          accentColor: Color(0xff07543D),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: user != null ? HomePage() : SignupPage(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
