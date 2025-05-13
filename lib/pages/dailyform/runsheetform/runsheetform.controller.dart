import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:signature/signature.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/models/settings.model.dart';
import 'package:Freight4u/models/runsheet.model.dart';
import 'package:Freight4u/pages/dailyform/dailyform.view.dart';

class RunsheetFormController extends BaseViewModel {
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

  late SignatureController signatureController;

  String selectedShift = '';
  String selectedSite = '';
  String selectedShape = '';
  String selectedBreakValue = '';
  String? fileName;
  int numberOfBreaks = 0;

  int currentIndex = 0;

  SettingsModel? settings;
  final Session session = Session();

  Future<void> init() async {
    signatureController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 5.0,
      exportBackgroundColor: Colors.transparent,
    );

    try {
      settings = await fetchSettingsData();
    } catch (e) {
      print('Failed to load settings: $e');
    }

    notifyListeners();
  }

  void updateShift(String value) {
    selectedShift = value;
    notifyListeners();
  }

  void updateSite(String value) {
    selectedSite = value;
    notifyListeners();
  }

  void updateShape(String value) {
    selectedShape = value;
    notifyListeners();
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

    notifyListeners();
  }

  void updateCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  // --- Dropdown data from settings ---
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

  // --- File Picker ---
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      fileName =
          "${pickedFile.name} (${(pickedFile.size / 1024).toStringAsFixed(1)} KB)";
      notifyListeners();
    }
  }

  // --- Form Submission ---
  Future<void> submitRunsheetForm(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          Center(child: CircularProgressIndicator(color: primaryColor)),
    );

    try {
      final runsheetModel = RunsheetModel(
          shiftTiming: selectedShift,
          shiftDate: dateController.text,
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
          createdBy: 1 //session.userId ?? 1,
          );

      bool success = await RunsheetModel.submitRunsheet(runsheetModel);

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: textH1(success ? "Success" : "Error"),
          content: subtext(
            success
                ? "Runsheet form submitted successfully."
                : "Failed to submit runsheet form. Please try again.",
            font_size: 15,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                if (success) {
                  Get.to(context, () => DailyformPage(session: session));
                }
              },
              child: textH3("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: textH1("Error"),
          content: subtext("Unexpected error occurred: $e", font_size: 15),
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

    notifyListeners();
  }

  @override
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

    signatureController.dispose();
    super.dispose();
  }
}
