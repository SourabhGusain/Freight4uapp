import 'dart:io';
import 'package:flutter/material.dart';
import 'fitnesschecklist.controller.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/helpers/values.dart';

class FitnessChecklistFormPage extends StatefulWidget {
  final Session session;
  const FitnessChecklistFormPage({super.key, required this.session});

  @override
  State<FitnessChecklistFormPage> createState() =>
      _FitnessChecklistFormPageState();
}

class _FitnessChecklistFormPageState extends State<FitnessChecklistFormPage> {
  final FitnessChecklistController _formController =
      FitnessChecklistController();
  late SignatureController _signatureController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 3,
      exportBackgroundColor: Colors.transparent,
    );
    _formController.init().then((_) async {
      await _formController.populateFromSession(widget.session);
      if (mounted) setState(() => isLoading = false);
    });
  }

  @override
  void dispose() {
    _signatureController.dispose();
    _formController.dispose();
    super.dispose();
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
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
          body: Center(child: CircularProgressIndicator.adaptive()));
    }

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: secondaryNavBar(context, "A Drivers Fit for Duty Checklist",
              onBack: _handleBack),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("A Drivers Fit for Duty Checklist Form:"),
              const SizedBox(height: 15),
              SizedBox(
                height: 50,
                child: textField(
                  "Driver Name",
                  controller: _formController.driverNameController,
                ),
              ),
              const SizedBox(height: 15),
              calendarDateField(
                context: context,
                label: "Date",
                controller: _formController.dateController,
              ),
              const SizedBox(height: 15),
              textH3("Basic Fitness Checklist:"),
              const SizedBox(height: 15),
              _declaration(
                "Are you presenting yourself for duty in a physical and fit state of work?",
                _formController.fitForDutyController,
                () => setState(() {}),
              ),
              _declaration(
                "Do you believe you are free from stress, emotional and mentally fit for work?",
                _formController.mentallyFitController,
                () => setState(() {}),
              ),
              _declaration(
                "Are you free from tiredness resulting from a second job, other driving, sleep disorder or insufficient sleep?",
                _formController.freeFromTirednessController,
                () => setState(() {}),
              ),
              _declaration(
                " Are you free from tired contributed by recreational or sporting activities?",
                _formController.freeFromRecreationalFatigueController,
                () => setState(() {}),
              ),
              _declaration(
                "Is your visual acuity okay and in order for any type of journey night/day?",
                _formController.visualAcuityOkController,
                () => setState(() {}),
              ),
              _declaration(
                "If there has been any recent incidents of blackouts, fainting, diabetes, epilepsy or heart disease have they been report?",
                _formController.medicalIncidentReportedController,
                () => setState(() {}),
              ),
              _declaration(
                "If there has been any recent incidents resulting from age-related decline have they been reported?",
                _formController.recentIncidentsAgeRelatedDeclineController,
                () => setState(() {}),
              ),
              _declaration(
                "Do you continue to undergo periodic driver medical examinations?",
                _formController.periodicDriverMedicalExaminationsController,
                () => setState(() {}),
              ),
              _declaration(
                " Are you aware of the available rest areas and amenities along you route?",
                _formController.availableRestAreasAndAmenitiesController,
                () => setState(() {}),
              ),
              _declaration(
                "Are you able to receive welfare checks throughout the journey?",
                _formController.receiveWelfareChecksController,
                () => setState(() {}),
              ),
              _declaration(
                "Will you be using a suitable, well ventilated, air conditioned and roadworthy vehicle?",
                _formController.suitableVentilatedAirConditionedController,
                () => setState(() {}),
              ),
              const SizedBox(height: 15),
              textH3(
                  "Drivers are required to have ZERO alcohol or prohibited drugs in their system:"),
              const SizedBox(height: 15),
              _declaration(
                "Do you consider your blood alcohol level below the prescribed limit?",
                _formController.bloodAlcoholLevelController,
                () => setState(() {}),
              ),
              _declaration(
                "Would you pass if subject to a breath and skills test before starting work?",
                _formController.breathSkillsTestController,
                () => setState(() {}),
              ),
              _declaration(
                " Are you unimpaired or free of un-prescribed drugs or medication?",
                _formController.drugsOrMedicationController,
                () => setState(() {}),
              ),
              const SizedBox(height: 15),
              _declaration(
                "Are you unimpaired by over the counter drugs?",
                _formController.counterDrugsController,
                () => setState(() {}),
              ),
              const SizedBox(height: 15),
              textH3(
                  "Drivers are required to present themselves not impaired by fatigue:"),
              const SizedBox(height: 15),
              _declaration(
                "Drivers must have 10 hours minimum continuous break in the 24 hours with at least a minimum uninterrupted 6 hours of sleep before starting a new shift.",
                _formController.minimumContinuousBreakController,
                () => setState(() {}),
              ),
              _declaration(
                "Drivers should have more than 27 hours non work time (rest) in the last 72 hour week",
                _formController.nonWorkTimeController,
                () => setState(() {}),
              ),
              _declaration(
                "Drivers can work over 14 hours work a day even if I’ve only had 1 hour break.",
                _formController.workADayController,
                () => setState(() {}),
              ),
              _declaration(
                "Drivers need to have a rest for 30 minutes for each 5 hours you intend to work.",
                _formController.restFor30MinutesController,
                () => setState(() {}),
              ),
              _declaration(
                "I have a current and valid\nlicense to operate this\nvehicle.",
                _formController.validLicenceClassController,
                () => setState(() {}),
              ),
              const SizedBox(height: 15),
              textH3("Signature:", font_size: 17, font_weight: FontWeight.w400),
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
                    onPressed: () {
                      _signatureController.clear();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: darkButton(
                  buttonText("Save", color: whiteColor),
                  primary: primaryColor,
                  onPressed: () async {
                    if (_signatureController.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Please provide your signature.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    final signatureBytes =
                        await _signatureController.toPngBytes();
                    if (signatureBytes != null) {
                      final tempDir = Directory.systemTemp;
                      final tempPath =
                          '${tempDir.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png';
                      final file = File(tempPath);
                      await file.writeAsBytes(signatureBytes);

                      _formController.signatureFile = file;

                      await _formController.submitChecklist(context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Error"),
                          content: const Text("Failed to export signature."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBack() {
    Navigator.of(context).pop();
  }
}
