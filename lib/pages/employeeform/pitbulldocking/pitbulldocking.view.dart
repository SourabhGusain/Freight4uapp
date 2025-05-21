import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/pages/employeeform/pitbulldocking/pitbulldocking.controller.dart';

class PitbullDockingSWPFormPage extends StatefulWidget {
  final Session session;
  const PitbullDockingSWPFormPage({super.key, required this.session});

  @override
  State<PitbullDockingSWPFormPage> createState() =>
      _PitbullDockingSWPFormPageState();
}

class _PitbullDockingSWPFormPageState extends State<PitbullDockingSWPFormPage> {
  final PitbullDockingController _formController = PitbullDockingController();
  late SignatureController _signatureController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 3,
      exportBackgroundColor: Colors.white,
    );
    _formController.init().then((_) async {
      await _formController.populateFromSession();
      if (mounted) setState(() => isLoading = false);
    });
  }

  @override
  void dispose() {
    _signatureController.dispose();
    _formController.dispose();
    super.dispose();
  }

  Widget _declaration(
      String text, TextEditingController controller, VoidCallback onChanged) {
    DeclarationAnswer? selected = switch (controller.text.toLowerCase()) {
      "yes" => DeclarationAnswer.yes,
      "no" => DeclarationAnswer.no,
      _ => null,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDeclarationBox(
          text: text,
          selectedAnswer: selected,
          onChanged: (DeclarationAnswer? answer) {
            if (answer == DeclarationAnswer.yes) {
              controller.text = "Yes";
            } else if (answer == DeclarationAnswer.no) {
              controller.text = "No";
            }
            onChanged();
          },
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
          child: secondaryNavBar(context, "Docking SWP Assessment",
              onBack: () => Navigator.pop(context)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("Pitbull & Docking Operation SWP Assessment form:"),
              const SizedBox(height: 20),
              calendarDateField(
                context: context,
                label: "Date of Acknowledgment",
                controller: _formController.dateController,
              ),
              const SizedBox(height: 15),
              textField("Name", controller: _formController.nameController),
              const SizedBox(height: 15),
              _declaration(
                "Q1. Drivers must not proceed on a red light.",
                _formController.q1DriversRedLightController,
                () => setState(() {}),
              ),
              customTypeSelector(
                context: context,
                text:
                    "What is the first thing you do after stopping at the gatehouse?",
                hintText:
                    "What is the first thing you do after stopping at the gatehouse?",
                dropdownTypes: [
                  'Call the office',
                  'Proceed to a dock',
                  'Uncouple from trailer',
                ],
                selectedValue: _formController.selectedQ2GatehouseProcedure,
                onChanged: (value) {
                  setState(() {
                    // FIX: ensure non-null string assigned
                    _formController.selectedQ2GatehouseProcedure = value ?? "";
                  });
                },
              ),
              const SizedBox(height: 20),
              _declaration(
                "Q3. No light means red light.",
                _formController.q3NoLightMeansRedController,
                () => setState(() {}),
              ),
              _declaration(
                "Q4. You must check seal and registration.",
                _formController.q4SealRegistrationCheckController,
                () => setState(() {}),
              ),
              customTypeSelector(
                context: context,
                text: "When your docking your trailer you should?",
                hintText: "When your docking your trailer you should?",
                dropdownTypes: [
                  'Wait 60 to 90 sec for light to change',
                  'Perform a tug test',
                  'Uncouple',
                ],
                selectedValue: _formController.selectedQ5TrailerDockingStep,
                onChanged: (value) {
                  setState(() {
                    // FIX: ensure non-null string assigned
                    _formController.selectedQ5TrailerDockingStep = value ?? "";
                  });
                },
              ),
              const SizedBox(height: 20),
              _declaration(
                "Q6. Are wheel chocks required?",
                _formController.q6ChockingRequiredController,
                () => setState(() {}),
              ),
              customTypeSelector(
                context: context,
                text:
                    "The only time you can commence any task,“when docks” are involved is on a...",
                hintText:
                    "The only time you can commence any task,“when docks” are involved is on a...",
                dropdownTypes: ['Amber light', 'Red light', 'Green light'],
                selectedValue: _formController.selectedQ7TaskCommencementLight,
                onChanged: (value) {
                  setState(() {
                    // FIX: ensure non-null string assigned
                    _formController.selectedQ7TaskCommencementLight =
                        value ?? "";
                  });
                },
              ),
              const SizedBox(height: 20),
              textH3("Signature"),
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
                    onPressed: () => _signatureController.clear(),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: darkButton(
                  buttonText("Submit", color: whiteColor),
                  primary: primaryColor,
                  onPressed: () async {
                    if (_signatureController.isEmpty) {
                      _showErrorDialog('Please provide your signature.');
                      return;
                    }

                    final bytes = await _signatureController.toPngBytes();
                    if (bytes != null) {
                      final tempFile = File(
                        '${Directory.systemTemp.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png',
                      );
                      await tempFile.writeAsBytes(bytes);
                      _formController.signatureFile = tempFile;
                      // DEBUG: Print form data before submitting
                      print('--- Form Data ---');
                      print('Date: ${_formController.dateController.text}');
                      print('Name: ${_formController.nameController.text}');
                      print(
                          'Q1: ${_formController.q1DriversRedLightController.text}');
                      print(
                          'Q2: ${_formController.selectedQ2GatehouseProcedure}');
                      print(
                          'Q3: ${_formController.q3NoLightMeansRedController.text}');
                      print(
                          'Q4: ${_formController.q4SealRegistrationCheckController.text}');
                      print(
                          'Q5: ${_formController.selectedQ5TrailerDockingStep}');
                      print(
                          'Q6: ${_formController.q6ChockingRequiredController.text}');
                      print(
                          'Q7: ${_formController.selectedQ7TaskCommencementLight}');
                      print(
                          'Signature file: ${_formController.signatureFile?.path}');
                      print('------------------');

                      await _formController.submitForm(context);
                    } else {
                      _showErrorDialog('Failed to capture signature.');
                    }
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
