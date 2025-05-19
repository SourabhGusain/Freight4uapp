import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ChangePasswordController extends BaseViewModel {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool hideCurrent = true;
  bool hideNew = true;
  bool hideConfirm = true;

  void init() {}

  void toggleCurrentVisibility() {
    hideCurrent = !hideCurrent;
    notifyListeners();
  }

  void toggleNewVisibility() {
    hideNew = !hideNew;
    notifyListeners();
  }

  void toggleConfirmVisibility() {
    hideConfirm = !hideConfirm;
    notifyListeners();
  }

  Future<bool> changePassword(BuildContext context) async {
    final current = currentPasswordController.text;
    final newPass = newPasswordController.text;
    final confirm = confirmPasswordController.text;

    if (newPass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return false;
    }

    // Add real change password logic here
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
