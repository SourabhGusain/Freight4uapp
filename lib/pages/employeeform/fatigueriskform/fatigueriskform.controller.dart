import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/employeemodels/fatigueriskform.model.dart';

class FatigueRiskManagementController {
  String? q1DriveWithoutBreak;
  String? q2RestBetweenShifts;
  String? q3RestBreakDuration;
  String? q4DriveNoBreaksBetweenShifts;
  String? q5NotifyManagerOfFatigueChange;

  // Text field controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController acknowledgmentDateController =
      TextEditingController();

  // Signature
  late SignatureController signatureController;

  // Acknowledgment date
  DateTime acknowledgmentDate = DateTime.now();

  // Session & user
  final Session session = Session();
  int userId = 0;

  // Dropdown options
  final List<String> FATIGUE_CHOICES_1 = [
    "Less than 2 hours",
    "2-4 hours",
    "More than 4 hours"
  ];

  final List<String> FATIGUE_CHOICES_2 = [
    "Less than 8 hours",
    "8-10 hours",
    "More than 10 hours"
  ];

  final List<String> FATIGUE_CHOICES_3 = [
    "Less than 30 minutes",
    "30-60 minutes",
    "More than 60 minutes"
  ];

  // Init controller and populate default values
  Future<void> init() async {
    try {
      final userIdStr = await session.getSession("userId");
      if (userIdStr != null) userId = int.tryParse(userIdStr) ?? 0;

      final userJsonString = await session.getSession('loggedInUser');
      if (userJsonString != null) {
        final userData = jsonDecode(userJsonString) as Map<String, dynamic>;
        nameController.text = userData["name"] ?? "";
      }

      acknowledgmentDateController.text =
          DateFormat('yyyy-MM-dd').format(acknowledgmentDate);

      signatureController = SignatureController(
        penColor: Colors.black,
        penStrokeWidth: 3,
        exportBackgroundColor: Colors.white,
      );
    } catch (e) {
      print("FatigueForm init error: $e");
    }
  }

  void setAcknowledgmentDate(DateTime date) {
    acknowledgmentDate = date;
    acknowledgmentDateController.text = DateFormat('yyyy-MM-dd').format(date);
  }

  void clearSignature() {
    signatureController.clear();
  }

  void dispose() {
    nameController.dispose();
    acknowledgmentDateController.dispose();
    signatureController.dispose();
  }

  bool validateInputs() {
    return q1DriveWithoutBreak != null &&
        q2RestBetweenShifts != null &&
        q3RestBreakDuration != null &&
        q4DriveNoBreaksBetweenShifts != null &&
        q5NotifyManagerOfFatigueChange != null &&
        nameController.text.trim().isNotEmpty &&
        !signatureController.isEmpty;
  }

  Future<bool> submitForm() async {
    if (!validateInputs()) {
      print("Form invalid: Missing fields or empty signature.");
      return false;
    }

    try {
      // Export signature to bytes
      final Uint8List? signatureBytes = await signatureController.toPngBytes();
      if (signatureBytes == null) {
        print("Signature export failed.");
        return false;
      }

      // Save signature to temp file
      final fileName = 'signature_${DateTime.now().millisecondsSinceEpoch}.png';
      final signatureFile = File('${Directory.systemTemp.path}/$fileName');
      await signatureFile.writeAsBytes(signatureBytes);

      final model = FatigueRiskManagementModel(
        q1DriveWithoutBreak: q1DriveWithoutBreak!,
        q2RestBetweenShifts: q2RestBetweenShifts!,
        q3RestBreakDuration: q3RestBreakDuration!,
        q4DriveNoBreaksBetweenShifts: q4DriveNoBreaksBetweenShifts!,
        q5NotifyManagerOfFatigueChange: q5NotifyManagerOfFatigueChange!,
        name: nameController.text.trim(),
        acknowledgmentDate: acknowledgmentDate,
        signature: signatureFile,
        createdOn: DateTime.now(),
        createdBy: userId,
      );

      return await FatigueRiskManagementModel.submitForm(model);
    } catch (e) {
      print("Form submission error: $e");
      return false;
    }
  }
}
