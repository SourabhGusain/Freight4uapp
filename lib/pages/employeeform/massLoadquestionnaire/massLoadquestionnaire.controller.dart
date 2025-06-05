import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';

import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/employeemodels/massLoadquestionnaire.model.dart';

class MassLoadRestraintQuestionnaireController {
  final Session session = Session();

  // Answers
  bool? question1;
  String? question2;
  String? question3;
  bool? question4;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  late SignatureController signatureController;

  DateTime date = DateTime.now();
  int userId = 0;

  final Map<String, String> QUESTION1_CHOICES = {
    'Yes': 'Yes',
    'No': 'No',
  };

  final Map<String, String> QUESTION2_CHOICES = {
    'A': 'Spread close to the centre line.',
    'B': 'Kept as low as possible.',
    'C': 'Heavier items positioned near the bottom.',
    'D':
        'On a rigid vehicle, if a very heavy small load is placed against the headboard, it could cause the chassis to bend. Very heavy small loads should be placed just ahead of the rear axle and blocked properly.',
    'E': 'All of the above.',
  };

  final Map<String, String> QUESTION3_CHOICES = {
    'Loading':
        'A. Issues related to the way the load was placed or secured initially.',
    'Goods':
        'B. Problems originating from the nature or condition of the goods themselves.',
    'Driver':
        'C. Actions or inactions of the driver that contribute to a failure of load restraint.',
    'Restraint':
        'D. Failures or inadequacies of the equipment or methods used to restrain the load.',
  };

  final Map<String, String> QUESTION4_CHOICES = {
    'Yes': 'Yes',
    'No': 'No',
  };

  Future<void> init() async {
    try {
      final userIdStr = await session.getSession("userId");
      if (userIdStr != null) {
        userId = int.tryParse(userIdStr) ?? 0;
      }

      final userJsonString = await session.getSession('loggedInUser');
      if (userJsonString != null) {
        final userData = jsonDecode(userJsonString) as Map<String, dynamic>;
        nameController.text = userData["name"] ?? "";
      }

      dateController.text = DateFormat('yyyy-MM-dd').format(date);

      signatureController = SignatureController(
        penColor: Colors.black,
        penStrokeWidth: 3,
        exportBackgroundColor: Colors.white,
      );
    } catch (e) {
      print("MassLoadRestraintController init error: $e");
    }
  }

  void setDate(DateTime selectedDate) {
    date = selectedDate;
    dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
  }

  void clearSignature() {
    signatureController.clear();
  }

  void dispose() {
    nameController.dispose();
    dateController.dispose();
    signatureController.dispose();
  }

  bool validateInputs() {
    final questionsFilled = [
      question1,
      question2,
      question3,
      question4,
    ].every((q) => q != null);

    final nameFilled = nameController.text.trim().isNotEmpty;
    final signaturePresent = !signatureController.isEmpty;

    print("Validation - all questions filled: $questionsFilled");
    print("Name filled: $nameFilled");
    print("Signature present: $signaturePresent");

    return questionsFilled && nameFilled && signaturePresent;
  }

  Future<void> populateFromSession() async {
    final userJson = await session.getSession('loggedInUser');
    if (userJson == null) return;

    final Map<String, dynamic> userData = jsonDecode(userJson);
    nameController.text = userData["name"] ?? "";
  }

  Future<bool> submitForm() async {
    if (!validateInputs()) {
      print("Form invalid: Missing fields or empty signature.");
      return false;
    }

    final Uint8List? signatureBytes = await signatureController.toPngBytes();
    if (signatureBytes == null) {
      print("Signature export failed.");
      return false;
    }

    final fileName = 'signature_${DateTime.now().millisecondsSinceEpoch}.png';
    final signatureFile = File('${Directory.systemTemp.path}/$fileName');
    await signatureFile.writeAsBytes(signatureBytes);

    try {
      final model = MassLoadRestraintQuestionnaireModel(
        question1: question1 == true ? 'Yes' : 'No',
        question2: question2!,
        question3: question3!,
        question4: question4 == true ? 'Yes' : 'No',
        name: nameController.text.trim(),
        date: date,
        signature: signatureFile,
        createdOn: DateTime.now(),
        createdBy: userId,
      );

      return await MassLoadRestraintQuestionnaireModel
          .submitMassLoadRestraintQuestionnaireForm(model);
    } catch (e) {
      print("Form submission error: $e");
      return false;
    }
  }
}
