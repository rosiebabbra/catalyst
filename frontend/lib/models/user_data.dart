import 'package:flutter/material.dart';

class UserPhoneNumber {
  String exitCode;
  String phoneNumber;

  UserPhoneNumber({required this.exitCode, required this.phoneNumber});
}

class MyPhoneNumberProvider extends ChangeNotifier {
  UserPhoneNumber _myPhoneNumber =
      UserPhoneNumber(exitCode: '', phoneNumber: '');

  UserPhoneNumber get myPhoneNumber => _myPhoneNumber;

  set myPhoneNumber(UserPhoneNumber newValue) {
    _myPhoneNumber = newValue;
    notifyListeners();
  }
}
