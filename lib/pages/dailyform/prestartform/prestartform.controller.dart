import 'package:flutter/material.dart';

class PrestartFormController {
  // Text controllers for the form fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController regoNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  // Data to hold the form fields
  String selectedContractor = '';
  String selectedShape = '';
  List<bool> declarationAnswers = List.filled(8, false);

  void init() {}

  Future<void> saveForm() async {
    print("Full Name: ${fullNameController.text}");
    print("Rego Name: ${regoNameController.text}");
    print("Date: ${dateController.text}");
    print("Time: ${timeController.text}");
    print("Contractor: $selectedContractor");
    print("Shape: $selectedShape");
    print("Declaration Answers: $declarationAnswers");

    await Future.delayed(Duration(seconds: 2));
  }

  void resetForm() {
    fullNameController.clear();
    regoNameController.clear();
    dateController.clear();
    timeController.clear();
    selectedContractor = '';
    selectedShape = '';
    declarationAnswers = List.filled(8, false);
  }

  void dispose() {
    fullNameController.dispose();
    regoNameController.dispose();
    dateController.dispose();
    timeController.dispose();
  }
}
