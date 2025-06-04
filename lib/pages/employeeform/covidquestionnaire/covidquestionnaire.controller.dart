import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/employeemodels/covidquestionnaire.model.dart';

class CovidQuestionnaireController {
  final Session session = Session();
  int userId = 0;

  File? signatureFile;

  // Text controllers
  final fullNameController = TextEditingController();
  final dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );

  late Map<String, String> yesNoOptions;

  String? vehiclesDisinfected;
  String? continueShiftThenIsolate;
  String? disinfectBeforeOnly;
  String? eatLunchOutside;
  String? noUnsafeDelivery;

  CovidQuestionnaireController() {
    _loadChoices();
  }

  void _loadChoices() {
    yesNoOptions = {
      'yes': 'yes',
      'no': 'no',
    };
  }

  Future<void> init() async {
    final userIdStr = await session.getSession("userId");
    userId = int.tryParse(userIdStr ?? "") ?? 0;
  }

  Future<void> populateFromSession() async {
    final userJson = await session.getSession('loggedInUser');
    if (userJson == null) return;

    final Map<String, dynamic> userData = jsonDecode(userJson);
    fullNameController.text = userData["name"] ?? "";
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
        dateController.text.trim().isEmpty) {
      print('Please fill in all required fields.');
      return false;
    }

    final selectionFields = [
      vehiclesDisinfected,
      continueShiftThenIsolate,
      disinfectBeforeOnly,
      eatLunchOutside,
      noUnsafeDelivery,
    ];

    if (selectionFields.any((item) => item == null || item.trim().isEmpty)) {
      print('Please answer all questionnaire items.');
      return false;
    }

    try {
      DateFormat('yyyy-MM-dd').parse(dateController.text.trim());
    } catch (e) {
      print('Invalid date format.');
      return false;
    }

    return true;
  }

  Future<bool> submitCovidQuestionnaireForm() async {
    if (!validateFields()) return false;

    final model = CovidQuestionnaireModel(
      name: fullNameController.text.trim(),
      date: dateController.text.trim(),
      vehiclesDisinfected: vehiclesDisinfected!,
      continueShiftThenIsolate: continueShiftThenIsolate!,
      disinfectBeforeOnly: disinfectBeforeOnly!,
      eatLunchOutside: eatLunchOutside!,
      noUnsafeDelivery: noUnsafeDelivery!,
      signature: signatureFile,
      isActive: true,
      createdOn: DateTime.now().toIso8601String(),
      createdBy: userId,
    );

    final success = await CovidQuestionnaireModel.submitForm(model);
    print('Submission status: $success');
    return success;
  }

  void reset() {
    fullNameController.clear();
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    signatureFile = null;

    vehiclesDisinfected = null;
    continueShiftThenIsolate = null;
    disinfectBeforeOnly = null;
    eatLunchOutside = null;
    noUnsafeDelivery = null;
  }

  void dispose() {
    fullNameController.dispose();
    dateController.dispose();
  }
}
