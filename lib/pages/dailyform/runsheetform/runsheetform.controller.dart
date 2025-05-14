import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/models/settings.model.dart';
import 'package:Freight4u/models/runsheet.model.dart';
import 'package:Freight4u/pages/dailyform/dailyform.view.dart';

class RunsheetFormController {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController regoController = TextEditingController();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController loadCountController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  final List<TextEditingController> breakStartControllers = [];
  final List<TextEditingController> breakEndControllers = [];
  int numberOfBreaks = 0;
  String selectedBreakValue = '';

  String selectedShift = '';
  String selectedSite = '';
  String selectedShape = '';

  String? fileName;

  SettingsModel? settings;

  final Session session = Session();

  Future<void> init() async {
    try {
      settings = await fetchSettingsData();

      print('Settings loaded successfully.');
    } catch (e) {
      print('Failed to load settings: $e');
    }
  }

  List<String> get siteNames =>
      settings?.sites.map((c) => c.name).toList() ?? [];

  List<String> get shapeNames =>
      settings?.shapes.map((s) => s.name).toList() ?? [];

  int _getSiteIdFromName(String siteName) {
    final site = settings?.sites.firstWhere(
      (c) => c.name == siteName,
      orElse: () => Site(id: 0, name: '', isActive: false, createdOn: ''),
    );
    return site?.id ?? 0;
  }

  int _getShapeIdFromName(String shapeName) {
    final shape = settings?.shapes.firstWhere(
      (s) => s.name == shapeName,
      orElse: () => Shape(id: 0, name: '', isActive: false, createdOn: ''),
    );
    return shape?.id ?? 0;
  }

  void updateBreaks(String value) {
    selectedBreakValue = value;
    numberOfBreaks = int.tryParse(value) ?? 0;

    breakStartControllers.clear();
    breakEndControllers.clear();

    for (int i = 0; i < numberOfBreaks; i++) {
      breakStartControllers.add(TextEditingController());
      breakEndControllers.add(TextEditingController());
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      fileName =
          "${pickedFile.name} (${(pickedFile.size / 1024).toStringAsFixed(1)} KB)";
    }
  }

  Future<void> submitRunsheetForm(BuildContext context) async {
    // if (driverNameController.text.isEmpty || emailController.text.isEmpty) {
    //   _showErrorDialog(context, "Please fill in all required fields.");
    //   return;
    // }

    _showLoadingDialog(context);

    try {
      // DEBUG: Print controller data
      print("====== SUBMITTING RUNSHEET FORM ======");
      print("Date: ${dateController.text}");
      print("Shift Type: $selectedShift");
      print("Driver Name: ${driverNameController.text}");
      print("Email: ${emailController.text}");
      print("Site: $selectedSite");
      print("Shape: $selectedShape");
      print("Rego: ${regoController.text}");
      print("Start Time: ${startTimeController.text}");
      print("End Time: ${endTimeController.text}");
      print("Loads Done: ${loadCountController.text}");
      print("Breaks Taken: $numberOfBreaks");
      print("Uploaded File: $fileName");
      print("Created On: ${DateTime.now().toIso8601String()}");
      print("======================================");

      final runsheetModel = RunsheetModel(
        shiftDate: dateController.text,
        shiftType: selectedShift,
        name: driverNameController.text,
        email: emailController.text,
        site: _getSiteIdFromName(selectedSite),
        shape: _getShapeIdFromName(selectedShape),
        rego: regoController.text,
        shiftStartTime: startTimeController.text,
        shiftEndTime: endTimeController.text,
        loadsDone: int.tryParse(loadCountController.text) ?? 0,
        breaksTaken: numberOfBreaks,
        loadSheet: fileName ?? '',
        isActive: true,
        createdOn: DateTime.now().toIso8601String(),
        createdBy: 1, // session.userId ?? 1,
      );

      bool success = await RunsheetModel.submitRunsheet(runsheetModel);

      Navigator.pop(context);

      _showSuccessDialog(context, success);
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog(context, "Unexpected error occurred: $e");
    }
  }

  void resetForm() {
    dateController.clear();
    startTimeController.clear();
    endTimeController.clear();
    regoController.clear();
    driverNameController.clear();
    emailController.clear();
    loadCountController.clear();
    commentController.clear();

    fileName = null;
    selectedShift = '';
    selectedSite = '';
    selectedShape = '';
    selectedBreakValue = '';
    numberOfBreaks = 0;

    breakStartControllers.clear();
    breakEndControllers.clear();
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
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
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
        content: Text(
          success
              ? "Runsheet form submitted successfully."
              : "Failed to submit runsheet form. Please try again.",
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) {
                Get.to(context, () => DailyformPage(session: session));
              }
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void dispose() {
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    regoController.dispose();
    driverNameController.dispose();
    emailController.dispose();
    loadCountController.dispose();
    commentController.dispose();

    for (final c in breakStartControllers) {
      c.dispose();
    }
    for (final c in breakEndControllers) {
      c.dispose();
    }
  }
}
