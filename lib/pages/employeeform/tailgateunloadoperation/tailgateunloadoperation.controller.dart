import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/employeemodels/tailgateunloadoperation.model.dart';

class TailgateUnloadOperationController {
  final Session session = Session();

  // Answers stored as Strings (matching model)
  bool? question1;
  String? question2;
  String? question3;
  bool? question4;
  String? question5;
  bool? question6;
  String? question7;
  bool? question8;
  bool? question9;
  String? question10;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  late SignatureController signatureController;

  DateTime date = DateTime.now();
  int userId = 0;

  final Map<String, String> UNLOAD_ANSWERS = {
    'yes': 'Yes',
    'no': 'No',
  };

  final Map<String, String> TAILGATE_POSITION_CHOICES = {
    'slightly_tilted': 'Tilted slightly up by a couple of degrees',
    'tilted_down': 'Tilted down',
    'not_tilted': 'Not tilted at all',
  };

  final Map<String, String> DISTANCE_CHOICES = {
    '300': '300mm',
    '280': '280mm',
    '250': '250mm',
    '200': '200mm',
  };

  final Map<String, String> PALLET_CHOICES = {
    '1': 'One',
    '2': 'Two',
    '3': 'Three',
    '4': 'Four',
  };

  final Map<String, String> INCIDENT_REPORT_CHOICES = {
    'next_day': 'The next day',
    'couple_hours': 'A couple hours later.',
    'not_needed': "You don't need to.",
    'immediately': 'Immediately to your supervisor.',
  };

  final Map<String, String> PUBLIC_AREA_ACTION_CHOICES = {
    'continue': 'Continue unloading.',
    'stop': 'Stop the unload.',
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
      print("TailgateUnloadOperationController init error: $e");
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
      question5,
      question6,
      question7,
      question8,
      question9,
      question10,
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
      final model = TailgateUnloadOperationModel(
        question1: question1 == true ? 'yes' : 'no',
        question2: question2!,
        question3: question3!,
        question4: question4 == true ? 'yes' : 'no',
        question5: question5!,
        question6: question6 == true ? 'yes' : 'no',
        question7: question7!,
        question8: question8 == true ? 'yes' : 'no',
        question9: question9 == true ? 'yes' : 'no',
        question10: question10!,
        name: nameController.text.trim(),
        date: date,
        signature: signatureFile,
        createdOn: DateTime.now(),
        createdBy: userId,
      );

      return await TailgateUnloadOperationModel
          .submitTailgateUnloadOperationForm(model);
    } catch (e) {
      print("Form submission error: $e");
      return false;
    }
  }
}
