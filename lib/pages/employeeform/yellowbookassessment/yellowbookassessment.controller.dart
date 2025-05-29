import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/employeemodels/yellowbookassessment.model.dart';

class YellowBookAssessmentController {
  final nameController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? selectedQuestion1;

  int userId = 0;
  final Session session = Session();

  Future<void> init() async {
    final userIdStr = await session.getSession("userId");
    userId = int.tryParse(userIdStr ?? "") ?? 0;
    await populateFromSession();
  }

  Future<void> populateFromSession() async {
    final userJson = await session.getSession('loggedInUser');
    if (userJson == null) return;

    final Map<String, dynamic> userData = jsonDecode(userJson);
    nameController.text = userData["name"] ?? "";
  }

  Future<void> submitForm(BuildContext context) async {
    if (nameController.text.trim().isEmpty || selectedQuestion1 == null) {
      _showDialog(
        context,
        "Missing Fields",
        "Please complete all fields before submitting.",
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Format dates as strings YYYY-MM-DD
    final dateFormat = DateFormat('yyyy-MM-dd');
    final dateStr = dateFormat.format(selectedDate);
    final createdOnStr = dateFormat.format(DateTime.now());

    final model = YellowBookAssessment(
      question1: selectedQuestion1!,
      name: nameController.text.trim(),
      date: dateStr,
      createdOn: createdOnStr,
      createdBy: userId,
      isActive: true,
    );

    final success = await YellowBookAssessment.submit(model);

    Navigator.pop(context); // Close the loading dialog

    if (success) {
      _showDialog(
        context,
        "Success",
        "Form submitted successfully.",
        onOk: () => Navigator.pop(context),
      );
    } else {
      _showDialog(context, "Error", "Form submission failed.");
    }
  }

  void _showDialog(
    BuildContext context,
    String title,
    String message, {
    VoidCallback? onOk,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onOk != null) onOk();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void dispose() {
    nameController.dispose();
  }
}
