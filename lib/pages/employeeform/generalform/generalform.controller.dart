import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/employeemodels/generalfrom.model.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/pages/employeeform/employeeform.view.dart';

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
  final nameOfInstitutionController = TextEditingController();
  final accountNumberController = TextEditingController();
  final branchBSBController = TextEditingController();

  // Superfund
  final superfundController = TextEditingController();
  final superfundNumberController = TextEditingController();
  final superfundAccountNameController = TextEditingController();
  final superfundBranchBSBController = TextEditingController();
  final superfundAccountNumberController = TextEditingController();

  final sitesPreviouslyWorkedController = TextEditingController();
  final colesInductionController = TextEditingController();
  final startDateController = TextEditingController();
  final expiryDateController = TextEditingController();
  final lastEmployerIn24MonthsController = TextEditingController();
  final reasonForLeavingController = TextEditingController();

  // Reference
  final referenceNameController = TextEditingController();
  final referenceLastNameController = TextEditingController();
  final referencePhoneNumberController = TextEditingController();

  int userId = 0;
  final Session session = Session();

  Future<void> init() async {
    try {
      String? userId = await session.getSession("userId");
      print(userId);
    } catch (e) {
      print('Failed to load settings: $e');
    }
  }

  Future<void> populateFromSession(Session session) async {
    final userJsonString = await session.getSession('loggedInUser');
    if (userJsonString == null) return;

    try {
      final Map<String, dynamic> userData = jsonDecode(userJsonString);
      nameController.text = userData["name"] ?? "";
      phoneController.text = userData["phone"] ?? "";
      emailController.text = userData["email"] ?? "";
      passwordController.text = userData["password"] ?? "";
    } catch (e) {
      print('Failed to parse session user data: $e');
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
        nameOfInstitutionController,
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
        lastEmployerIn24MonthsController,
        reasonForLeavingController,
        referenceNameController,
        referenceLastNameController,
        referencePhoneNumberController,
      ];

  Future<void> submitGeneralForm(BuildContext context) async {
    final data = {
      "name": nameController.text,
      "date_of_birth": dateOfBirthController.text,
      "street_address": streetAddressController.text,
      "street_address_line_2": streetAddressLine2Controller.text,
      "city": cityController.text,
      "state": stateController.text,
      "zip_code": zipCodeController.text,
      "area_code": areaCodeController.text,
      "phone": phoneController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "tnf": tnfController.text,
      "emergency_name": emergencyNameController.text,
      "emergency_relationship": emergencyRelationshipController.text,
      "emergency_area_code": emergencyAreaCodeController.text,
      "emergency_phone": emergencyPhoneController.text,
      "emergency_street_address": emergencyStreetAddressController.text,
      "emergency_street_address_line_2":
          emergencyStreetAddressLine2Controller.text,
      "emergency_city": emergencyCityController.text,
      "emergency_state": emergencyStateController.text,
      "emergency_zip_code": emergencyZipCodeController.text,
      "name_of_institution": nameOfInstitutionController.text,
      "account_number": accountNumberController.text,
      "branch_bsb": branchBSBController.text,
      "superfund": superfundController.text,
      "superfund_number": superfundNumberController.text,
      "superfund_account_name": superfundAccountNameController.text,
      "superfund_branch_bsb": superfundBranchBSBController.text,
      "superfund_account_number": superfundAccountNumberController.text,
      "sites_previously_worked": sitesPreviouslyWorkedController.text,
      "coles_induction": colesInductionController.text,
      "start_date": startDateController.text,
      "expiry_date": expiryDateController.text,
      "last_employer_in_24_months": lastEmployerIn24MonthsController.text,
      "reason_for_leaving": reasonForLeavingController.text,
      "reference_name": referenceNameController.text,
      "reference_last_name": referenceLastNameController.text,
      "reference_phone_number": referencePhoneNumberController.text,
      "is_active": true,
      "created_on": DateTime.now().toIso8601String()
    };

    print("🚀 SUBMITTING GENERAL FORM DATA:");
    print(data); // <--- This will print full payload to debug console

    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        dateOfBirthController.text.trim().isEmpty ||
        streetAddressController.text.trim().isEmpty ||
        cityController.text.trim().isEmpty ||
        stateController.text.trim().isEmpty ||
        zipCodeController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Missing Information"),
          content:
              Text("Please fill in all required fields before submitting."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final formModel = GeneralFormModel(
      name: nameController.text,
      dateOfBirth: dateOfBirthController.text,
      streetAddress: streetAddressController.text,
      streetAddressLine2: streetAddressLine2Controller.text,
      city: cityController.text,
      state: stateController.text,
      zipCode: zipCodeController.text,
      areaCode: areaCodeController.text,
      phone: phoneController.text,
      email: emailController.text,
      password: passwordController.text,
      tnf: tnfController.text,
      emergencyName: emergencyNameController.text,
      emergencyRelationship: emergencyRelationshipController.text,
      emergencyAreaCode: emergencyAreaCodeController.text,
      emergencyPhone: emergencyPhoneController.text,
      emergencyStreetAddress: emergencyStreetAddressController.text,
      emergencyStreetAddressLine2: emergencyStreetAddressLine2Controller.text,
      emergencyCity: emergencyCityController.text,
      emergencyState: emergencyStateController.text,
      emergencyZipCode: emergencyZipCodeController.text,
      nameOfInstitution: nameOfInstitutionController.text,
      accountNumber: accountNumberController.text,
      branchBsb: branchBSBController.text,
      superfund: superfundController.text,
      superfundNumber: superfundNumberController.text,
      superfundAccountName: superfundAccountNameController.text,
      superfundBranchBsb: superfundBranchBSBController.text,
      superfundAccountNumber: superfundAccountNumberController.text,
      sitesPreviouslyWorked: sitesPreviouslyWorkedController.text,
      colesInduction: colesInductionController.text,
      startDate: startDateController.text,
      expiryDate: expiryDateController.text,
      lastEmployerIn24Months: lastEmployerIn24MonthsController.text,
      reasonForLeaving: reasonForLeavingController.text,
      referenceName: referenceNameController.text,
      referenceLastName: referenceLastNameController.text,
      referencePhoneNumber: referencePhoneNumberController.text,
      createdBy: userId,
      createdOn: DateTime.now().toIso8601String(),
      isActive: true,
    );

    bool success = await postForm(formModel);
    Navigator.pop(context);

    if (success) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Success"),
          content: Text("Form submitted successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Get.to(context, () => EmployeePage(session: session));
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Failed to submit form. Please try again."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}
