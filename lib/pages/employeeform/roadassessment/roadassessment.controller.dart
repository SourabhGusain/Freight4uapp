import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/employeemodels/driverassessment.model.dart';

class DriverAssessmentController {
  final Session session = Session();
  int userId = 0;

  File? signatureFile;

  final fullNameController = TextEditingController();
  final dateController = TextEditingController();
  final licenceNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final stateOfValidationController = TextEditingController();

  final streetAddressController = TextEditingController();
  final streetAddress2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateOrProvinceController = TextEditingController();
  final postalCodeController = TextEditingController();

  final buddyAssessorNameController = TextEditingController();
  final buddyAssessorDateController = TextEditingController();
  final vehicleTypeController = TextEditingController();
  final gearboxTypeController = TextEditingController();
  final licenceRestrictionsController = TextEditingController();

  final Map<String, TextEditingController> vehicleCheckFields = {
    'Pre-trip Inspection': TextEditingController(),
    'Uncoupling/Coupling Trailer': TextEditingController(),
    'Load Securing': TextEditingController(),
    'Engine Idle Time': TextEditingController(),
    'Mirror Use': TextEditingController(),
    'Clutch Use': TextEditingController(),
    'Gear Selection': TextEditingController(),
    'Rev Range': TextEditingController(),
    'Engine Brake/Retarder Use': TextEditingController(),
    'Check Intersections': TextEditingController(),
    'Courtesy to Others': TextEditingController(),
    'Observation/Planning': TextEditingController(),
    'Overtaking': TextEditingController(),
    'Speed for Environment': TextEditingController(),
    'Hang Back Distance': TextEditingController(),
    'Road Law': TextEditingController(),
    'Cornering': TextEditingController(),
    'Roundabout': TextEditingController(),
    'Reversing': TextEditingController(),
    'Last 100 Metres': TextEditingController(),
    'At Destination': TextEditingController(),
    'Paper Work': TextEditingController(),
  };

  Future<void> init() async {
    final userIdStr = await session.getSession("userId");
    userId = int.tryParse(userIdStr ?? "") ?? 0;
    // populateDummyData();
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

  Future<void> populateFromSession() async {
    final userJson = await session.getSession('loggedInUser');
    if (userJson == null) return;

    final Map<String, dynamic> userData = jsonDecode(userJson);

    fullNameController.text = userData["name"] ?? "";
    licenceNumberController.text =
        userData["licence_number"] ?? userData["license_number"] ?? "";

    // Use ISO 8601 format for consistency with model
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
        licenceNumberController.text.trim().isEmpty ||
        expiryDateController.text.trim().isEmpty) {
      print('Please fill in all required fields.');
      return false;
    }

    try {
      parseDate(dateController.text.trim());
      parseDate(expiryDateController.text.trim());
      parseDate(buddyAssessorDateController.text.trim());
    } catch (e) {
      print('Invalid date format.');
      return false;
    }

    return true;
  }

  Future<bool> submitForm() async {
    if (!validateFields()) {
      return false;
    }

    final model = DriverAssessmentModel(
      name: fullNameController.text.trim(),
      date: parseDate(dateController.text.trim()),
      licenceNumber: licenceNumberController.text.trim(),
      expiryDate: parseDate(expiryDateController.text.trim()),
      stateOfValidation: stateOfValidationController.text.trim(),
      streetAddress: streetAddressController.text.trim(),
      streetAddress2: streetAddress2Controller.text.trim(),
      city: cityController.text.trim(),
      stateOrProvince: stateOrProvinceController.text.trim(),
      postalCode: postalCodeController.text.trim(),
      buddyAssessorName: buddyAssessorNameController.text.trim(),
      buddyAssessorDate: parseDate(buddyAssessorDateController.text.trim()),
      vehicleType: vehicleTypeController.text.trim(),
      gearboxType: gearboxTypeController.text.trim(),
      licenceRestrictions: licenceRestrictionsController.text.trim(),
      signature: signatureFile,
      preTripInspection:
          vehicleCheckFields['Pre-trip Inspection']?.text.trim() ?? 'N/A',
      uncouplingCouplingTrailer:
          vehicleCheckFields['Uncoupling/Coupling Trailer']?.text.trim() ??
              'N/A',
      loadSecuring: vehicleCheckFields['Load Securing']?.text.trim() ?? 'N/A',
      engineIdleTime:
          vehicleCheckFields['Engine Idle Time']?.text.trim() ?? 'N/A',
      mirrorUse: vehicleCheckFields['Mirror Use']?.text.trim() ?? 'N/A',
      clutchUse: vehicleCheckFields['Clutch Use']?.text.trim() ?? 'N/A',
      gearSelection: vehicleCheckFields['Gear Selection']?.text.trim() ?? 'N/A',
      revRange: vehicleCheckFields['Rev Range']?.text.trim() ?? 'N/A',
      engineBrakeRetarderUse:
          vehicleCheckFields['Engine Brake/Retarder Use']?.text.trim() ?? 'N/A',
      checkIntersections:
          vehicleCheckFields['Check Intersections']?.text.trim() ?? 'N/A',
      courtesyToOthers:
          vehicleCheckFields['Courtesy to Others']?.text.trim() ?? 'N/A',
      observationPlanning:
          vehicleCheckFields['Observation/Planning']?.text.trim() ?? 'N/A',
      overtaking: vehicleCheckFields['Overtaking']?.text.trim() ?? 'N/A',
      speedForEnvironment:
          vehicleCheckFields['Speed for Environment']?.text.trim() ?? 'N/A',
      hangBackDistance:
          vehicleCheckFields['Hang Back Distance']?.text.trim() ?? 'N/A',
      roadLaw: vehicleCheckFields['Road Law']?.text.trim() ?? 'N/A',
      cornering: vehicleCheckFields['Cornering']?.text.trim() ?? 'N/A',
      roundabout: vehicleCheckFields['Roundabout']?.text.trim() ?? 'N/A',
      reversing: vehicleCheckFields['Reversing']?.text.trim() ?? 'N/A',
      last100Metres:
          vehicleCheckFields['Last 100 Metres']?.text.trim() ?? 'N/A',
      atDestination: vehicleCheckFields['At Destination']?.text.trim() ?? 'N/A',
      paperWork: vehicleCheckFields['Paper Work']?.text.trim() ?? 'N/A',
      isActive: true,
      createdOn: DateTime.now(),
      createdBy: userId,
    );

    final success = await DriverAssessmentModel.submitForm(model);

    if (!success) {
      print('Failed to submit form.');
    }

    return success;
  }

  void dispose() {
    fullNameController.dispose();
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

    vehicleCheckFields.forEach((_, controller) => controller.dispose());
  }
}
