import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:Freight4u/models/signup.model.dart';

class SignupController extends BaseViewModel {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final licenseController = TextEditingController();
  final vehicleController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isSignupSuccess = false;

  void init() {}

  Future<void> submitForm(BuildContext context) async {
    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final license = licenseController.text.trim();
    final vehicle = vehicleController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Passwords do not match'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (fullName.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        license.isEmpty ||
        vehicle.isEmpty ||
        password.isEmpty) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Incomplete Form'),
          content: const Text('Please fill all fields'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      setBusy(true);

      final driver = Driver(
        name: fullName,
        phone: phone,
        email: email,
        licenseNumber: license,
        vehicleNumber: vehicle,
        password: password,
      );

      final registeredDriver = await registerDriver(driver);

      isSignupSuccess = true;
      notifyListeners();

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Success'),
          content: Text('Signup successful for ${registeredDriver.name}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      isSignupSuccess = false;
      notifyListeners();

      // Optional: convert this to a dialog as well if you want
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $error')),
      );
    } finally {
      setBusy(false);
    }
  }

  void printFormDataAsJson() {
    final data = {
      "fullName": fullNameController.text.trim(),
      "phone": phoneController.text.trim(),
      "email": emailController.text.trim(),
      "licenseNumber": licenseController.text.trim(),
      "vehicleNumber": vehicleController.text.trim(),
      "password": passwordController.text,
      "confirmPassword": confirmPasswordController.text,
    };
    final jsonString = jsonEncode(data);
    print("Form Data in JSON:\n$jsonString");
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    licenseController.dispose();
    vehicleController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
