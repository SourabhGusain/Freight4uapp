import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/fuelreceipt.model.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/pages/dailyform/dailyform.view.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/widgets/form.dart';

class FuelReceiptFormController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController regoController = TextEditingController();

  bool? declarationAnswer;
  File? fuelReceiptFile;
  String? fuelReceiptFileName;

  final Session session = Session();
  int userId = 0;

  Future<void> init() async {
    try {
      String? userId = await session.getSession("userId");
      print("user $userId");
    } catch (e) {
      print('Failed to load settings: $e');
    }
  }

  Future<void> pickFuelReceiptFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        final pickedFile = result.files.first;
        if (pickedFile.path != null) {
          fuelReceiptFile = File(pickedFile.path!);
          fuelReceiptFileName =
              "${pickedFile.name} (${(pickedFile.size / 1024).toStringAsFixed(1)} KB)";
        }
      }
    } catch (e) {
      debugPrint('File picking error: $e');
    }
  }

  Future<void> submitForm(BuildContext context) async {
    _showLoadingDialog(context);

    if (nameController.text.isEmpty ||
        dateController.text.isEmpty ||
        regoController.text.isEmpty ||
        fuelReceiptFile == null ||
        declarationAnswer == null) {
      Navigator.pop(context);
      _showErrorDialog(
        context,
        "Please fill in all required fields and upload a fuel receipt.",
      );
      return;
    }

    try {
      final model = FuelReceiptModel(
        name: nameController.text.trim(),
        date: dateController.text.trim(),
        rego: regoController.text.trim(),
        paymentWithFuelCard: declarationAnswer == true ? "YES" : "NO",
        fuelReceipt: fuelReceiptFile!,
        createdOn: DateTime.now().toIso8601String(),
        createdBy: userId,
      );

      final success = await FuelReceiptModel.submitFuelReceipt(model);
      Navigator.pop(context);
      _showSuccessDialog(context, success);
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog(context, "Unexpected error: $e");
    }
  }

  void resetForm() {
    nameController.clear();
    dateController.clear();
    regoController.clear();
    fuelReceiptFile = null;
    fuelReceiptFileName = null;
    declarationAnswer = null;
  }

  void dispose() {
    nameController.dispose();
    dateController.dispose();
    regoController.dispose();
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: primaryColor),
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
        content: Text(success
            ? "Fuel receipt submitted successfully."
            : "Failed to submit fuel receipt. Please try again."),
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
