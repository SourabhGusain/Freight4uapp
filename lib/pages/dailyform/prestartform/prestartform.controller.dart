import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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

  File? selectedPhoto;
  File? selectedVideo;

  String? photoFileName;
  String? videoFileName;

  bool isUploadingPhoto = false;
  bool isUploadingVideo = false;

  SettingsModel? settings;
  int userId = 0;

  final Session session = Session();

  Future<void> init() async {
    try {
      settings = await fetchSettingsData();
      String? id = await session.getSession("userId");
      userId = int.tryParse(id ?? '0') ?? 0;
    } catch (e) {
      print('Failed to load settings: $e');
    }
    await populateFromSession();
  }

  Future<void> populateFromSession() async {
    final userJson = await session.getSession('loggedInUser');
    if (userJson == null) return;
    final Map<String, dynamic> userData = jsonDecode(userJson);
    fullNameController.text = userData["name"] ?? "";
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

  Future<void> pickUploadPhotoFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      selectedPhoto = File(pickedFile.path!);
      photoFileName =
          "${pickedFile.name} (${(pickedFile.size / 1024).toStringAsFixed(1)} KB)";
    }
  }

  Future<void> pickUploadVideoFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      selectedVideo = File(pickedFile.path!);
      videoFileName =
          "${pickedFile.name} (${(pickedFile.size / 1024).toStringAsFixed(1)} KB)";
    }
  }

  Future<void> submitPrestartForm(BuildContext context) async {
    print("=== Prestart Form Data ===");
    print("Full Name: ${fullNameController.text}");
    print("Rego Name: ${regoNameController.text}");
    print("Date: ${dateController.text}");
    print("Time: ${timeController.text}");
    print("Contractor: $selectedContractor");
    print("Shape: $selectedShape");
    print("Valid License: $hasValidLicense");
    print("Fit For Task: $isFitForTask");
    print("No Medical Condition: $noMedicalCondition");
    print("Had 24Hr Rest: $had24HrRest");
    print("Had 10Hr Break: $had10HrBreak");
    print("No Substance Use: $noSubstanceUse");
    print("No Infringements: $noInfringements");
    print("Fit For Task Repeat: $fitForTaskRepeat");
    print("Photo File: ${photoFileName ?? 'No file selected'}");
    print("Video File: ${videoFileName ?? 'No file selected'}");
    print("=========================");

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
      photoUploads: selectedPhoto,
      videoUploads: selectedVideo,
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
    print("Prestart Model:");
    print("Date: ${prestartModel.photoUploads}");
    print(prestartModel);

    bool success = await PrestartModel.submitForm(prestartModel);

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

    selectedPhoto = null;
    selectedVideo = null;

    photoFileName = null;
    videoFileName = null;
  }

  void dispose() {
    fullNameController.dispose();
    regoNameController.dispose();
    dateController.dispose();
    timeController.dispose();
  }
}
