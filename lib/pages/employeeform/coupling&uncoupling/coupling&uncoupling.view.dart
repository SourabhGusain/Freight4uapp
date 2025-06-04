import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/helpers/widgets.dart';
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
  late SignatureController _signatureController;

  final List<String> uncouplingSequenceOptions = ['A', 'B', 'C', 'D'];
  final List<String> couplingSequenceOptions = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 3,
      exportBackgroundColor: Colors.white,
    );
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
        textH3(label, font_size: 12, font_weight: FontWeight.w400),
        const SizedBox(height: 10),
        buildCommentTextField(
          controller: controller,
          hintText: "Write here...",
          minLines: 6,
          maxLines: null,
          fillColor: Colors.white,
          borderColor: Colors.grey,
          focusedBorderColor: Colors.black,
        ),
        const SizedBox(height: 20),
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
        const SizedBox(height: 25),
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
              textH1("Coupling/Uncoupling Questionnaire form :", font_size: 19),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  launchUrl(Uri.parse(
                      'https://youtu.be/IMvEtqDsSH8?si=rGmZS9maSy_PBv9D'));
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(color: blackColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf, color: Colors.red),
                      const SizedBox(width: 10),
                      Expanded(
                        child: textH3(
                          "Read the Coupling and decoupling trailers PDF before filling the form",
                          color: primaryColor,
                          font_weight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _buildTextField(
                  "Identify four (4) risks that are associated with Coupling/Uncoupling a Prime Mover to a trailer.",
                  _formController.risksIdentifiedController),
              _buildTextField(
                  "Name four (4) safety controls that can reduce the risks of Coupling/Uncoupling a Prime Mover to a trailer.",
                  _formController.safetyControlsController),
              _buildTextField(
                  "What must you do if you find a fault with the coupling mechanism as part of your pre-operational check?",
                  _formController.faultActionController),
              customTypeSelector(
                context: context,
                text:
                    "In what sequence do you perform the UNCOUPLING operation in?",
                hintText:
                    "In what sequence do you perform the UNCOUPLING operation in?",
                dropdownTypes: [
                  'Legs - Pin - Air',
                  'Pin - Air - Legs',
                  'Air - Legs - Pin',
                  'Pin - Legs - Air',
                ],
                selectedValue:
                    _formController.uncouplingSequenceController.text,
                onChanged: (value) {
                  setState(() {
                    _formController.uncouplingSequenceController.text =
                        value ?? "";
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                  "Once uncoupled from the pin and before completely clearing the trailer, what must you do?",
                  _formController.postUnpinActionController),
              customTypeSelector(
                context: context,
                text:
                    "In what sequence do you perform the COUPLING operation in?",
                hintText:
                    "In what sequence do you perform the COUPLING operation in?",
                dropdownTypes: [
                  'Air - Legs - Pin',
                  'Pin - Legs - Pin',
                  'Legs - Air - Pin',
                  'Pin - Air - Legs',
                ],
                selectedValue: _formController.couplingSequenceController.text,
                onChanged: (value) {
                  setState(() {
                    _formController.couplingSequenceController.text =
                        value ?? "";
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                  "When you attach the air leads, how far do you twist the connection tabs?",
                  _formController.airLeadsTwistController),
              _buildTextField(
                  "How many tug tests do you perform throughout the coupling operation?",
                  _formController.tugTestsCountController),
              _buildTextField(
                  "Whilst conducting coupling or uncoupling, what action must you do if you get distracted?",
                  _formController.distractionActionController),
              _buildTextField(
                  "What must you maintain when climbing up or down behind the cab or getting in or out of the cab?",
                  _formController.climbingSafetyController),
              textField("Full Name",
                  controller: _formController.nameController),
              const SizedBox(height: 25),
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
                  controller: _signatureController,
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
                      _signatureController.clear();
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
                    if (_signatureController.isEmpty) {
                      await _showErrorDialog('Please provide your signature.');
                      return;
                    }

                    final bytes = await _signatureController.toPngBytes();
                    if (bytes != null) {
                      final tempFile = File(
                        '${Directory.systemTemp.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png',
                      );
                      await tempFile.writeAsBytes(bytes);

                      _formController.signatureFile = tempFile;

                      final success = await _formController.submitForm(context);
                      if (success) {
                        await _showSuccessDialog(
                            "Form submitted successfully.");
                        Navigator.pop(context);
                      } else {
                        await _showErrorDialog("Failed to submit the form.");
                      }
                    } else {
                      await _showErrorDialog('Failed to capture signature.');
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
