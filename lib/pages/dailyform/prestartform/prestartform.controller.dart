import 'package:flutter/material.dart';
import 'package:Freight4u/models/settings.model.dart';

class PrestartFormController {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController regoNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  String selectedContractor = '';
  String selectedShape = '';

  List<bool> declarationAnswers = List.filled(8, false);

  SettingsModel? settings;

  Future<void> init() async {
    try {
      settings = await fetchSettingsData();
      print('Settings loaded:');
      print('Contractors: ${settings?.contracts.map((c) => c.name).toList()}');
      print('Shapes: ${settings?.shapes.map((s) => s.name).toList()}');
    } catch (e) {
      print('Failed to load settings: $e');
    }
  }

  // Get contractor names for dropdown
  List<String> get contractorNames =>
      settings?.contracts.map((c) => c.name).toList() ?? [];

  // Get shape names for dropdown
  List<String> get shapeNames =>
      settings?.shapes.map((s) => s.name).toList() ?? [];

  // Handle form save logic
  Future<void> saveForm() async {
    // Form data collection
    print("Saving Prestart Form:");
    print("Full Name: ${fullNameController.text}");
    print("Rego Name: ${regoNameController.text}");
    print("Date: ${dateController.text}");
    print("Time: ${timeController.text}");
    print("Contractor: $selectedContractor");
    print("Shape: $selectedShape");
    print("Declaration Answers:");

    // Iterate through all declaration answers
    for (int i = 0; i < declarationAnswers.length; i++) {
      print("Declaration ${i + 1}: ${declarationAnswers[i]}");
    }

    // Simulate form saving process
    await Future.delayed(const Duration(seconds: 2));

    // Show success message
    print("Form saved successfully.");
  }

  // Reset all form fields to initial state
  void resetForm() {
    fullNameController.clear();
    regoNameController.clear();
    dateController.clear();
    timeController.clear();
    selectedContractor = '';
    selectedShape = '';
    declarationAnswers = List.filled(8, false); // Reset declaration answers
  }

  // Dispose of text controllers to free up resources
  void dispose() {
    fullNameController.dispose();
    regoNameController.dispose();
    dateController.dispose();
    timeController.dispose();
  }
}
