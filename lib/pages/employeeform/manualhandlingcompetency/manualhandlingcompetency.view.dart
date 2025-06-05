import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/session.dart';
import 'manualhandlingcompetency.controller.dart';

class ManualHandlingCompetencyFormPage extends StatefulWidget {
  final Session session;
  const ManualHandlingCompetencyFormPage({super.key, required this.session});

  @override
  State<ManualHandlingCompetencyFormPage> createState() =>
      _ManualHandlingCompetencyFormPageState();
}

class _ManualHandlingCompetencyFormPageState
    extends State<ManualHandlingCompetencyFormPage> {
  final ManualHandlingCompetencyController _formController =
      ManualHandlingCompetencyController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _formController.populateFromSession();
    _formController.signatureController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 3,
      exportBackgroundColor: Colors.white,
    );

    _formController.init().then((_) {
      setState(() => isLoading = false);
    });
  }

  @override
  void dispose() {
    _formController.signatureController.dispose();
    _formController.dispose();
    super.dispose();
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
            "Manual Handling Competency",
            onBack: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("Manual Handling Competency Form:"),
              const SizedBox(height: 20),
              calendarDateField(
                context: context,
                label: "Date",
                controller: _formController.dateController,
              ),
              const SizedBox(height: 15),
              textField("Name", controller: _formController.nameController),
              const SizedBox(height: 20),
              customTypeSelector(
                context: context,
                text:
                    "Which of these can be deemed as non-compliance with WHS Act and Regulation:",
                hintText: "Select non-compliance",
                dropdownTypes:
                    _formController.NON_COMPLIANCE_OPTIONS.values.toList(),
                selectedValue: _formController.nonCompliance == null
                    ? ""
                    : _formController.NON_COMPLIANCE_OPTIONS[
                            _formController.nonCompliance!] ??
                        "",
                onChanged: (label) {
                  setState(() {
                    _formController.nonCompliance = _formController
                        .NON_COMPLIANCE_OPTIONS.entries
                        .firstWhere((e) => e.value == label)
                        .key;
                  });
                },
              ),
              const SizedBox(height: 20),
              _declaration(
                  "Was the driving posture correct?",
                  _formController.drivingPostureCorrect,
                  (val) => setState(
                      () => _formController.drivingPostureCorrect = val)),
              customTypeSelector(
                context: context,
                text:
                    "Which of the following is incorrect when moving trolleys?",
                hintText: "Which Trolley practice was incorrect?",
                dropdownTypes: _formController.TROLLEY_CHOICES.values.toList(),
                selectedValue: _formController.incorrectTrolleyPractice == null
                    ? ""
                    : _formController.TROLLEY_CHOICES[
                            _formController.incorrectTrolleyPractice!] ??
                        "",
                onChanged: (label) {
                  setState(() {
                    _formController.incorrectTrolleyPractice = _formController
                        .TROLLEY_CHOICES.entries
                        .firstWhere((e) => e.value == label)
                        .key;
                  });
                },
              ),
              const SizedBox(height: 20),
              _declaration(
                  "I have a current and valid\nlicense to operate this\nvehicle.",
                  _formController.attemptDifficultTask,
                  (val) => setState(
                      () => _formController.attemptDifficultTask = val)),
              textH3("Signature"),
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
                    onPressed: () =>
                        _formController.signatureController.clear(),
                  ),
                ),
              ),
              const SizedBox(height: 100),
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

                    final bytes =
                        await _formController.signatureController.toPngBytes();
                    if (bytes != null) {
                      final tempFile = File(
                        '${Directory.systemTemp.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png',
                      );
                      await tempFile.writeAsBytes(bytes);

                      final success = await _formController.submitForm();
                      if (success) {
                        await _showSuccessDialog(
                            "Form submitted successfully.");
                        Navigator.pop(context);
                      } else {
                        await _showErrorDialog("Submission failed. Try again.");
                      }
                    } else {
                      await _showErrorDialog('Failed to capture signature.');
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
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

  Future<void> _showErrorDialog(String message) async {
    await _showMessageDialog("Error", message);
  }

  Future<void> _showSuccessDialog(String message) async {
    await _showMessageDialog("Success", message);
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
