import 'package:flutter/material.dart';

class UserPhoneNumber {
  String exitCode;
  String phoneNumber;

  UserPhoneNumber({required this.exitCode, required this.phoneNumber});
}

class PhoneNumberProvider extends ChangeNotifier {
  UserPhoneNumber _phoneNumber = UserPhoneNumber(exitCode: '', phoneNumber: '');

  UserPhoneNumber get phoneNumber => _phoneNumber;

  void updateData(UserPhoneNumber newData) {
    _phoneNumber = newData;
    notifyListeners();
  }
}
