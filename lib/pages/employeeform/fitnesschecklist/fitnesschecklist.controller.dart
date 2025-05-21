import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/employeemodels/fitnesschecklist.model.dart';

class FitnessChecklistController {
  final driverNameController = TextEditingController();
  final dateController = TextEditingController();

  File? signatureFile;
  int userId = 0;

  final fitForDutyController = TextEditingController();
  final mentallyFitController = TextEditingController();
  final freeFromTirednessController = TextEditingController();
  final freeFromRecreationalFatigueController = TextEditingController();
  final visualAcuityOkController = TextEditingController();
  final medicalIncidentReportedController = TextEditingController();
  final recentIncidentsAgeRelatedDeclineController = TextEditingController();
  final periodicDriverMedicalExaminationsController = TextEditingController();
  final availableRestAreasAndAmenitiesController = TextEditingController();
  final receiveWelfareChecksController = TextEditingController();
  final suitableVentilatedAirConditionedController = TextEditingController();
  final bloodAlcoholLevelController = TextEditingController();
  final breathSkillsTestController = TextEditingController();
  final drugsOrMedicationController = TextEditingController();
  final counterDrugsController = TextEditingController();
  final minimumContinuousBreakController = TextEditingController();
  final nonWorkTimeController = TextEditingController();
  final workADayController = TextEditingController();
  final restFor30MinutesController = TextEditingController();
  final validLicenceClassController = TextEditingController();

  final Session session = Session();

  Future<void> init() async {
    try {
      String? userIdStr = await session.getSession("userId");
      if (userIdStr != null) {
        userId = int.tryParse(userIdStr) ?? 0;
      }
    } catch (e) {
      print("Session init error: $e");
    }
  }

  Future<void> populateFromSession(Session session) async {
    final userJson = await session.getSession('loggedInUser');
    if (userJson == null) return;

    try {
      final Map<String, dynamic> userData = jsonDecode(userJson);
      driverNameController.text = userData["name"] ?? "";
      dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

      for (var controller in [
        fitForDutyController,
        mentallyFitController,
        freeFromTirednessController,
        freeFromRecreationalFatigueController,
        visualAcuityOkController,
        medicalIncidentReportedController,
        recentIncidentsAgeRelatedDeclineController,
        periodicDriverMedicalExaminationsController,
        availableRestAreasAndAmenitiesController,
        receiveWelfareChecksController,
        suitableVentilatedAirConditionedController,
        bloodAlcoholLevelController,
        breathSkillsTestController,
        drugsOrMedicationController,
        counterDrugsController,
        minimumContinuousBreakController,
        nonWorkTimeController,
        workADayController,
        restFor30MinutesController,
        validLicenceClassController,
      ]) {
        controller.text = "";
      }
    } catch (e) {
      print("Session population error: $e");
    }
  }

  Future<void> submitChecklist(BuildContext context) async {
    if (driverNameController.text.trim().isEmpty ||
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

    final model = FitnessChecklistModel(
      driverName: driverNameController.text.trim(),
      dateOf: dateController.text.trim(),
      signature: signatureFile!,
      fitForDuty: fitForDutyController.text.trim(),
      mentallyFit: mentallyFitController.text.trim(),
      freeFromTiredness: freeFromTirednessController.text.trim(),
      freeFromRecreationalFatigue:
          freeFromRecreationalFatigueController.text.trim(),
      visualAcuityOk: visualAcuityOkController.text.trim(),
      medicalIncidentReported: medicalIncidentReportedController.text.trim(),
      recentIncidentsAgeRelatedDecline:
          recentIncidentsAgeRelatedDeclineController.text.trim(),
      periodicDriverMedicalExaminations:
          periodicDriverMedicalExaminationsController.text.trim(),
      availableRestAreasAndAmenities:
          availableRestAreasAndAmenitiesController.text.trim(),
      receiveWelfareChecks: receiveWelfareChecksController.text.trim(),
      suitableVentilatedAirConditioned:
          suitableVentilatedAirConditionedController.text.trim(),
      bloodAlcoholLevel: bloodAlcoholLevelController.text.trim(),
      breathSkillsTest: breathSkillsTestController.text.trim(),
      drugsOrMedication: drugsOrMedicationController.text.trim(),
      counterDrugs: counterDrugsController.text.trim(),
      minimumContinuousBreak: minimumContinuousBreakController.text.trim(),
      nonWorkTime: nonWorkTimeController.text.trim(),
      workADay: workADayController.text.trim(),
      restFor30Minutes: restFor30MinutesController.text.trim(),
      validLicenceClass: validLicenceClassController.text.trim(),
      isActive: true,
      createdOn: DateTime.now().toIso8601String(),
      createdBy: userId,
    );

    final success = await FitnessChecklistModel.submitChecklist(model);
    Navigator.pop(context);

    if (success) {
      _showDialog(
        context,
        "Success",
        "Fitness checklist submitted successfully.",
        onOk: () => Navigator.of(context).pop(),
      );
    } else {
      _showDialog(context, "Error", "Failed to submit the form.");
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
          )
        ],
      ),
    );
  }

  void dispose() {
    for (var controller in [
      driverNameController,
      dateController,
      fitForDutyController,
      mentallyFitController,
      freeFromTirednessController,
      freeFromRecreationalFatigueController,
      visualAcuityOkController,
      medicalIncidentReportedController,
      recentIncidentsAgeRelatedDeclineController,
      periodicDriverMedicalExaminationsController,
      availableRestAreasAndAmenitiesController,
      receiveWelfareChecksController,
      suitableVentilatedAirConditionedController,
      bloodAlcoholLevelController,
      breathSkillsTestController,
      drugsOrMedicationController,
      counterDrugsController,
      minimumContinuousBreakController,
      nonWorkTimeController,
      workADayController,
      restFor30MinutesController,
      validLicenceClassController,
    ]) {
      controller.dispose();
    }
  }
}
