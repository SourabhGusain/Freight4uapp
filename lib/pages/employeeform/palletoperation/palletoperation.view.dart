import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/pages/employeeform/palletoperation/palletoperation.controller.dart';

class EPJMPJAssessmentFormPage extends StatefulWidget {
  final Session session;
  const EPJMPJAssessmentFormPage({super.key, required this.session});

  @override
  State<EPJMPJAssessmentFormPage> createState() =>
      _EPJMPJAssessmentFormPageState();
}

class _EPJMPJAssessmentFormPageState extends State<EPJMPJAssessmentFormPage> {
  final EPJMPJAssessmentController _formController =
      EPJMPJAssessmentController();
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

  Widget _yesNoDeclaration(String text, bool? value, Function(bool) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDeclarationBox(
          text: text,
          selectedAnswer: value == null
              ? null
              : (value ? DeclarationAnswer.yes : DeclarationAnswer.no),
          onChanged: (DeclarationAnswer? answer) {
            if (answer != null) {
              onChanged(answer == DeclarationAnswer.yes);
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
          child: secondaryNavBar(context, "EPJ/MPJ Assessment",
              onBack: () => Navigator.pop(context)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("EPJ/MPJ Operations Assessment Form:"),
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
                text: "What must you do before using a manual pallet jack?",
                hintText: "What must you do before using a manual pallet jack?",
                dropdownTypes: [
                  "Inspect for damage or leaks",
                  "Tip to inspect wheels",
                  "Touch up paint",
                  "Notify manager",
                ],
                selectedValue: _formController.selectedQ1ManualPalletCheck,
                onChanged: (value) {
                  setState(() {
                    _formController.selectedQ1ManualPalletCheck = value ?? "";
                  });
                },
              ),
              const SizedBox(height: 20),

              /// Q2
              _yesNoDeclaration(
                "You are allowed to ride on a pallet jack",
                _formController.q2RideOnPalletJack,
                (val) => _formController.q2RideOnPalletJack = val,
              ),

              /// Q3
              customTypeSelector(
                context: context,
                text:
                    "When operating the manual pallet jack, the surface must be?",
                hintText:
                    "When operating the manual pallet jack, the surface must be?",
                dropdownTypes: [
                  "Wood",
                  "Flat and stable",
                  "Smooth",
                  "Shiny",
                ],
                selectedValue: _formController.selectedQ3SurfaceCheck,
                onChanged: (value) {
                  setState(() {
                    _formController.selectedQ3SurfaceCheck = value ?? "";
                  });
                },
              ),
              const SizedBox(height: 20),

              /// Q4
              _yesNoDeclaration(
                "You can push the load by the pallet jack handle to the destination",
                _formController.q4PushWithHandle,
                (val) => _formController.q4PushWithHandle = val,
              ),

              /// Q5
              _yesNoDeclaration(
                "Ensure the load is secure and stable before pulling",
                _formController.q5EnsureLoadStable,
                (val) => _formController.q5EnsureLoadStable = val,
              ),

              /// Q6
              customTypeSelector(
                context: context,
                text: "What do you do if the pallet becomes difficult to move?",
                hintText:
                    "What do you do if the pallet becomes difficult to move?",
                dropdownTypes: [
                  "Nothing",
                  "Ask or break down",
                  "More effort",
                  "Use legs",
                ],
                selectedValue: _formController.selectedQ6IfDifficultToMove,
                onChanged: (value) {
                  setState(() {
                    _formController.selectedQ6IfDifficultToMove = value ?? "";
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
              const SizedBox(height: 100),
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

                      await _formController.submitForm(context);
                    } else {
                      _showErrorDialog('Failed to capture signature.');
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
