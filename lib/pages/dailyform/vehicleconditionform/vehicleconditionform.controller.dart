import 'dart:io';
import 'package:flutter/material.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/settings.model.dart';
import 'package:Freight4u/models/vehiclecondition.model.dart';
import 'package:Freight4u/pages/dailyform/dailyform.view.dart';

class VehicleConditionFormController {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController siteManagerController = TextEditingController();
  final TextEditingController registrationController = TextEditingController();
  final TextEditingController odometerReadingController =
      TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();

  File? selectedFile;
  File? signatureFile;

  String? fileName;
  String? signatureFileName;

  String selectedSite = '';
  SettingsModel? settings;

  final Session session = Session();
  int userId = 0;

  Future<void> init() async {
    try {
      settings = await fetchSettingsData();
      print("Settings loaded for Vehicle Condition Form");
      print(siteNames);
    } catch (e) {
      print("Error loading settings: $e");
    }
  }

  List<String> get siteNames =>
      settings?.sites.map((site) => site.name).toList() ?? [];

  int _getSiteIdFromName(String siteName) {
    final site = settings?.sites.firstWhere(
      (c) => c.name == siteName,
      orElse: () => Site(id: 0, name: '', isActive: false, createdOn: ''),
    );
    return site?.id ?? 0;
  }

  Future<void> pickUploadPhotoFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      selectedFile = File(pickedFile.path!);
      fileName =
          "${pickedFile.name} (${(pickedFile.size / 1024).toStringAsFixed(1)} KB)";
    }
  }

  Future<void> pickSignatureFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      signatureFile = File(pickedFile.path!);
      signatureFileName =
          "${pickedFile.name} (${(pickedFile.size / 1024).toStringAsFixed(1)} KB)";
    }
  }

  Future<void> submitForm(BuildContext context) async {
    _showLoadingDialog(context);

    if (signatureFile == null) {
      Navigator.pop(context);
      _showErrorDialog(context, "Please upload your signature.");
      return;
    }

    if (dateController.text.isEmpty ||
        timeController.text.isEmpty ||
        driverNameController.text.isEmpty ||
        siteManagerController.text.isEmpty ||
        registrationController.text.isEmpty ||
        odometerReadingController.text.isEmpty ||
        categoryController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      Navigator.pop(context);
      _showErrorDialog(context, "Please fill in all required fields.");
      return;
    }

    try {
      final model = VehicleConditionReportModel(
        date: dateController.text,
        time: timeController.text,
        driverName: driverNameController.text,
        site: _getSiteIdFromName(selectedSite),
        siteManager: siteManagerController.text,
        registration: registrationController.text,
        odometerReading: int.tryParse(odometerReadingController.text) ?? 0,
        category: categoryController.text,
        description: descriptionController.text,
        comments: commentsController.text,
        uploadPhoto: selectedFile,
        signature: signatureFile!,
        createdOn: DateTime.now().toIso8601String(),
        createdBy: userId,
      );

      bool success = await VehicleConditionReportModel.submitReport(model);
      Navigator.pop(context);
      _showSuccessDialog(context, success);
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog(context, "Unexpected error: $e");
    }
  }

  void resetForm() {
    dateController.clear();
    timeController.clear();
    driverNameController.clear();
    siteManagerController.clear();
    registrationController.clear();
    odometerReadingController.clear();
    categoryController.clear();
    descriptionController.clear();
    commentsController.clear();
    selectedSite = '';
    selectedFile = null;
    signatureFile = null;
  }

  void dispose() {
    dateController.dispose();
    timeController.dispose();
    driverNameController.dispose();
    siteManagerController.dispose();
    registrationController.dispose();
    odometerReadingController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    commentsController.dispose();
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: primaryColor)),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: textH1("Missing Information", font_size: 20),
        content: textH3(message, font_size: 14, font_weight: FontWeight.w400),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, bool success) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(success ? "Success" : "Error"),
        content: Text(success
            ? "Vehicle condition report submitted successfully."
            : "Failed to submit vehicle condition report. Please try again."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) {
                Get.to(context, () => DailyformPage(session: session));
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
