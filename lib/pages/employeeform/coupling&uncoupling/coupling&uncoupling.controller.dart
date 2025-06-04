import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/helpers/session.dart';
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
  final TextEditingController lastNameController = TextEditingController();

  // IMPORTANT: For dropdowns, you used TextEditingControllers in the form,
  // so keep them here for consistency.
  final TextEditingController uncouplingSequenceController =
      TextEditingController();
  final TextEditingController couplingSequenceController =
      TextEditingController();

  final TextEditingController acknowledgmentDateController =
      TextEditingController();

  final SignatureController signatureController = SignatureController(
    penColor: Colors.black,
    penStrokeWidth: 3,
    exportBackgroundColor: Colors.white,
  );

  final Session session = Session();
  int userId = 0;

  File? signatureFile;

  Future<void> init() async {
    try {
      final userIdStr = await session.getSession("userId");
      if (userIdStr != null) userId = int.tryParse(userIdStr) ?? 0;

      final userJson = await session.getSession('loggedInUser');
      if (userJson != null) {
        final user = jsonDecode(userJson) as Map<String, dynamic>;
        nameController.text = user["name"] ?? "";
        lastNameController.text = user["lastName"] ?? "";
      }

      acknowledgmentDateController.text =
          DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Set default dropdown selections if empty
      if (uncouplingSequenceController.text.isEmpty) {
        uncouplingSequenceController.text = 'A';
      }
      if (couplingSequenceController.text.isEmpty) {
        couplingSequenceController.text = 'A';
      }
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
    lastNameController.dispose();
    uncouplingSequenceController.dispose();
    couplingSequenceController.dispose();
    acknowledgmentDateController.dispose();
    signatureController.dispose();
  }

  bool validateInputs() {
    final hasName = nameController.text.trim().isNotEmpty;
    final hasLastName = lastNameController.text.trim().isNotEmpty;
    final hasDate = acknowledgmentDateController.text.trim().isNotEmpty;
    final hasSignature = !signatureController.isEmpty;

    if (!hasName || !hasLastName || !hasDate || !hasSignature) {
      print(
          "Validation failed. Name: $hasName, LastName: $hasLastName, Date: $hasDate, Signature: $hasSignature");
    }

    return hasName && hasLastName && hasDate && hasSignature;
  }

  Future<bool> submitForm(BuildContext context) async {
    if (!validateInputs()) {
      _showErrorDialog(
          context, 'Validation failed. Please fill all required fields.');
      return false;
    }

    try {
      final acknowledgmentDate =
          DateFormat('yyyy-MM-dd').parse(acknowledgmentDateController.text);

      final Uint8List? signatureBytes = await signatureController.toPngBytes();

      if (signatureBytes == null || signatureBytes.isEmpty) {
        _showErrorDialog(
            context, 'Signature data is empty. Please sign the form.');
        return false;
      }

      final tempFile = File(
          '${Directory.systemTemp.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png');
      await tempFile.writeAsBytes(signatureBytes);
      signatureFile = tempFile;

      final model = CouplingUncouplingQuestionnaireModel(
        risksIdentified: risksIdentifiedController.text.trim(),
        safetyControls: safetyControlsController.text.trim(),
        faultAction: faultActionController.text.trim(),
        uncouplingSequence: uncouplingSequenceController.text.trim(),
        postUnpinAction: postUnpinActionController.text.trim(),
        couplingSequence: couplingSequenceController.text.trim(),
        airLeadsTwist: airLeadsTwistController.text.trim(),
        tugTestsCount: tugTestsCountController.text.trim(),
        distractionAction: distractionActionController.text.trim(),
        climbingSafety: climbingSafetyController.text.trim(),
        name: nameController.text.trim(),
        lastName: lastNameController.text.trim(),
        acknowledgmentDate: acknowledgmentDate,
        signature: signatureFile,
        createdBy: userId,
        createdOn: DateTime.now(),
      );

      print("Submitting Coupling/Uncoupling Questionnaire Form...");
      print(
          "Signature file path: ${model.signature?.path ?? 'No signature file'}");

      final success =
          await CouplingUncouplingQuestionnaireModel.submitForm(model);

      if (!success) {
        _showErrorDialog(
            context, 'Failed to submit the form. Please try again.');
      }

      return success;
    } catch (e, stacktrace) {
      print("Submit error: $e");
      print(stacktrace);
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
