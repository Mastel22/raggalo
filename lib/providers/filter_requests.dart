import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  String _currentStatus = "All";

  String get currentStatus => _currentStatus;

  void updateCurrentStatus(String status) {
    if (status != currentStatus) {
      _currentStatus = status;
      notifyListeners();
    }
  }
}
