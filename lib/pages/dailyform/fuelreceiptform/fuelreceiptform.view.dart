import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/dailyform/fuelreceiptform/fuelreceiptform.controller.dart';

class FuelReceiptPage extends StatefulWidget {
  const FuelReceiptPage({super.key});

  @override
  State<FuelReceiptPage> createState() => _FuelReceiptPageState();
}

class _FuelReceiptPageState extends State<FuelReceiptPage> {
  final FuelReceiptFormController _formController = FuelReceiptFormController();

  String? fileName;
  bool isBackLoading = false;

  @override
  void initState() {
    super.initState();
    _formController.populateFromSession();
    _formController.dateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    _formController.init().then((_) {
      setState(() {});
    });
  }

  Future<void> _showFilePickerOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: textH2(
                    "Select File Source",
                    font_size: 16,
                    font_weight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPickerTile(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: _pickImageFromGallery,
                ),
                _buildPickerTile(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: _pickImageFromCamera,
                ),
                _buildPickerTile(
                  icon: Icons.insert_drive_file,
                  label: 'File (Documents)',
                  onTap: _pickFile,
                ),
                const Divider(height: 24),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: const Icon(Icons.close, color: Colors.grey),
                  title: textH2(
                    'Cancel',
                    font_size: 16,
                    font_weight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPickerTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        leading: CircleAvatar(
          backgroundColor: primaryColor.withOpacity(0.08),
          child: Icon(icon, color: primaryColor),
        ),
        title: textH2(
          label,
          font_size: 15,
          font_weight: FontWeight.w500,
        ),
        onTap: () {
          Navigator.of(context).pop();
          onTap();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hoverColor: primaryColor.withOpacity(0.05),
        splashColor: primaryColor.withOpacity(0.1),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final file = await FilePickerHelper.pickImageFromGallery();
    if (file != null) {
      setState(() {
        _formController.fuelReceiptFile = file;
        _formController.fuelReceiptFileName =
            FilePickerHelper.getReadableFileName(file.path);
        fileName = _formController.fuelReceiptFileName;
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final file = await FilePickerHelper.pickImageFromCamera();
    if (file != null) {
      setState(() {
        _formController.fuelReceiptFile = file;
        _formController.fuelReceiptFileName =
            FilePickerHelper.getReadableFileName(file.path);
        fileName = _formController.fuelReceiptFileName;
      });
    }
  }

  Future<void> _pickFile() async {
    final file = await FilePickerHelper.pickDocumentFile();
    if (file != null) {
      final size = await file.length();
      setState(() {
        _formController.fuelReceiptFile = file;
        _formController.fuelReceiptFileName =
            FilePickerHelper.getReadableFileName(file.path, sizeBytes: size);
        fileName = _formController.fuelReceiptFileName;
      });
    }
  }

  Future<void> _handleBack() async {
    setState(() {
      isBackLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFCFDFE),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: secondaryNavBar(context, "Fuel Receipt Form",
              onBack: _handleBack),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("Forms:"),
              const SizedBox(height: 15),
              _buildTextField("Full Name", _formController.nameController),
              const SizedBox(height: 15),
              _buildCalendarDateField(
                  "Date", _formController.dateController, context),
              const SizedBox(height: 15),
              _buildTextField("Rego", _formController.regoController),
              const SizedBox(height: 15),
              _declaration(
                "Payment made with company fuel card.",
                _formController.declarationAnswer,
                (value) =>
                    setState(() => _formController.declarationAnswer = value),
              ),
              const SizedBox(height: 15),
              textH3("Upload Fuel Receipt", font_weight: FontWeight.w400),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: _showFilePickerOptions,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        textH3(
                          fileName ?? "Browse File Here",
                          color: blackColor,
                          font_size: 15,
                          font_weight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 170),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: darkButton(
                  buttonText("Save", color: whiteColor),
                  primary: primaryColor,
                  onPressed: () => _formController.submitForm(context),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return SizedBox(
      height: 50,
      child: textField(label, controller: controller),
    );
  }

  Widget _buildCalendarDateField(
      String label, TextEditingController controller, BuildContext context) {
    return SizedBox(
      height: 50,
      child: calendarDateField(
        context: context,
        label: label,
        controller: controller,
      ),
    );
  }

  Widget _declaration(String text, bool? value, Function(bool?) onBoolChanged) {
    DeclarationAnswer? selected = switch (value) {
      true => DeclarationAnswer.yes,
      false => DeclarationAnswer.no,
      null => null,
    };

    return Column(
      children: [
        CustomDeclarationBox(
          text: text,
          selectedAnswer: selected,
          onChanged: (DeclarationAnswer? answer) {
            bool? boolValue = switch (answer) {
              DeclarationAnswer.yes => true,
              DeclarationAnswer.no => false,
              null => null,
            };
            onBoolChanged(boolValue);
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
