import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:Freight4u/models/driver.model.dart';
import 'package:Freight4u/helpers/session.dart';

class LoginController extends BaseViewModel {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? mobileError;
  String? passwordError;

  DriverModel driver = DriverModel.empty();

  void init() {
    debugPrint("LoginController initialized");
  }

  bool validateInputs() {
    mobileError = null;
    passwordError = null;

    final mobile = mobileController.text.trim();
    final password = passwordController.text.trim();

    if (mobile.isEmpty) {
      mobileError = "Mobile number is required";
    } else if (mobile.length != 10 || int.tryParse(mobile) == null) {
      mobileError = "Enter a valid 10-digit mobile number";
    }

    if (password.isEmpty) {
      passwordError = "Password is required";
    } else if (password.length < 4) {
      passwordError = "Password must be at least 4 characters";
    }

    notifyListeners();
    return mobileError == null && passwordError == null;
  }

  Future<bool> login(BuildContext context) async {
    if (!validateInputs()) {
      String errorMsg = '';
      if (mobileError != null) errorMsg += '$mobileError\n';
      if (passwordError != null) errorMsg += '$passwordError';

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Input Error'),
          content: Text(errorMsg.trim()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
      return false;
    }

    setBusy(true);

    final mobile = mobileController.text.trim();
    final password = passwordController.text.trim();

    try {
      DriverModel? user = await DriverModel.loginApi(mobile, password);

      setBusy(false);

      if (user != null) {
        driver = user;
        return true;
      } else {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Incorrect mobile number or password.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              )
            ],
          ),
        );
        return false;
      }
    } catch (e) {
      setBusy(false);

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('Login failed due to an error: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );

      return false;
    }
  }

  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
