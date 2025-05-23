import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/session.dart';
import 'fatigueriskform.controller.dart';

class FatigueRiskManagementFormPage extends StatefulWidget {
  final Session session;
  const FatigueRiskManagementFormPage({super.key, required this.session});

  @override
  State<FatigueRiskManagementFormPage> createState() =>
      _FatigueRiskManagementFormPageState();
}

class _FatigueRiskManagementFormPageState
    extends State<FatigueRiskManagementFormPage> {
  final FatigueRiskManagementController _formController =
      FatigueRiskManagementController();
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

    _formController.init().then((_) {
      setState(() => isLoading = false);
    });
  }

  @override
  void dispose() {
    _signatureController.dispose();
    _formController.dispose();
    super.dispose();
  }

  Widget _yesNoDeclaration(
      String text, String? value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDeclarationBox(
          text: text,
          selectedAnswer: value == null
              ? null
              : (value == 'Yes' ? DeclarationAnswer.yes : DeclarationAnswer.no),
          onChanged: (DeclarationAnswer? answer) {
            if (answer != null) {
              onChanged(answer == DeclarationAnswer.yes ? 'Yes' : 'No');
              setState(() {});
            }
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
          child: secondaryNavBar(context, "Fatigue Risk Management",
              onBack: () => Navigator.pop(context)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("Fatigue Risk Management Form:"),
              const SizedBox(height: 20),
              calendarDateField(
                context: context,
                label: "Date of Acknowledgment",
                controller: _formController.acknowledgmentDateController,
              ),
              const SizedBox(height: 15),
              textField("Name", controller: _formController.nameController),
              const SizedBox(height: 15),

              /// Q1
              customTypeSelector(
                context: context,
                text: "How long are you able to drive without taking a break?",
                hintText: "Select a duration",
                dropdownTypes: _formController.FATIGUE_CHOICES_1,
                selectedValue: _formController.q1DriveWithoutBreak ?? "",
                onChanged: (value) {
                  setState(() {
                    _formController.q1DriveWithoutBreak = value ?? "";
                  });
                },
              ),
              const SizedBox(height: 20),

              /// Q2
              customTypeSelector(
                context: context,
                text: "How long must you rest in between shifts?",
                hintText: "Select a rest duration",
                dropdownTypes: _formController.FATIGUE_CHOICES_2,
                selectedValue: _formController.q2RestBetweenShifts ?? "",
                onChanged: (value) {
                  setState(() {
                    _formController.q2RestBetweenShifts = value ?? "";
                  });
                },
              ),
              const SizedBox(height: 20),

              /// Q3
              customTypeSelector(
                context: context,
                text: "How long is your rest break?",
                hintText: "Select a break duration",
                dropdownTypes: _formController.FATIGUE_CHOICES_3,
                selectedValue: _formController.q3RestBreakDuration ?? "",
                onChanged: (value) {
                  setState(() {
                    _formController.q3RestBreakDuration = value ?? "";
                  });
                },
              ),
              const SizedBox(height: 20),

              /// Q4
              _yesNoDeclaration(
                "Are you able to drive if you have not had sufficient breaks between shifts?",
                _formController.q4DriveNoBreaksBetweenShifts,
                (val) => _formController.q4DriveNoBreaksBetweenShifts = val,
              ),

              /// Q5
              _yesNoDeclaration(
                "Should you advise your manager in changes to circumstances affecting your fatigue?",
                _formController.q5NotifyManagerOfFatigueChange,
                (val) => _formController.q5NotifyManagerOfFatigueChange = val,
              ),

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
                      // _formController.signatureFile = tempFile;

                      await _formController.submitForm();
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
