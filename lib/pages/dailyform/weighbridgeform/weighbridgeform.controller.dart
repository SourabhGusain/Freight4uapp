import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/dailyformmodels/settings.model.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/pages/dailyform/dailyform.view.dart';
import 'package:intl/intl.dart';
import 'package:Freight4u/models/dailyformmodels/weighbridge.model.dart';
import 'package:Freight4u/widgets/form.dart';

class WeighbridgeController extends BaseViewModel {
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final regoController = TextEditingController();

  String selectedDepot = '';
  SettingsModel? settings;

  File? weighbridgeFile;
  String? weighbridgeFileName;

  File? loadPicFile;
  String? loadPicFileName;

  final Session session = Session();

  Future<void> init() async {
    try {
      settings = await fetchSettingsData();
      notifyListeners();
      print("Available Depots: ${depotNames.join(', ')}");
    } catch (e) {
      print('Failed to load settings: $e');
    }
  }

  List<String> get depotNames =>
      settings?.depots.map((d) => d.name).toList() ?? [];

  int _getDepotIdFromName(String depotName) {
    final depot = settings?.depots.firstWhere(
      (c) => c.name == depotName,
      orElse: () => Depot(id: 0, name: '', isActive: false, createdOn: ''),
    );
    return depot?.id ?? 0;
  }

  Future<void> pickWeighbridgeFile() async {
    await _pickFile(isWeighbridge: true);
  }

  Future<void> pickLoadPicFile() async {
    await _pickFile(isWeighbridge: false);
  }

  Future<void> _pickFile({required bool isWeighbridge}) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      final file = File(pickedFile.path!);
      final nameSize =
          "${pickedFile.name} (${(pickedFile.size / 1024).toStringAsFixed(1)} KB)";

      if (isWeighbridge) {
        weighbridgeFile = file;
        weighbridgeFileName = nameSize;
      } else {
        loadPicFile = file;
        loadPicFileName = nameSize;
      }
      notifyListeners();
    }
  }

  bool isFormValid() {
    return nameController.text.trim().isNotEmpty &&
        dateController.text.trim().isNotEmpty &&
        regoController.text.trim().isNotEmpty &&
        selectedDepot.trim().isNotEmpty &&
        weighbridgeFile != null &&
        loadPicFile != null;
  }

  Future<void> submitWeighbridgeForm(BuildContext context) async {
    if (!isFormValid()) {
      _showErrorDialog(
          context, "Please fill all required fields and upload both files.");
      return;
    }

    _showLoadingDialog(context);

    try {
      final userIdStr = await session.getSession("userId");
      final userId = int.tryParse(userIdStr ?? '');

      final depotId = _getDepotIdFromName(selectedDepot);

      final model = WeighbridgeModel(
        date: dateController.text.trim(),
        name: nameController.text.trim(),
        rego: regoController.text.trim(),
        depot: depotId.toString(), // Pass depot ID as string
        weighbridgeDocketFile: weighbridgeFile,
        loadPicAndSheetFile: loadPicFile,
        createdOn: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        createdBy: userId,
      );

      print('Submitting the following data:');
      print('Date: ${model.date}');
      print('Name: ${model.name}');
      print('Driver Name: ${model.rego}');
      print('Depot (ID): ${model.depot}');
      print('Weighbridge File: ${model.weighbridgeDocketFile?.path}');
      print('Load Pic File: ${model.loadPicAndSheetFile?.path}');
      print('Created On: ${model.createdOn}');
      print('Created By (User ID): ${model.createdBy}');

      final success = await WeighbridgeModel.submitWeighbridge(model);

      Navigator.pop(context); // Close loading dialog

      if (success) {
        _showSuccessDialog(context, true);
      } else {
        _showErrorDialog(context, "Submission failed.");
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog(context, "Submission failed: $e");
    }
  }

  void reset() {
    nameController.clear();
    dateController.clear();
    regoController.clear();
    selectedDepot = '';
    weighbridgeFile = null;
    weighbridgeFileName = null;
    loadPicFile = null;
    loadPicFileName = null;
    notifyListeners();
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
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
              ? "Weighbridge form submitted successfully."
              : "Failed to submit weighbridge form. Please try again.",
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

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    regoController.dispose();
    super.dispose();
  }
}
