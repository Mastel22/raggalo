import 'package:flutter/foundation.dart';
import 'package:raggalo/models/user.dart';

class Profile with ChangeNotifier {
  User _user;
  Profile({User user}) {
    this._user = user;
  }
  User get user => _user;
  set user(User value) {
    this._user = value;
  }

  set setUser(User value) {
    this._user = value;
    notifyListeners();
  }
}
