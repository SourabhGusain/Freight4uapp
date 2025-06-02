import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/employeemodels/scissorlifttraining.model.dart';

class ScissorLiftTrainingController {
  final nameController = TextEditingController();
  final traineeOrganizationnameController = TextEditingController();
  final dateController = TextEditingController();

  File? signatureFile;
  String? signatureFileName;

  int userId = 0;
  final Session session = Session();

  Future<void> init() async {
    try {
      String? userIdStr = await session.getSession("userId");
      if (userIdStr != null) userId = int.tryParse(userIdStr) ?? 0;
    } catch (e) {
      print("Failed to init session userId: $e");
    }
  }

  Future<void> populateFromSession(Session session) async {
    final userJsonString = await session.getSession('loggedInUser');
    if (userJsonString == null) return;

    try {
      final Map<String, dynamic> userData = jsonDecode(userJsonString);
      nameController.text = userData["name"] ?? "";
      dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    } catch (e) {
      print('Failed to parse session user data: $e');
    }
  }

  Future<void> submitForm(BuildContext context) async {
    if (nameController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty) {
      _showDialog(context, "Missing Information",
          "Please fill in all required fields before submitting.");
      return;
    }

    if (signatureFile == null) {
      _showDialog(context, "Missing Signature",
          "Please upload your signature before submitting.");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final model = ScissorLiftTrainingModel(
      traineeOrganization: traineeOrganizationnameController.text.trim(),
      name: nameController.text.trim(),
      date: DateTime.parse(dateController.text.trim()),
      signature: signatureFile,
      createdBy: userId,
      createdOn: DateTime.now(),
    );

    bool success = await ScissorLiftTrainingModel.submitInductionForm(model);

    Navigator.pop(context); // close loading
    if (success) {
      _showDialog(
        context,
        "Success",
        "Induction form submitted successfully.",
        onOk: () {
          Navigator.of(context).pop();
        },
      );
    } else {
      _showDialog(context, "Error",
          "Failed to submit induction form. Please try again.");
    }
  }

  void _showDialog(BuildContext context, String title, String content,
      {VoidCallback? onOk}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
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
    dateController.dispose();
  }
}
