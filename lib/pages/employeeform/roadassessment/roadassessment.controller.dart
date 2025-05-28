import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/employeemodels/roadassessment.model.dart';

class DriverAssessmentController {
  final Session _session = Session();
  int userId = 0;

  // Signature
  File? signatureFile;

  // Text controllers for personal info
  final fullNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dateController = TextEditingController();
  final licenceNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final stateOfValidationController = TextEditingController();

  // Address
  final streetAddressController = TextEditingController();
  final streetAddress2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateOrProvinceController = TextEditingController();
  final postalCodeController = TextEditingController();

  // Assessment info
  final buddyAssessorNameController = TextEditingController();
  final buddyAssessorDateController = TextEditingController();
  final vehicleTypeController = TextEditingController();
  final gearboxTypeController = TextEditingController();
  final licenceRestrictionsController = TextEditingController();

  // Driving behavior fields
  final preTripInspectionController = TextEditingController();
  final uncouplingCouplingTrailerController = TextEditingController();
  final loadSecuringController = TextEditingController();
  final engineIdleTimeController = TextEditingController();
  final mirrorUseController = TextEditingController();
  final clutchUseController = TextEditingController();
  final gearSelectionController = TextEditingController();
  final revRangeController = TextEditingController();
  final engineBrakeRetarderUseController = TextEditingController();
  final checkIntersectionsController = TextEditingController();
  final courtesyToOthersController = TextEditingController();
  final observationPlanningController = TextEditingController();
  final overtakingController = TextEditingController();
  final speedForEnvironmentController = TextEditingController();
  final hangBackDistanceController = TextEditingController();
  final roadLawController = TextEditingController();
  final corneringController = TextEditingController();
  final roundaboutController = TextEditingController();
  final reversingController = TextEditingController();
  final last100MetresController = TextEditingController();
  final atDestinationController = TextEditingController();
  final paperWorkController = TextEditingController();

  // Group the vehicle check fields for easy iteration in the view
  Map<String, TextEditingController> get vehicleCheckFields => {
        'Pre-trip Inspection': preTripInspectionController,
        'Uncoupling/Coupling Trailer': uncouplingCouplingTrailerController,
        'Load Securing': loadSecuringController,
        'Engine Idle Time': engineIdleTimeController,
        'Mirror Use': mirrorUseController,
        'Clutch Use': clutchUseController,
        'Gear Selection': gearSelectionController,
        'Rev Range': revRangeController,
        'Engine Brake/Retarder Use': engineBrakeRetarderUseController,
        'Check Intersections': checkIntersectionsController,
        'Courtesy to Others': courtesyToOthersController,
        'Observation/Planning': observationPlanningController,
        'Overtaking': overtakingController,
        'Speed for Environment': speedForEnvironmentController,
        'Hang Back Distance': hangBackDistanceController,
        'Road Law': roadLawController,
        'Cornering': corneringController,
        'Roundabout': roundaboutController,
        'Reversing': reversingController,
        'Last 100 Metres': last100MetresController,
        'At Destination': atDestinationController,
        'Paper Work': paperWorkController,
      };

  Future<void> init() async {
    final userIdStr = await _session.getSession("userId");
    userId = int.tryParse(userIdStr ?? "") ?? 0;
  }

  Future<void> populateFromSession() async {
    final userJson = await _session.getSession('loggedInUser');
    if (userJson == null) return;

    final Map<String, dynamic> userData = jsonDecode(userJson);
    fullNameController.text = userData['firstName'] ?? '';
    lastNameController.text = userData['lastName'] ?? '';
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> submitForm(BuildContext context) async {
    if (signatureFile == null ||
        fullNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty) {
      _showDialog(
        context,
        "Missing Fields",
        "Please fill out required fields and sign.",
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final model = DriverAssessmentModel(
      name: fullNameController.text.trim(),
      date: dateController.text.trim(),
      licenceNumber: licenceNumberController.text.trim(),
      expiryDate: expiryDateController.text.trim(),
      stateOfValidation: stateOfValidationController.text.trim(),
      streetAddress: streetAddressController.text.trim(),
      streetAddress2: streetAddress2Controller.text.trim(),
      city: cityController.text.trim(),
      stateOrProvince: stateOrProvinceController.text.trim(),
      postalCode: postalCodeController.text.trim(),
      buddyAssessorName: buddyAssessorNameController.text.trim(),
      buddyAssessorDate: buddyAssessorDateController.text.trim(),
      vehicleType: vehicleTypeController.text.trim(),
      gearboxType: gearboxTypeController.text.trim(),
      licenceRestrictions: licenceRestrictionsController.text.trim(),
      signature: signatureFile!,
      preTripInspection: preTripInspectionController.text.trim(),
      uncouplingCouplingTrailer:
          uncouplingCouplingTrailerController.text.trim(),
      loadSecuring: loadSecuringController.text.trim(),
      engineIdleTime: engineIdleTimeController.text.trim(),
      mirrorUse: mirrorUseController.text.trim(),
      clutchUse: clutchUseController.text.trim(),
      gearSelection: gearSelectionController.text.trim(),
      revRange: revRangeController.text.trim(),
      engineBrakeRetarderUse: engineBrakeRetarderUseController.text.trim(),
      checkIntersections: checkIntersectionsController.text.trim(),
      courtesyToOthers: courtesyToOthersController.text.trim(),
      observationPlanning: observationPlanningController.text.trim(),
      overtaking: overtakingController.text.trim(),
      speedForEnvironment: speedForEnvironmentController.text.trim(),
      hangBackDistance: hangBackDistanceController.text.trim(),
      roadLaw: roadLawController.text.trim(),
      cornering: corneringController.text.trim(),
      roundabout: roundaboutController.text.trim(),
      reversing: reversingController.text.trim(),
      last100Metres: last100MetresController.text.trim(),
      atDestination: atDestinationController.text.trim(),
      paperWork: paperWorkController.text.trim(),
      isActive: true,
      createdOn: DateTime.now().toIso8601String(),
      createdBy: userId,
    );

    final success = await DriverAssessmentModel.submitForm(model);
    Navigator.pop(context); // Close loading dialog

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
    fullNameController.dispose();
    lastNameController.dispose();
    dateController.dispose();
    licenceNumberController.dispose();
    expiryDateController.dispose();
    stateOfValidationController.dispose();
    streetAddressController.dispose();
    streetAddress2Controller.dispose();
    cityController.dispose();
    stateOrProvinceController.dispose();
    postalCodeController.dispose();
    buddyAssessorNameController.dispose();
    buddyAssessorDateController.dispose();
    vehicleTypeController.dispose();
    gearboxTypeController.dispose();
    licenceRestrictionsController.dispose();
    preTripInspectionController.dispose();
    uncouplingCouplingTrailerController.dispose();
    loadSecuringController.dispose();
    engineIdleTimeController.dispose();
    mirrorUseController.dispose();
    clutchUseController.dispose();
    gearSelectionController.dispose();
    revRangeController.dispose();
    engineBrakeRetarderUseController.dispose();
    checkIntersectionsController.dispose();
    courtesyToOthersController.dispose();
    observationPlanningController.dispose();
    overtakingController.dispose();
    speedForEnvironmentController.dispose();
    hangBackDistanceController.dispose();
    roadLawController.dispose();
    corneringController.dispose();
    roundaboutController.dispose();
    reversingController.dispose();
    last100MetresController.dispose();
    atDestinationController.dispose();
    paperWorkController.dispose();
  }
}
