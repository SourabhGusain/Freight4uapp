import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/dailyformmodels/settings.model.dart';
import 'package:Freight4u/models/dailyformmodels/runsheet.model.dart';
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
  final TextEditingController point1CityController = TextEditingController();
  final TextEditingController point2CityController = TextEditingController();
  final TextEditingController waitingTimeController = TextEditingController();

  final List<TextEditingController> breakStartControllers = [];
  final List<TextEditingController> breakEndControllers = [];

  int numberOfBreaks = 0;
  String selectedBreakValue = '';
  String selectedShift = '';
  String selectedSite = '';
  String selectedShape = '';

  String? selectedfileName;
  File? selectedFile;
  int userId = 0;

  SettingsModel? settings;
  final Session session = Session();

  Future<void> init() async {
    try {
      final userIdStr = await session.getSession("userId");
      print(userIdStr);
      if (userIdStr != null) userId = int.tryParse(userIdStr) ?? 0;
      settings = await fetchSettingsData();
      print('Settings loaded successfully.');
    } catch (e) {
      print('Failed to load settings: $e');
    }
  }

  List<Map<String, dynamic>> get siteDetails =>
      settings?.sites
          .map((site) => {
                'name': site.name,
                'enablePointCity': site.enablePointCity,
                'enableWaitingTime': site.enableWaitingTime,
              })
          .toList() ??
      [];

  Map<String, dynamic>? get selectedSiteObj {
    if (selectedSite.isEmpty) return null;
    try {
      return siteDetails.firstWhere((site) => site['name'] == selectedSite);
    } catch (e) {
      return null;
    }
  }

  int? _getSiteIdFromName(String siteName) {
    if (settings == null) return null;
    try {
      final site = settings!.sites.firstWhere((c) => c.name == siteName);
      print('Found site: ${site.name} with id: ${site.id}');
      return site.id;
    } catch (e) {
      print('Site not found for name: $siteName');
      return null;
    }
  }

  List<String> get shapeNames =>
      settings?.shapes.map((s) => s.name).toList() ?? [];

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

  Future<void> populateFromSession() async {
    final userJson = await session.getSession('loggedInUser');
    if (userJson == null) return;
    final Map<String, dynamic> userData = jsonDecode(userJson);
    driverNameController.text = userData["name"] ?? "";
    emailController.text = userData["email"] ?? "";
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      selectedFile = File(pickedFile.path!);
      selectedfileName =
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

      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00';
    } catch (e) {
      return input;
    }
  }

  // void printFormData() {
  //   print('--- Runsheet Form Data ---');
  //   print('API Endpoint: https://freight4you.com.au/api/dailyreport/runsheet/');
  //   print('Token: [REDACTED OR INSERT HERE IF AVAILABLE]');

  //   print('FormData fields:');
  //   print('Field: shift_type = $selectedShift');
  //   print('Field: shift_date = ${dateController.text}');
  //   print('Field: name = ${driverNameController.text}');
  //   print('Field: email = ${emailController.text}');
  //   print('Field: rego = ${regoController.text}');
  //   print('Field: shift_start_time = ${startTimeController.text}');
  //   print('Field: shift_end_time = ${endTimeController.text}');
  //   print('Field: loads_done = ${loadCountController.text}');
  //   print('Field: breaks_taken = $numberOfBreaks');

  //   if (selectedSiteObj?['enablePointCity'] == true) {
  //     print('Field: point1_city_name = ${point1CityController.text}');
  //     print('Field: point2_city_name = ${point2CityController.text}');
  //   } else {
  //     print('Field: point1_city_name = null');
  //     print('Field: point2_city_name = null');
  //   }

  //   if (selectedSiteObj?['enableWaitingTime'] == true) {
  //     print('Field: waiting_time = ${waitingTimeController.text}');
  //   } else {
  //     print('Field: waiting_time = null');
  //   }

  //   print('Field: created_on = ${DateTime.now().toIso8601String()}');

  //   final breaksList = <Map<String, String>>[];
  //   for (int i = 0; i < numberOfBreaks; i++) {
  //     final start = breakStartControllers[i].text;
  //     final end = breakEndControllers[i].text;
  //     print('Field: Break ${i + 1}: Start = $start, End = $end');

  //     if (start.isNotEmpty && end.isNotEmpty) {
  //       breaksList.add({"start_time": start, "end_time": end});
  //     }
  //   }

  //   print('Field: shift_breaks = ${jsonEncode(breaksList)}');
  //   print('Field: site = ${_getSiteIdFromName(selectedSite)}');
  //   print('Field: shape = ${_getShapeIdFromName(selectedShape)}');
  //   print('Field: created_by = $userId');
  //   print('Field: is_active = true');

  //   if (fileName != null) {
  //     print('File field: load_sheet, filename: ${fileName!.split(" ").first}');
  //   } else {
  //     print('File field: load_sheet = null');
  //   }

  //   print('-------------------------');
  // }

  Future<void> submitRunsheetForm(BuildContext context) async {
    _showLoadingDialog(context);

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

    if (selectedFile == null) {
      Navigator.pop(context);
      _showErrorDialog(context, "Please upload a valid load sheet file.");
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
        point1CityName: point1CityController.text.isNotEmpty
            ? point1CityController.text
            : "NA",
        point2CityName: point2CityController.text.isNotEmpty
            ? point2CityController.text
            : "NA",
        waitingTime: waitingTimeController.text.isNotEmpty
            ? waitingTimeController.text
            : "NA",
        shape: _getShapeIdFromName(selectedShape),
        rego: regoController.text,
        shiftStartTime: startTime,
        shiftEndTime: endTime,
        loadsDone: int.tryParse(loadCountController.text) ?? 0,
        breaksTaken: breaks.length,
        shiftBreaks: breaks,
        isActive: true,
        createdOn: DateTime.now().toIso8601String(),
        createdBy: userId,
      );

      // printFormData();

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
    point1CityController.clear();
    point2CityController.clear();
    waitingTimeController.clear();
    selectedfileName = null;
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
    point1CityController.dispose();
    point2CityController.dispose();
    waitingTimeController.dispose();
    for (final c in breakStartControllers) {
      c.dispose();
    }
    for (final c in breakEndControllers) {
      c.dispose();
    }
  }
}
