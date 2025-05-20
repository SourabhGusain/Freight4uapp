import 'dart:convert'; // For jsonDecode
import 'package:flutter/material.dart';
import 'package:Freight4u/helpers/session.dart';

class GeneralFormController {
  // Personal Info
  final nameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final streetAddressController = TextEditingController();
  final streetAddressLine2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();
  final areaCodeController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final tnfController = TextEditingController();

  // Emergency Contact
  final emergencyNameController = TextEditingController();
  final emergencyRelationshipController = TextEditingController();
  final emergencyAreaCodeController = TextEditingController();
  final emergencyPhoneController = TextEditingController();
  final emergencyStreetAddressController = TextEditingController();
  final emergencyStreetAddressLine2Controller = TextEditingController();
  final emergencyCityController = TextEditingController();
  final emergencyStateController = TextEditingController();
  final emergencyZipCodeController = TextEditingController();

  // Bank Details
  final institutionNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final branchBSBController = TextEditingController();

  // Superfund
  final superfundController = TextEditingController();
  final superfundNumberController = TextEditingController();
  final superfundAccountNameController = TextEditingController();
  final superfundBranchBSBController = TextEditingController();
  final superfundAccountNumberController = TextEditingController();

  // Employment History
  final sitesPreviouslyWorkedController = TextEditingController();
  final colesInductionController = TextEditingController();
  final startDateController = TextEditingController();
  final expiryDateController = TextEditingController();
  final lastEmployerController = TextEditingController();
  final reasonForLeavingController = TextEditingController();

  // Reference
  final referenceNameController = TextEditingController();
  final referenceLastNameController = TextEditingController();
  final referencePhoneNumberController = TextEditingController();

  Future<void> populateFromSession(Session session) async {
    final userJsonString = await session.getSession('loggedInUser');
    print(userJsonString);

    if (userJsonString == null) return;

    try {
      final Map<String, dynamic> userData = jsonDecode(userJsonString);
      nameController.text = userData["name"] ?? "";
      phoneController.text = userData["phone"] ?? "";
      emailController.text = userData["email"] ?? "";
    } catch (e) {
      print('Failed to parse userJsonString as JSON: $e');
    }
  }

  void dispose() {
    for (var controller in _allControllers) {
      controller.dispose();
    }
  }

  List<TextEditingController> get _allControllers => [
        nameController,
        dateOfBirthController,
        streetAddressController,
        streetAddressLine2Controller,
        cityController,
        stateController,
        zipCodeController,
        areaCodeController,
        phoneController,
        emailController,
        passwordController,
        tnfController,
        emergencyNameController,
        emergencyRelationshipController,
        emergencyAreaCodeController,
        emergencyPhoneController,
        emergencyStreetAddressController,
        emergencyStreetAddressLine2Controller,
        emergencyCityController,
        emergencyStateController,
        emergencyZipCodeController,
        institutionNameController,
        accountNumberController,
        branchBSBController,
        superfundController,
        superfundNumberController,
        superfundAccountNameController,
        superfundBranchBSBController,
        superfundAccountNumberController,
        sitesPreviouslyWorkedController,
        colesInductionController,
        startDateController,
        expiryDateController,
        lastEmployerController,
        reasonForLeavingController,
        referenceNameController,
        referenceLastNameController,
        referencePhoneNumberController,
      ];
}
