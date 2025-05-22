import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/employeemodels/palletoperation.model.dart';

class EPJMPJAssessmentController {
  final acknowledgmentDateController = TextEditingController();
  final nameController = TextEditingController();

  String selectedQ1ManualPalletCheck = "";
  bool? q2RideOnPalletJack;
  String selectedQ3SurfaceCheck = "";
  bool? q4PushWithHandle;
  bool? q5EnsureLoadStable;
  String selectedQ6IfDifficultToMove = "";

  File? signatureFile;

  int userId = 0;
  final Session session = Session();

  Future<void> init() async {
    final userIdStr = await session.getSession("userId");
    userId = int.tryParse(userIdStr ?? "") ?? 0;
    acknowledgmentDateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    await populateFromSession();
  }

  Future<void> populateFromSession() async {
    final userJson = await session.getSession('loggedInUser');
    if (userJson == null) return;
    final Map<String, dynamic> userData = jsonDecode(userJson);
    nameController.text = userData["name"] ?? "";
  }

  Future<void> submitForm(BuildContext context) async {
    if (nameController.text.trim().isEmpty ||
        acknowledgmentDateController.text.trim().isEmpty ||
        selectedQ1ManualPalletCheck.isEmpty ||
        q2RideOnPalletJack == null ||
        selectedQ3SurfaceCheck.isEmpty ||
        q4PushWithHandle == null ||
        q5EnsureLoadStable == null ||
        selectedQ6IfDifficultToMove.isEmpty ||
        signatureFile == null) {
      _showDialog(context, "Missing Fields",
          "Please complete all fields and provide your signature.");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final model = EPJMPJAssessmentModel(
      acknowledgmentDate: acknowledgmentDateController.text.trim(),
      name: nameController.text.trim(),
      q1ManualPalletCheck: selectedQ1ManualPalletCheck.trim(),
      q2RideOnPalletJack: q2RideOnPalletJack! ? "Yes" : "No",
      q3SurfaceCheck: selectedQ3SurfaceCheck.trim(),
      q4PushWithHandle: q4PushWithHandle! ? "Yes" : "No",
      q5EnsureLoadStable: q5EnsureLoadStable! ? "Yes" : "No",
      q6IfDifficultToMove: selectedQ6IfDifficultToMove.trim(),
      signature: signatureFile!,
      isActive: true,
      createdOn: DateTime.now().toIso8601String(),
      createdBy: userId,
    );

    final success = await EPJMPJAssessmentModel.submitForm(model);

    Navigator.pop(context); // close loading dialog

    if (success) {
      _showDialog(context, "Success", "Form submitted successfully.",
          onOk: () => Navigator.pop(context));
    } else {
      _showDialog(context, "Error", "Form submission failed.");
    }
  }

  void _showDialog(BuildContext context, String title, String message,
      {VoidCallback? onOk}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onOk?.call();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void dispose() {
    acknowledgmentDateController.dispose();
    nameController.dispose();
  }
}
