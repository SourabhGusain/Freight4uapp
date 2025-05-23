import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/dailyformmodels/settings.model.dart';
import 'package:Freight4u/models/dailyformmodels/prestart.model.dart';
import 'package:Freight4u/pages/dailyform/dailyform.view.dart';

class PrestartFormController {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController regoNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  String selectedContractor = '';
  String selectedShape = '';

  bool? hasValidLicense;
  bool? isFitForTask;
  bool? noMedicalCondition;
  bool? had24HrRest;
  bool? had10HrBreak;
  bool? noSubstanceUse;
  bool? noInfringements;
  bool? fitForTaskRepeat;

  SettingsModel? settings;
  int userId = 0;

  final Session session = Session();

  Future<void> init() async {
    try {
      settings = await fetchSettingsData();
      String? userId = await session.getSession("userId");
      print(userId);
    } catch (e) {
      print('Failed to load settings: $e');
    }
  }

  List<String> get contractorNames =>
      settings?.contracts.map((c) => c.name).toList() ?? [];

  List<String> get shapeNames =>
      settings?.shapes.map((s) => s.name).toList() ?? [];

  int _getContractIdFromName(String contractorName) {
    final contractor = settings?.contracts.firstWhere(
      (c) => c.name == contractorName,
      orElse: () => Contract(id: 0, name: '', isActive: false, createdOn: ''),
    );
    return contractor?.id ?? 0;
  }

  int _getShapeIdFromName(String shapeName) {
    final shape = settings?.shapes.firstWhere(
      (s) => s.name == shapeName,
      orElse: () => Shape(id: 0, name: '', isActive: false, createdOn: ''),
    );
    return shape?.id ?? 0;
  }

  Future<void> submitPrestartForm(BuildContext context) async {
    // Validate required fields first
    if (fullNameController.text.trim().isEmpty ||
        regoNameController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty ||
        timeController.text.trim().isEmpty ||
        selectedContractor.isEmpty ||
        selectedShape.isEmpty ||
        hasValidLicense == null ||
        isFitForTask == null ||
        noMedicalCondition == null ||
        had24HrRest == null ||
        had10HrBreak == null ||
        noSubstanceUse == null ||
        noInfringements == null ||
        fitForTaskRepeat == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: textH1("Missing Information", font_size: 20),
          content: textH3("Please fill all required fields before submitting.",
              font_size: 14, font_weight: FontWeight.w400),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: textH3("OK"),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      ),
    );

    PrestartModel prestartModel = PrestartModel(
      date: dateController.text,
      time: timeController.text,
      name: fullNameController.text,
      rego: regoNameController.text,
      contract: _getContractIdFromName(selectedContractor),
      shape: _getShapeIdFromName(selectedShape),
      validLicense: hasValidLicense == true ? 'yes' : 'no',
      fitForTask: isFitForTask == true ? 'yes' : 'no',
      notFatigued: noMedicalCondition == true ? 'yes' : 'no',
      willNotify: had24HrRest == true ? 'yes' : 'no',
      weeklyRest: had10HrBreak == true ? 'yes' : 'no',
      restBreak: noSubstanceUse == true ? 'yes' : 'no',
      substanceClear: noInfringements == true ? 'yes' : 'no',
      noInfringements: fitForTaskRepeat == true ? 'yes' : 'no',
      isActive: true,
      createdOn: DateTime.now().toIso8601String(),
      createdBy: userId,
    );

    bool success = await PrestartModel.preStartForm(prestartModel);

    Navigator.pop(context);

    if (success) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: textH1("Success"),
          content:
              subtext("Prestart form submitted successfully.", font_size: 15),
          actions: [
            TextButton(
              onPressed: () {
                Get.to(
                  context,
                  () => DailyformPage(session: session),
                );
              },
              child: textH3("OK"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: textH1("Error"),
          content: subtext("Failed to submit prestart form. Please try again.",
              font_size: 15),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: textH3("OK"),
            ),
          ],
        ),
      );
    }
  }

  void resetForm() {
    fullNameController.clear();
    regoNameController.clear();
    dateController.clear();
    timeController.clear();
    selectedContractor = '';
    selectedShape = '';

    hasValidLicense = null;
    isFitForTask = null;
    noMedicalCondition = null;
    had24HrRest = null;
    had10HrBreak = null;
    noSubstanceUse = null;
    noInfringements = null;
    fitForTaskRepeat = null;
  }

  void dispose() {
    fullNameController.dispose();
    regoNameController.dispose();
    dateController.dispose();
    timeController.dispose();
  }
}
