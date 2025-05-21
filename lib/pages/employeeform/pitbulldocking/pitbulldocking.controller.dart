import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/employeemodels/pitbulldocking.model.dart';

class PitbullDockingController {
  final dateController = TextEditingController();
  final nameController = TextEditingController();
  final q1DriversRedLightController = TextEditingController();
  final q3NoLightMeansRedController = TextEditingController();
  final q4SealRegistrationCheckController = TextEditingController();
  final q6ChockingRequiredController = TextEditingController();

  String selectedQ2GatehouseProcedure = "";
  String selectedQ5TrailerDockingStep = "";
  String selectedQ7TaskCommencementLight = "";

  File? signatureFile;

  int userId = 0;
  final Session session = Session();

  Future<void> init() async {
    final userIdStr = await session.getSession("userId");
    userId = int.tryParse(userIdStr ?? "") ?? 0;
  }

  Future<void> populateFromSession() async {
    final userJson = await session.getSession('loggedInUser');
    if (userJson == null) return;

    final Map<String, dynamic> userData = jsonDecode(userJson);
    nameController.text = userData["name"] ?? "";
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> pickSignatureFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null &&
        result.files.isNotEmpty &&
        result.files.first.path != null) {
      signatureFile = File(result.files.first.path!);
    }
  }

  Future<void> submitForm(BuildContext context) async {
    if (nameController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty ||
        signatureFile == null) {
      _showDialog(context, "Missing Fields", "Complete all fields and sign.");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final model = PitbullDockingModel(
      date: dateController.text.trim(),
      name: nameController.text.trim(),
      q1_drivers_red_light: q1DriversRedLightController.text.trim(),
      q2_gatehouse_procedure: selectedQ2GatehouseProcedure.trim(),
      q3_no_light_means_red: q3NoLightMeansRedController.text.trim(),
      q4_seal_registration_check: q4SealRegistrationCheckController.text.trim(),
      q5_trailer_docking_step: selectedQ5TrailerDockingStep.trim(),
      q6_chocking_required: q6ChockingRequiredController.text.trim(),
      q7_task_commencement_light: selectedQ7TaskCommencementLight.trim(),
      signature: signatureFile!,
      isActive: true,
      createdOn: DateTime.now().toIso8601String(),
      createdBy: userId,
    );

    final success = await PitbullDockingModel.submitForm(model);
    Navigator.pop(context);

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
    dateController.dispose();
    nameController.dispose();
    q1DriversRedLightController.dispose();
    q3NoLightMeansRedController.dispose();
    q4SealRegistrationCheckController.dispose();
    q6ChockingRequiredController.dispose();
  }
}
