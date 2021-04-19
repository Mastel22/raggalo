import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raggalo/pages/home.dart';
import 'package:raggalo/pages/signin.dart';
import 'package:raggalo/providers/profile.dart';
import 'package:raggalo/services/firebase.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool showPassword = false;
  var roles = ['Farmer', 'Vet'];
  var selectedRole = "Farmer";
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController namesController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController feeController = TextEditingController();
  TextEditingController followupFeeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Profile _profile;

  @override
  Widget build(BuildContext context) {
    _profile = Provider.of<Profile>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 70, bottom: 70),
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      SizedBox(height: 32),
                      Text(
                        "SIGN UP",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: namesController,
                        decoration: InputDecoration(
                          labelText: "Names",
                          suffixIcon: Icon(
                            Icons.person,
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
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          suffixIcon: Icon(
                            Icons.email,
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
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          ),
                        ),
                        obscureText: !showPassword,
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
                          labelText: "You are a",
                        ),
                        items: roles.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                        value: selectedRole,
                      ),
                      SizedBox(height: 9),
                      TextFormField(
                        controller: idController,
                        decoration: InputDecoration(
                          labelText: "$selectedRole ID",
                          suffixIcon: Icon(
                            Icons.email,
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "This shoud not be empty.";
                          }
                          return null;
                        },
                      ),
                      if (selectedRole == "Vet") SizedBox(height: 32),
                      if (selectedRole == "Vet")
                        TextFormField(
                          controller: feeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Fee",
                            suffixText: "RWF",
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "This shoud not be empty.";
                            }
                            return null;
                          },
                        ),
                      if (selectedRole == "Vet") SizedBox(height: 32),
                      if (selectedRole == "Vet")
                        TextFormField(
                          controller: followupFeeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Followup fee",
                            suffixText: "RWF",
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "This shoud not be empty.";
                            }
                            return null;
                          },
                        ),
                      SizedBox(height: 32),
                      TextFormField(
                        controller: bioController,
                        decoration: InputDecoration(
                          labelText: "Your bio",
                          suffixIcon: Icon(
                            Icons.person,
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "This shoud not be empty.";
                          }
                          return null;
                        },
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
                                  var user = await FirebaseService.signup(
                                    emailController.text,
                                    passwordController.text,
                                    namesController.text,
                                    selectedRole,
                                    idController.text,
                                    bioController.text,
                                    feeController.text,
                                    followupFeeController.text,
                                  );

                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (user != null) {
                                    _profile.user = user;
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => HomePage(),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  "Signup".toUpperCase(),
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
                          if (isLoading) CircularProgressIndicator()
                        ],
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: Colors.black.withOpacity(.42),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => SigninPage(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Text(
                                  "Log in",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
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
