import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Freight4u/models/employeemodels/coupling&uncoupling.model.dart';

class CouplingUncouplingController {
  final TextEditingController risksIdentifiedController =
      TextEditingController();
  final TextEditingController safetyControlsController =
      TextEditingController();
  final TextEditingController faultActionController = TextEditingController();
  final TextEditingController postUnpinActionController =
      TextEditingController();
  final TextEditingController airLeadsTwistController = TextEditingController();
  final TextEditingController tugTestsCountController = TextEditingController();
  final TextEditingController distractionActionController =
      TextEditingController();
  final TextEditingController climbingSafetyController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController uncouplingSequenceController =
      TextEditingController();
  final TextEditingController couplingSequenceController =
      TextEditingController();
  final TextEditingController acknowledgmentDateController =
      TextEditingController();

  final Session session = Session();
  int userId = 0;
  File? signatureFile;

  final Map<String, String> uncouplingMap = {
    'Legs - Pin - Air': 'A',
    'Pin - Air - Legs': 'B',
    'Air - Legs - Pin': 'C',
    'Pin - Legs - Air': 'D',
  };

  final Map<String, String> couplingMap = {
    'Air - Legs - Pin': 'A',
    'Pin - Legs - Pin': 'B',
    'Legs - Air - Pin': 'C',
    'Pin - Air - Legs': 'D',
  };

  Future<void> init() async {
    try {
      final userIdStr = await session.getSession("userId");
      if (userIdStr != null) userId = int.tryParse(userIdStr) ?? 0;

      final userJson = await session.getSession('loggedInUser');
      if (userJson != null) {
        final user = jsonDecode(userJson) as Map<String, dynamic>;
        nameController.text = user["name"] ?? "";
      }

      acknowledgmentDateController.text =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
    } catch (e) {
      print("Init error: $e");
    }
  }

  void dispose() {
    risksIdentifiedController.dispose();
    safetyControlsController.dispose();
    faultActionController.dispose();
    postUnpinActionController.dispose();
    airLeadsTwistController.dispose();
    tugTestsCountController.dispose();
    distractionActionController.dispose();
    climbingSafetyController.dispose();
    nameController.dispose();
    uncouplingSequenceController.dispose();
    couplingSequenceController.dispose();
    acknowledgmentDateController.dispose();
  }

  bool validateInputs() {
    final hasName = nameController.text.trim().isNotEmpty;
    final hasDate = acknowledgmentDateController.text.trim().isNotEmpty;
    final hasSignature = signatureFile != null && signatureFile!.existsSync();

    if (!hasName || !hasDate || !hasSignature) {
      print("Validation failed:");
      print(" - Name: $hasName");
      print(" - Date: $hasDate");
      print(" - Signature Exists: $hasSignature");
    }

    return hasName && hasDate && hasSignature;
  }

  Future<void> setSignature(Uint8List signatureBytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/signature.png');
    await file.writeAsBytes(signatureBytes);
    signatureFile = file;
    print('Signature saved to ${signatureFile?.path}');
  }

  Future<bool> submitForm(BuildContext context) async {
    if (!validateInputs()) {
      _showErrorDialog(context,
          'Validation failed. Please fill all required fields and provide a signature.');
      return false;
    }

    try {
      final acknowledgmentDate =
          DateFormat('yyyy-MM-dd').parse(acknowledgmentDateController.text);

      final uncouplingCode =
          uncouplingMap[uncouplingSequenceController.text.trim()] ?? '';
      final couplingCode =
          couplingMap[couplingSequenceController.text.trim()] ?? '';

      final model = CouplingUncouplingQuestionnaireModel(
        risksIdentified: risksIdentifiedController.text.trim(),
        safetyControls: safetyControlsController.text.trim(),
        faultAction: faultActionController.text.trim(),
        uncouplingSequence: uncouplingCode,
        postUnpinAction: postUnpinActionController.text.trim(),
        couplingSequence: couplingCode,
        airLeadsTwist: airLeadsTwistController.text.trim(),
        tugTestsCount: tugTestsCountController.text.trim(),
        distractionAction: distractionActionController.text.trim(),
        climbingSafety: climbingSafetyController.text.trim(),
        name: nameController.text.trim(),
        acknowledgmentDate: acknowledgmentDate,
        signature: signatureFile,
        createdBy: userId,
        createdOn: DateTime.now(),
      );

      print("Submitting form...");
      print("Signature file: ${signatureFile?.path}");

      final success =
          await CouplingUncouplingQuestionnaireModel.submitForm(model);

      if (!success) {
        _showErrorDialog(
            context, 'Failed to submit the form. Please try again.');
      }

      return success;
    } catch (e, stack) {
      print("Submit error: $e");
      print(stack);
      _showErrorDialog(
          context, 'An unexpected error occurred. Please try again later.');
      return false;
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}
