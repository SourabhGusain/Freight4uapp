import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/session.dart';
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
  File? selectedFile;

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
      selectedFile = File(pickedFile.path!);
      fileName =
          "${pickedFile.name} (${(pickedFile.size / 1024).toStringAsFixed(1)} KB)";
    }
  }

  String to24HourFormat(String input) {
    try {
      input = input.trim().toUpperCase();
      final regExp = RegExp(r'^(\d{1,2}):(\d{2})(?:\s?(AM|PM))?$');
      final match = regExp.firstMatch(input);

      if (match == null) {
        return input;
      }

      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2)!);
      String? meridiem = match.group(3);

      if (meridiem != null) {
        if (meridiem == 'AM') {
          if (hour == 12) hour = 0;
        } else if (meridiem == 'PM') {
          if (hour != 12) hour += 12;
        }
      }

      // Return with seconds (:00) appended
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00';
    } catch (e) {
      return input;
    }
  }

  void printFormData() {
    print('--- Runsheet Form Data ---');
    print('Date: ${dateController.text}');
    print('Shift: $selectedShift');
    print('Driver Name: ${driverNameController.text}');
    print('Email: ${emailController.text}');
    print('Site: $selectedSite (ID: ${_getSiteIdFromName(selectedSite)})');
    print('Shape: $selectedShape (ID: ${_getShapeIdFromName(selectedShape)})');
    print('Rego: ${regoController.text}');
    print('Shift Start Time: ${startTimeController.text}');
    print('Shift End Time: ${endTimeController.text}');
    print('Loads Done: ${loadCountController.text}');
    print('Number of Breaks: $numberOfBreaks');
    for (int i = 0; i < breakStartControllers.length; i++) {
      print(
          'Break ${i + 1}: Start - ${breakStartControllers[i].text}, End - ${breakEndControllers[i].text}');
    }
    print('File Name: $fileName');
    print('-------------------------');
  }

  Future<void> submitRunsheetForm(BuildContext context) async {
    _showLoadingDialog(context);

    if (selectedFile == null) {
      Navigator.pop(context);
      _showErrorDialog(context, "Please upload a valid load sheet file.");
      return;
    }

    if (dateController.text.isEmpty ||
        selectedShift.isEmpty ||
        driverNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        selectedSite.isEmpty ||
        selectedShape.isEmpty ||
        regoController.text.isEmpty ||
        startTimeController.text.isEmpty ||
        endTimeController.text.isEmpty) {
      Navigator.pop(context);
      _showErrorDialog(context, "Please fill in all required fields.");
      return;
    }

    try {
      final startTime = to24HourFormat(startTimeController.text);
      final endTime = to24HourFormat(endTimeController.text);

      if (startTime == endTime) {
        Navigator.pop(context);
        _showErrorDialog(
            context, "Start time and end time cannot be the same.");
        return;
      }

      List<ShiftBreak> breaks = [];
      for (int i = 0; i < numberOfBreaks; i++) {
        final rawStart = breakStartControllers[i].text;
        final rawEnd = breakEndControllers[i].text;

        if (rawStart.isEmpty || rawEnd.isEmpty) continue;

        final start = to24HourFormat(rawStart);
        final end = to24HourFormat(rawEnd);

        final startDt = DateTime.parse("2025-01-01 $start");
        final endDt = DateTime.parse("2025-01-01 $end");

        if (!endDt.isAfter(startDt)) {
          Navigator.pop(context);
          _showErrorDialog(
              context, "Break ${i + 1}: End time must be after start time.");
          return;
        }

        breaks.add(ShiftBreak(startTime: start, endTime: end));
      }

      final runsheetModel = RunsheetModel(
        shiftDate: dateController.text,
        shiftType: selectedShift,
        name: driverNameController.text,
        email: emailController.text,
        site: _getSiteIdFromName(selectedSite),
        shape: _getShapeIdFromName(selectedShape),
        rego: regoController.text,
        shiftStartTime: startTime,
        shiftEndTime: endTime,
        loadsDone: int.tryParse(loadCountController.text) ?? 0,
        breaksTaken: breaks.length,
        shiftBreaks: breaks,
        isActive: true,
        createdOn: DateTime.now().toIso8601String(),
        createdBy: 1,
      );

      printFormData();

      bool success =
          await RunsheetModel.submitRunsheet(runsheetModel, selectedFile!);

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
    selectedFile = null;
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
        title: const Text('Error'),
        content: Text(message),
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
        content: Text(
          success
              ? "Runsheet form submitted successfully."
              : "Failed to submit runsheet form. Please try again.",
          style: const TextStyle(fontSize: 15),
        ),
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
