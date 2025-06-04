import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/pages/employeeform/coupling&uncoupling/coupling&uncoupling.controller.dart';

class CouplingUncouplingFormPage extends StatefulWidget {
  final Session session;
  const CouplingUncouplingFormPage({super.key, required this.session});

  @override
  State<CouplingUncouplingFormPage> createState() =>
      _CouplingUncouplingFormPageState();
}

class _CouplingUncouplingFormPageState
    extends State<CouplingUncouplingFormPage> {
  final CouplingUncouplingController _formController =
      CouplingUncouplingController();
  bool isLoading = true;

  final List<String> uncouplingSequenceOptions = ['A', 'B', 'C', 'D'];
  final List<String> couplingSequenceOptions = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  Future<void> _initializeForm() async {
    await _formController.init();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  Future<void> _showMessageDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textH3(label, font_size: 13, font_weight: FontWeight.w400),
        buildCommentTextField(
          controller: controller,
          hintText: "Write here...",
          minLines: 6,
          maxLines: null,
          fillColor: Colors.white,
          borderColor: Colors.grey,
          focusedBorderColor: Colors.black,
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Future<void> _showErrorDialog(String message) async {
    await _showMessageDialog("Error", message);
  }

  Future<void> _showSuccessDialog(String message) async {
    await _showMessageDialog("Success", message);
  }

  Widget _dropdownField(String label, String value, List<String> options,
      void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          items: options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: secondaryNavBar(
            context,
            "Coupling/Uncoupling Questionnaire",
            onBack: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("Coupling/Uncoupling Questionnaire"),
              const SizedBox(height: 20),
              _buildTextField("Risks Identified",
                  _formController.risksIdentifiedController),
              _buildTextField(
                  "Safety Controls", _formController.safetyControlsController),
              _buildTextField(
                  "Fault Action", _formController.faultActionController),
              _dropdownField(
                "Uncoupling Sequence (A, B, C, D)",
                _formController.uncouplingSequenceController.text,
                uncouplingSequenceOptions,
                (val) => setState(() {
                  _formController.uncouplingSequenceController.text = val ?? '';
                }),
              ),
              _buildTextField("Post Unpin Action",
                  _formController.postUnpinActionController),
              _dropdownField(
                "Coupling Sequence (A, B, C, D)",
                _formController.couplingSequenceController.text,
                couplingSequenceOptions,
                (val) => setState(() {
                  _formController.couplingSequenceController.text = val ?? '';
                }),
              ),
              _buildTextField(
                  "Air Leads Twist", _formController.airLeadsTwistController),
              _buildTextField(
                  "Tug Tests Count", _formController.tugTestsCountController),
              _buildTextField("Distraction Action",
                  _formController.distractionActionController),
              _buildTextField(
                  "Climbing Safety", _formController.climbingSafetyController),
              _buildTextField("First Name", _formController.nameController),
              _buildTextField("Last Name", _formController.lastNameController),
              const SizedBox(height: 10),
              calendarDateField(
                context: context,
                label: "Acknowledgment Date",
                controller: _formController.acknowledgmentDateController,
              ),
              const SizedBox(height: 20),
              textH3("Signature:"),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Signature(
                  controller: _formController.signatureController,
                  height: 200,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 25,
                  width: 75,
                  child: darkButton(
                    buttonText("Clear", color: whiteColor, font_size: 10),
                    primary: primaryColor,
                    onPressed: () => setState(() {
                      _formController.signatureController.clear();
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: darkButton(
                  buttonText("Submit", color: whiteColor),
                  primary: primaryColor,
                  onPressed: () async {
                    if (_formController.signatureController.isEmpty) {
                      await _showErrorDialog('Please provide your signature.');
                      return;
                    }

                    final success = await _formController.submitForm(context);
                    if (success) {
                      await _showSuccessDialog("Form submitted successfully.");
                      Navigator.pop(context);
                    } else {
                      await _showErrorDialog("Failed to submit the form.");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
