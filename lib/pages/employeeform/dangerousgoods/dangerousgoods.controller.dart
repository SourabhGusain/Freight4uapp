import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/documents.model.dart';
import 'package:Freight4u/models/employeemodels/dangerousgoods.model.dart';

class DangerousGoodsController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final TextEditingController classificationBasisController =
      TextEditingController();
  final TextEditingController packagingGroupsController =
      TextEditingController();
  final TextEditingController subsidiaryRisksLabelingController =
      TextEditingController();
  final TextEditingController adgClassesDivisionsController =
      TextEditingController();
  final TextEditingController competentAuthorityController =
      TextEditingController();
  final TextEditingController transportPreparationStepsController =
      TextEditingController();
  final TextEditingController placardedPassengerExceptionController =
      TextEditingController();
  final TextEditingController emergencyScenarioController =
      TextEditingController();

  final SignatureController signatureController = SignatureController(
    penColor: Colors.black,
    penStrokeWidth: 3,
    exportBackgroundColor: Colors.white,
  );

  final Session session = Session();
  int userId = 0;
  DateTime traineeDate = DateTime.now();

  File? signatureFile;

  List<UploadDocument>? uploadDocuments;

  Future<void> loadUploadDocuments() async {
    uploadDocuments = await fetchUploadDocuments();

    if (uploadDocuments == null || uploadDocuments!.isEmpty) {
      print("No upload documents found or failed to load.");
      return;
    }

    final filteredDocs = uploadDocuments!
        .where((doc) => doc.name == "Dangerous Goods Competency")
        .toList();

    if (filteredDocs.isNotEmpty) {
      final documentLink = filteredDocs.first.documentUrl;
      print("Found 'Dangerous Goods Competency' document: $documentLink");
    } else {
      print("No documents found with name 'Dangerous Goods Competency'.");
    }
  }

  Future<void> init() async {
    try {
      final userIdStr = await session.getSession("userId");
      if (userIdStr != null) userId = int.tryParse(userIdStr) ?? 0;

      final userJson = await session.getSession('loggedInUser');
      if (userJson != null) {
        final user = jsonDecode(userJson) as Map<String, dynamic>;
        nameController.text = user["name"] ?? "";
      }

      dateController.text = DateFormat('yyyy-MM-dd').format(traineeDate);
    } catch (e) {
      print("Init error: $e");
    }
  }

  void dispose() {
    nameController.dispose();
    dateController.dispose();
    classificationBasisController.dispose();
    packagingGroupsController.dispose();
    subsidiaryRisksLabelingController.dispose();
    adgClassesDivisionsController.dispose();
    competentAuthorityController.dispose();
    transportPreparationStepsController.dispose();
    placardedPassengerExceptionController.dispose();
    emergencyScenarioController.dispose();
    signatureController.dispose();
  }

  bool validateInputs() {
    final hasName = nameController.text.trim().isNotEmpty;
    final hasSignature = !signatureController.isEmpty;

    if (!hasName || !hasSignature) {
      print("Validation failed. Name: $hasName, Signature: $hasSignature");
    }

    return hasName && hasSignature;
  }

  Future<bool> submitForm(BuildContext context) async {
    if (!validateInputs()) {
      _showErrorDialog(
          context, 'Validation failed. Please fill all required fields.');
      return false;
    }

    try {
      traineeDate = DateFormat('yyyy-MM-dd').parse(dateController.text);

      final Uint8List? signatureBytes = await signatureController.toPngBytes();

      if (signatureBytes == null || signatureBytes.isEmpty) {
        _showErrorDialog(
            context, 'Signature data is empty. Please sign the form.');
        return false;
      }

      final model = DangerousGoodsCompetencyModel(
        name: nameController.text.trim(),
        date: traineeDate,
        signature: signatureFile,
        classificationBasis: classificationBasisController.text.trim(),
        packagingGroups: packagingGroupsController.text.trim(),
        subsidiaryRisksLabeling: subsidiaryRisksLabelingController.text.trim(),
        adgClassesDivisions: adgClassesDivisionsController.text.trim(),
        competentAuthority: competentAuthorityController.text.trim(),
        transportPreparationSteps:
            transportPreparationStepsController.text.trim(),
        placardedPassengerException:
            placardedPassengerExceptionController.text.trim(),
        emergencyScenario: emergencyScenarioController.text.trim(),
        createdBy: userId,
        createdOn: DateTime.now(),
      );

      print("Submitting Dangerous Goods Competency Form...");
      print(
          "Signature file path: ${model.signature?.path ?? 'No signature file'}");

      final success = await DangerousGoodsCompetencyModel.submitForm(model);

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
