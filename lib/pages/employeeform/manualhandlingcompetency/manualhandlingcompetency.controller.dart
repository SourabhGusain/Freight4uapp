import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/employeemodels/manualhandlingcompetency.model.dart';

class ManualHandlingCompetencyController {
  String? nonCompliance;
  bool? drivingPostureCorrect;
  String? incorrectTrolleyPractice;
  bool? attemptDifficultTask;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  late SignatureController signatureController;
  DateTime date = DateTime.now();
  final Session session = Session();
  int userId = 0;

  final Map<String, String> NON_COMPLIANCE_OPTIONS = {
    'ppe': 'Wearing suitable equipment & PPE',
    'path_clear': 'Ensure pathway is clear.',
    'attempt_alone': 'If load is too heavy, attempt it alone.',
    'bent_back': 'Keep back bent and elbows close to body.',
    'shoulders_line': 'Keep shoulders in Line with hips',
    'body_weight':
        'Shift your body weight forward, using your legs when picking up items.',
  };

  final Map<String, String> TROLLEY_CHOICES = {
    'A': 'Keep back straight',
    'B': 'Leaning sideways against the back rest',
    'C': 'Keep shoulders in line with hips and feet flat on the floor',
    'D': 'Ensure back is supported by chair',
  };

  Future<void> init() async {
    try {
      final userIdStr = await session.getSession("userId");
      if (userIdStr != null) {
        userId = int.tryParse(userIdStr) ?? 0;
      }

      final userJsonString = await session.getSession('loggedInUser');
      if (userJsonString != null) {
        final userData = jsonDecode(userJsonString) as Map<String, dynamic>;
        nameController.text = userData["name"] ?? "";
      }

      dateController.text = DateFormat('yyyy-MM-dd').format(date);

      signatureController = SignatureController(
        penColor: Colors.black,
        penStrokeWidth: 3,
        exportBackgroundColor: Colors.white,
      );
    } catch (e) {
      print("ManualHandling init error: $e");
    }
  }

  void setDate(DateTime selectedDate) {
    date = selectedDate;
    dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
  }

  void clearSignature() {
    signatureController.clear();
  }

  void dispose() {
    nameController.dispose();
    dateController.dispose();
    signatureController.dispose();
  }

  bool validateInputs() {
    print('nonCompliance: $nonCompliance');
    print('drivingPostureCorrect: $drivingPostureCorrect');
    print('incorrectTrolleyPractice: $incorrectTrolleyPractice');
    print('attemptDifficultTask: $attemptDifficultTask');
    print('name: "${nameController.text.trim()}"');
    print('signatureController.isEmpty: ${signatureController.isEmpty}');

    return nonCompliance != null &&
        drivingPostureCorrect != null &&
        incorrectTrolleyPractice != null &&
        attemptDifficultTask != null &&
        nameController.text.trim().isNotEmpty &&
        !signatureController.isEmpty;
  }

  Future<void> populateFromSession() async {
    final userJson = await session.getSession('loggedInUser');
    if (userJson == null) return;

    final Map<String, dynamic> userData = jsonDecode(userJson);
    nameController.text = userData["name"] ?? "";
  }

  Future<bool> submitForm() async {
    if (!validateInputs()) {
      print("Form invalid: Missing fields or empty signature.");
      return false;
    }

    try {
      final Uint8List? signatureBytes = await signatureController.toPngBytes();
      if (signatureBytes == null) {
        print("Signature export failed.");
        return false;
      }

      final fileName = 'signature_${DateTime.now().millisecondsSinceEpoch}.png';
      final signatureFile = File('${Directory.systemTemp.path}/$fileName');
      await signatureFile.writeAsBytes(signatureBytes);

      final model = ManualHandlingCompetencyModel(
        nonCompliance: nonCompliance!,
        drivingPostureCorrect: drivingPostureCorrect == true ? 'yes' : 'no',
        incorrectTrolleyPractice: incorrectTrolleyPractice!,
        attemptDifficultTask: attemptDifficultTask == true ? 'yes' : 'no',
        name: nameController.text.trim(),
        date: date,
        signature: signatureFile,
        createdOn: DateTime.now(),
        createdBy: userId,
      );

      return await ManualHandlingCompetencyModel
          .submitManualHandlingCompetencForm(model);
    } catch (e) {
      print("Form submission error: $e");
      return false;
    }
  }
}
