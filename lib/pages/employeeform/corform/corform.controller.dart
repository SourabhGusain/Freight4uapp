import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/employeemodels/corform.model.dart';

class CoRFormController {
  // Text field controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController traineeNameController = TextEditingController();
  final TextEditingController traineeDateController = TextEditingController();

  final TextEditingController driverResponsibilitiesController =
      TextEditingController();
  final TextEditingController corIssueStepsController = TextEditingController();
  final TextEditingController primaryDutyHolderController =
      TextEditingController();
  final TextEditingController corPenaltiesController = TextEditingController();
  final TextEditingController driverFatigueController = TextEditingController();
  final TextEditingController frmsComponentsController =
      TextEditingController();
  final TextEditingController actionIfSomethingWrongController =
      TextEditingController();
  final TextEditingController equipmentForOverloadingController =
      TextEditingController();
  final TextEditingController overloadRisksController = TextEditingController();
  final TextEditingController loadNotOverloadingStepsController =
      TextEditingController();

  // Signature controllers
  late SignatureController initialSignatureController; // Initial CoR signature
  late SignatureController traineeSignatureController;

  final Session session = Session();
  int userId = 0;
  DateTime traineeDate = DateTime.now();

  Future<void> init() async {
    try {
      final userIdStr = await session.getSession("userId");
      if (userIdStr != null) userId = int.tryParse(userIdStr) ?? 0;

      final userJsonString = await session.getSession('loggedInUser');
      if (userJsonString != null) {
        final userData = jsonDecode(userJsonString) as Map<String, dynamic>;
        nameController.text = userData["name"] ?? "";
      }

      traineeDateController.text = DateFormat('yyyy-MM-dd').format(traineeDate);

      initialSignatureController = SignatureController(
        penColor: Colors.black,
        penStrokeWidth: 3,
        exportBackgroundColor: Colors.white,
      );

      traineeSignatureController = SignatureController(
        penColor: Colors.black,
        penStrokeWidth: 3,
        exportBackgroundColor: Colors.white,
      );
    } catch (e) {
      print("CoRForm init error: $e");
    }
  }

  void dispose() {
    nameController.dispose();
    traineeNameController.dispose();
    traineeDateController.dispose();

    driverResponsibilitiesController.dispose();
    corIssueStepsController.dispose();
    primaryDutyHolderController.dispose();
    corPenaltiesController.dispose();
    driverFatigueController.dispose();
    frmsComponentsController.dispose();
    actionIfSomethingWrongController.dispose();
    equipmentForOverloadingController.dispose();
    overloadRisksController.dispose();
    loadNotOverloadingStepsController.dispose();

    initialSignatureController.dispose();
    traineeSignatureController.dispose();
  }

  bool validateInputs() {
    // Validate trainee name and trainee signature (questionnaire)
    return traineeNameController.text.trim().isNotEmpty &&
        !traineeSignatureController.isEmpty;
  }

  bool validateInitialInputs() {
    // Validate name and initial signature (CoR form)
    return nameController.text.trim().isNotEmpty &&
        !initialSignatureController.isEmpty;
  }

  Future<bool> submitForm() async {
    if (!validateInputs()) {
      print("Form validation failed.");
      return false;
    }

    try {
      traineeDate = DateFormat('yyyy-MM-dd').parse(traineeDateController.text);

      final Uint8List? traineeSigBytes =
          await traineeSignatureController.toPngBytes();
      File? traineeSigFile;
      if (traineeSigBytes != null) {
        traineeSigFile = File(
          '${Directory.systemTemp.path}/trainee_signature_${DateTime.now().millisecondsSinceEpoch}.png',
        );
        await traineeSigFile.writeAsBytes(traineeSigBytes);
      }

      // Export initial signature as PNG bytes
      final Uint8List? initialSigBytes =
          await initialSignatureController.toPngBytes();
      File? initialSigFile;
      if (initialSigBytes != null) {
        initialSigFile = File(
          '${Directory.systemTemp.path}/initial_signature_${DateTime.now().millisecondsSinceEpoch}.png',
        );
        await initialSigFile.writeAsBytes(initialSigBytes);
      }

      final model = CoRFormModel(
        name: nameController.text,
        signature: initialSigFile,
        traineeName: traineeNameController.text,
        traineeDate: traineeDate,
        traineeSignature: traineeSigFile,
        driverResponsibilities: driverResponsibilitiesController.text,
        corIssueSteps: corIssueStepsController.text,
        primaryDutyHolder: primaryDutyHolderController.text,
        corPenalties: corPenaltiesController.text,
        driverFatigue: driverFatigueController.text,
        frmsComponents: frmsComponentsController.text,
        actionIfSomethingWrong: actionIfSomethingWrongController.text,
        equipmentForOverloading: equipmentForOverloadingController.text,
        overloadRisks: overloadRisksController.text,
        loadNotOverloadingSteps: loadNotOverloadingStepsController.text,
        createdBy: userId,
        createdOn: DateTime.now(),
      );

      return await CoRFormModel.submitForm(model);
    } catch (e) {
      print("CoRForm submit error: $e");
      return false;
    }
  }
}
