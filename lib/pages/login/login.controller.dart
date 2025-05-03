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

    // Validate mobile number
    if (mobile.isEmpty) {
      mobileError = "Mobile number is required";
    } else if (mobile.length != 10 || int.tryParse(mobile) == null) {
      mobileError = "Enter a valid 10-digit mobile number";
    }

    // Validate password
    if (password.isEmpty) {
      passwordError = "Password is required";
    } else if (password.length < 4) {
      passwordError = "Password must be at least 4 characters";
    }

    // Notify listeners when there are validation changes
    notifyListeners();
    return mobileError == null && passwordError == null;
  }

  Future<bool> login() async {
    // First validate inputs
    if (!validateInputs()) return false;

    setBusy(true); // Start the busy state

    final mobile = mobileController.text.trim();
    final password = passwordController.text.trim();

    debugPrint("Mobile: $mobile");
    debugPrint("Password: $password");

    try {
      // Call the login API and get user data
      DriverModel? user = await DriverModel.loginApi(mobile, password);

      if (user != null) {
        driver = user; // Set the driver data on successful login
        setBusy(false); // End the busy state
        return true; // Login successful
      } else {
        setBusy(false); // End the busy state
        return false; // Login failed
      }
    } catch (e) {
      debugPrint("Login error: $e");
      setBusy(false); // End the busy state
      return false; // Login failed due to an exception
    }
  }

  @override
  void dispose() {
    mobileController.dispose(); // Dispose mobile controller
    passwordController.dispose(); // Dispose password controller
    super.dispose();
  }
}
