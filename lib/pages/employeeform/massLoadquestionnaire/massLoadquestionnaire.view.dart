import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'massLoadquestionnaire.controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/helpers/widgets.dart';

class MassLoadRestraintFormPage extends StatefulWidget {
  final Session session;
  const MassLoadRestraintFormPage({Key? key, required this.session})
      : super(key: key);

  @override
  State<MassLoadRestraintFormPage> createState() =>
      _MassLoadRestraintFormPageState();
}

class _MassLoadRestraintFormPageState extends State<MassLoadRestraintFormPage> {
  final MassLoadRestraintQuestionnaireController _formController =
      MassLoadRestraintQuestionnaireController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _formController.populateFromSession();
    _formController.init().then((_) {
      setState(() => isLoading = false);
    });
  }

  @override
  void dispose() {
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
            "Mass Load Restraint Questionnaire",
            onBack: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("Mass Load Restraint Questionnaire Form :"),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  launchUrl(Uri.parse(
                      'https://www.ntc.gov.au/sites/default/files/assets/files/Load-Restraint-Guide-2018.pdf'));
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
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
                          "Read the Mass Load Restraint Guide - 2018 pdf before filling the form",
                          color: primaryColor,
                          font_weight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              calendarDateField(
                context: context,
                label: "Date",
                controller: _formController.dateController,
              ),
              const SizedBox(height: 20),
              textField("Name", controller: _formController.nameController),
              const SizedBox(height: 20),
              _declaration(
                "1. Can an incorrect positioning of a load result in a significantly safety risk?",
                _formController.question1,
                (val) => setState(() => _formController.question1 = val),
              ),
              customTypeSelector(
                context: context,
                text:
                    "To maintain the handling and balance of the vehicle, loads should be:",
                hintText:
                    "Select an option - To maintain the handling and balance of the vehicle, loads should be:",
                dropdownTypes:
                    _formController.QUESTION2_CHOICES.values.toList(),
                selectedValue: _formController
                        .QUESTION2_CHOICES[_formController.question2] ??
                    "",
                onChanged: (label) {
                  setState(() {
                    final key = _formController.QUESTION2_CHOICES.entries
                        .firstWhere((e) => e.value == label)
                        .key;
                    _formController.question2 = key;
                  });
                },
              ),
              const SizedBox(height: 20),
              customTypeSelector(
                context: context,
                text: "Which are types of load restraint breaches?",
                hintText:
                    "Select an option - Which are types of load restraint breaches?",
                dropdownTypes:
                    _formController.QUESTION3_CHOICES.values.toList(),
                selectedValue: _formController
                        .QUESTION3_CHOICES[_formController.question3] ??
                    "",
                onChanged: (label) {
                  setState(() {
                    final key = _formController.QUESTION3_CHOICES.entries
                        .firstWhere((e) => e.value == label)
                        .key;
                    _formController.question3 = key;
                  });
                },
              ),
              const SizedBox(height: 20),
              _declaration(
                "Should you suspect a breach, do you continue your journey?",
                _formController.question4,
                (val) => setState(() => _formController.question4 = val),
              ),
              const SizedBox(height: 20),
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
                    onPressed: () {
                      setState(() {
                        _formController.clearSignature();
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 80),
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

  Widget _declaration(String text, bool? value, Function(bool?) onChanged) {
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
            bool? val = switch (answer) {
              DeclarationAnswer.yes => true,
              DeclarationAnswer.no => false,
              null => null,
            };
            onChanged(val);
          },
        ),
        const SizedBox(height: 20),
      ],
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
}
