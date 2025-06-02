import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/widgets/form.dart';
import 'safetyquestionnaire.controller.dart';

class WorkHealthSafetyQuestionnairePage extends StatefulWidget {
  final Session session;
  const WorkHealthSafetyQuestionnairePage({super.key, required this.session});

  @override
  State<WorkHealthSafetyQuestionnairePage> createState() =>
      _WorkHealthSafetyQuestionnairePageState();
}

class _WorkHealthSafetyQuestionnairePageState
    extends State<WorkHealthSafetyQuestionnairePage> {
  final WorkHealthSafetyQuestionnaireController controller =
      WorkHealthSafetyQuestionnaireController();
  late SignatureController _signatureController;

  @override
  void initState() {
    super.initState();
    controller.init();
    controller.populateFromSession();
    _signatureController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.dateController.text =
            picked.toIso8601String().split('T').first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: secondaryNavBar(
            context,
            "Work Health Safety Questionnaire",
            onBack: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("Work Health Safety Questionnaire Form :"),
              const SizedBox(height: 20),
              textField("Full Name", controller: controller.fullNameController),
              const SizedBox(height: 15),
              textField(
                "Date",
                controller: controller.dateController,
                readOnly: true,
                onTap: selectDate,
              ),
              const SizedBox(height: 15),
              customTypeSelector(
                context: context,
                text: 'A "worker" under the work, health and safety act is:',
                hintText: 'A "worker" under the work, health and safety act',
                dropdownTypes: [
                  "Only full time staff",
                  "Only casual staff",
                  "All employees, contractors, sub-contractors and apprentices",
                  "Anyone who is not a contractor"
                ],
                selectedValue: controller.workerDefinition ?? '',
                onChanged: (val) =>
                    setState(() => controller.workerDefinition = val ?? ''),
              ),
              const SizedBox(height: 15),
              customTypeSelector(
                context: context,
                text: 'Who is a person conducting a business or undertaking?',
                hintText:
                    'Who is a person conducting a business or undertaking?',
                dropdownTypes: [
                  "Canteen staff",
                  "PCBU or employer",
                  "Your work mates",
                  "No such thing exists"
                ],
                selectedValue: controller.pcbuDefinition ?? '',
                onChanged: (val) =>
                    setState(() => controller.pcbuDefinition = val ?? ''),
              ),
              const SizedBox(height: 15),
              customTypeSelector(
                context: context,
                text: 'Duty of a worker includes?',
                hintText: 'Duty of a worker includes?',
                dropdownTypes: [
                  "Ensuring health and safety themselves",
                  "Ensuring acts and commissions to not present risks to others",
                  "Complying with any instruction or policy of the work place",
                  "All of the above"
                ],
                selectedValue: controller.workerDuty ?? '',
                onChanged: (val) =>
                    setState(() => controller.workerDuty = val ?? ''),
              ),
              const SizedBox(height: 15),
              customTypeSelector(
                context: context,
                text:
                    'Failing to complete risk assessments, maintenance reports and reporting defective equipment is?',
                hintText:
                    'Failing to complete risk assessments, maintenance reports and reporting defective equipment is?',
                dropdownTypes: [
                  "Creating risk to other in the work place",
                  "Normal practise at Linfox",
                  "Not my problem",
                  "None of these"
                ],
                selectedValue: controller.failureRiskAssessment ?? '',
                onChanged: (val) => setState(
                    () => controller.failureRiskAssessment = val ?? ''),
              ),
              const SizedBox(height: 15),
              customTypeSelector(
                context: context,
                text:
                    'At the end of my shift, I detect mechanical faults with my vehicle, I should:',
                hintText:
                    'At the end of my shift, I detect mechanical faults with my vehicle, I should:',
                dropdownTypes: [
                  "Not my problem",
                  "Make sure no one sees the trouble",
                  "Not report it to stay out of trouble",
                  "Report it as required as a worker under WHS law"
                ],
                selectedValue: controller.mechanicalFaultAction ?? '',
                onChanged: (val) => setState(
                    () => controller.mechanicalFaultAction = val ?? ''),
              ),
              const SizedBox(height: 15),
              customTypeSelector(
                context: context,
                text:
                    'Non compliance with Work Health and Safety laws can result in:',
                hintText:
                    'Non compliance with Work Health and Safety laws can result in:',
                dropdownTypes: [
                  "Dismissal of a worker in a workplace",
                  "Penalties and fines to workers from Safework NSW",
                  "Performance management with HR",
                  "All of the above."
                ],
                selectedValue: controller.nonComplianceConsequences ?? '',
                onChanged: (val) => setState(
                    () => controller.nonComplianceConsequences = val ?? ''),
              ),
              const SizedBox(height: 15),
              customTypeSelector(
                context: context,
                text: 'A PCBU must provide a primary duty of care for:',
                hintText: 'A PCBU must provide a primary duty of care for:',
                dropdownTypes: [
                  "Managers only",
                  "All workers and other persons at the work place",
                  "Full time employees only",
                  "Company directors only"
                ],
                selectedValue: controller.pcbuDutyOfCare ?? '',
                onChanged: (val) =>
                    setState(() => controller.pcbuDutyOfCare = val ?? ''),
              ),
              const SizedBox(height: 15),
              customTypeSelector(
                context: context,
                text:
                    'If I am failing to complete hazard and risk assessments as required by Linfox I am?',
                hintText:
                    'If I am failing to complete hazard and risk assessments as required by Linfox I am?',
                dropdownTypes: [
                  "Not complying with Work Health and Safety Laws",
                  "Placing other workers at risk of injury and even",
                  "All of the above"
                ],
                selectedValue: controller.failingHazardRiskAssessment ?? '',
                onChanged: (val) => setState(
                    () => controller.failingHazardRiskAssessment = val ?? ''),
              ),
              const SizedBox(height: 15),
              customTypeSelector(
                context: context,
                text:
                    'By failing to report known risks and hazards in the workplace is:',
                hintText:
                    'By failing to report known risks and hazards in the workplace is:',
                dropdownTypes: [
                  "Placing the community at risk",
                  "Placing my job at risk",
                  "Placing workers at risk",
                  "All of the above"
                ],
                selectedValue: controller.failingReportRisks ?? '',
                onChanged: (val) =>
                    setState(() => controller.failingReportRisks = val ?? ''),
              ),
              const SizedBox(height: 15),
              customTypeSelector(
                context: context,
                text: 'The "Hierarchy of control" is used:',
                hintText: 'The "Hierarchy of control" is used:',
                dropdownTypes: [
                  "Only in textbooks",
                  "At every opportunity when risk has been identified",
                  "Only on training days",
                  "Only if a manager tells me to"
                ],
                selectedValue: controller.hierarchyOfControlUsed ?? '',
                onChanged: (val) => setState(
                    () => controller.hierarchyOfControlUsed = val ?? ''),
              ),
              const SizedBox(height: 15),
              customTypeSelector(
                context: context,
                text: 'Elimination of identified risks at work is:',
                hintText: 'Elimination of identified risks at work is:',
                dropdownTypes: [
                  "The strongest control measure",
                  "The 2nd strongest control measure",
                  "The 4th strongest control measure",
                  "Not required"
                ],
                selectedValue: controller.eliminationRiskStrength ?? '',
                onChanged: (val) => setState(
                    () => controller.eliminationRiskStrength = val ?? ''),
              ),
              const SizedBox(height: 15),
              customTypeSelector(
                context: context,
                text:
                    'A work colleague comes to work affected by alcohol, failing to report this is:',
                hintText:
                    'A work colleague comes to work affected by alcohol, failing to report this is:',
                dropdownTypes: [
                  "Accepting this as acceptable work practices",
                  "Placing others at work at risk of injury",
                  "Failing to comply with Work Health and Safety Laws",
                  "All of the above"
                ],
                selectedValue: controller.colleagueAffectedAlcohol ?? '',
                onChanged: (val) => setState(
                    () => controller.colleagueAffectedAlcohol = val ?? ''),
              ),
              const SizedBox(height: 15),
              customTypeSelector(
                context: context,
                text:
                    'For information on safe work practices, who can I call for advice?',
                hintText:
                    'For information on safe work practices, who can I call for advice?',
                dropdownTypes: [
                  "Emergency services on 000",
                  "Poisons Information Centre 131 126",
                  "Pizza Hut 131 166",
                  "Safework NSW 131 050"
                ],
                selectedValue: controller.safeWorkAdviceContact ?? '',
                onChanged: (val) => setState(
                    () => controller.safeWorkAdviceContact = val ?? ''),
              ),
              const SizedBox(height: 15),
              customTypeSelector(
                context: context,
                text:
                    'Non-compliance with any safety policies and procedures at Linfox are:',
                hintText:
                    'Non-compliance with any safety policies and procedures at Linfox are:',
                dropdownTypes: [
                  "Not worth worrying about",
                  "Only HR to deal with",
                  "Can be a dangerous incident and reported to Safe Work NSW",
                  "Only between management and the worker"
                ],
                selectedValue: controller.nonComplianceLinfox ?? '',
                onChanged: (val) =>
                    setState(() => controller.nonComplianceLinfox = val ?? ''),
              ),
              const SizedBox(height: 15),
              customTypeSelector(
                context: context,
                text:
                    'Which of these can be deemed as non-compliance with WHS Act and Regulation:',
                hintText:
                    'Which of these can be deemed as non-compliance with WHS Act and Regulation:',
                dropdownTypes: [
                  "Failing to complete and submit risk assessments and reports",
                  "Not reporting damaged plant and equipment to supervisors",
                  "Reporting false information on WHS reports and assessments",
                  "All of the above"
                ],
                selectedValue: controller.nonComplianceWHSAct ?? '',
                onChanged: (val) =>
                    setState(() => controller.nonComplianceWHSAct = val ?? ''),
              ),
              const SizedBox(height: 20),
              textH3("Signature:"),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
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
                width: double.infinity,
                height: 45,
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
                          '${Directory.systemTemp.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png');
                      await tempFile.writeAsBytes(bytes);
                      controller.signatureFile = tempFile;
                      final success = await controller.submitForm();
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
