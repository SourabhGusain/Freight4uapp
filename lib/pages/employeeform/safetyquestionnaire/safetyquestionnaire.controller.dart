import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/employeemodels/safetyquestionnaire.model.dart';

class WorkHealthSafetyQuestionnaireController {
  final Session session = Session();
  int userId = 0;

  File? signatureFile;

  final fullNameController = TextEditingController();
  final dateController = TextEditingController();
  final locationController = TextEditingController();

  // Dropdown values for form
  String workerDefinition = '';
  String pcbuDefinition = '';
  String workerDuty = '';
  String failureRiskAssessment = '';
  String mechanicalFaultAction = '';
  String nonComplianceConsequences = '';
  String pcbuDutyOfCare = '';
  String failingHazardRiskAssessment = '';
  String failingReportRisks = '';
  String hierarchyOfControlUsed = '';
  String eliminationRiskStrength = '';
  String colleagueAffectedAlcohol = '';
  String safeWorkAdviceContact = '';
  String nonComplianceLinfox = '';
  String nonComplianceWHSAct = '';
  String stopUnsafeWork = '';

  Future<void> init() async {
    final userIdStr = await session.getSession("userId");
    userId = int.tryParse(userIdStr ?? "") ?? 0;
  }

  DateTime parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      print(
          'Warning: Failed to parse date "$dateStr". Using DateTime.now() instead.');
      return DateTime.now();
    }
  }

  Future<void> setSignature(Uint8List signatureBytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/signature.png');
    await file.writeAsBytes(signatureBytes);
    signatureFile = file;
  }

  bool validateFields() {
    if (signatureFile == null) {
      print('Signature is required.');
      return false;
    }
    if (fullNameController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty) {
      print('Please fill in all required fields.');
      return false;
    }

    final choices = [
      workerDefinition,
      pcbuDefinition,
      workerDuty,
      failureRiskAssessment,
      mechanicalFaultAction,
      nonComplianceConsequences,
      pcbuDutyOfCare,
      failingHazardRiskAssessment,
      failingReportRisks,
      hierarchyOfControlUsed,
      eliminationRiskStrength,
      colleagueAffectedAlcohol,
      safeWorkAdviceContact,
      nonComplianceLinfox,
      nonComplianceWHSAct,
      stopUnsafeWork,
    ];
    if (choices.any((choice) => choice.isEmpty)) {
      print('Please select all required options.');
      return false;
    }

    try {
      parseDate(dateController.text.trim());
    } catch (e) {
      print('Invalid date format.');
      return false;
    }

    return true;
  }

  Future<bool> submitForm() async {
    if (!validateFields()) return false;

    final model = WorkHealthSafetyQuestionnaireModel(
      name: fullNameController.text.trim(),
      date: dateController.text.trim(),
      workerDefinition: workerDefinition,
      pcbuDefinition: pcbuDefinition,
      workerDuty: workerDuty,
      failureRiskAssessment: failureRiskAssessment,
      mechanicalFaultAction: mechanicalFaultAction,
      nonComplianceConsequences: nonComplianceConsequences,
      pcbuDutyOfCare: pcbuDutyOfCare,
      failingHazardRiskAssessment: failingHazardRiskAssessment,
      failingReportRisks: failingReportRisks,
      hierarchyOfControlUsed: hierarchyOfControlUsed,
      eliminationRiskStrength: eliminationRiskStrength,
      colleagueAffectedAlcohol: colleagueAffectedAlcohol,
      safeWorkAdviceContact: safeWorkAdviceContact,
      nonComplianceLinfox: nonComplianceLinfox,
      nonComplianceWHSAct: nonComplianceWHSAct,
      signature: signatureFile,
      isActive: true,
      createdOn: DateTime.now().toIso8601String(),
      createdBy: userId,
    );

    final success = await WorkHealthSafetyQuestionnaireModel.submitForm(model);
    print('Submission status: $success');
    return success;
  }

  void dispose() {
    fullNameController.dispose();
    dateController.dispose();
    locationController.dispose();
  }
}
