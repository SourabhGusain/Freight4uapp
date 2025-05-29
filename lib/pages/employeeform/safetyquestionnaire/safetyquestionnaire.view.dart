import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/widgets/form.dart';
import 'safetyquestionnaire.controller.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/helpers/values.dart';
import 'dart:typed_data';

class WorkHealthSafetyQuestionnairePage extends StatefulWidget {
  Session session = Session();
  WorkHealthSafetyQuestionnairePage({super.key, required this.session});

  @override
  State<WorkHealthSafetyQuestionnairePage> createState() =>
      _WorkHealthSafetyQuestionnairePageState();
}

class _WorkHealthSafetyQuestionnairePageState
    extends State<WorkHealthSafetyQuestionnairePage> {
  final WorkHealthSafetyQuestionnaireController controller =
      WorkHealthSafetyQuestionnaireController();
  final SignatureController signatureController =
      SignatureController(penStrokeWidth: 2, penColor: Colors.black);

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  @override
  void dispose() {
    controller.dispose();
    signatureController.dispose();
    super.dispose();
  }

  Future<void> handleSubmit() async {
    if (signatureController.isNotEmpty) {
      final Uint8List? signature = await signatureController.toPngBytes();
      if (signature != null) {
        await controller.setSignature(signature);
      }
    }

    final success = await controller.submitForm();
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Form submitted successfully!")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to submit the form.")));
    }
  }

  Widget buildDropdown(String label, String currentValue,
      Function(String?) onChanged, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: currentValue.isEmpty ? null : currentValue,
        onChanged: onChanged,
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
        items: items
            .map((val) => DropdownMenuItem(value: val, child: Text(val)))
            .toList(),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {bool readOnly = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
        readOnly: readOnly,
        onTap: onTap,
      ),
    );
  }

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.dateController.text =
          picked.toIso8601String().split('T').first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dropdownOptions = ["Yes", "No", "Unsure"];

    return Scaffold(
      appBar: AppBar(title: Text("Work Health Safety Questionnaire")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField(controller.fullNameController, "Full Name"),
            buildTextField(controller.dateController, "Date",
                readOnly: true, onTap: selectDate),
            buildTextField(controller.locationController, "Location"),
            buildDropdown(
                "Are you a worker under WHS Act?", controller.workerDefinition,
                (val) {
              setState(() => controller.workerDefinition = val ?? '');
            }, dropdownOptions),
            buildDropdown(
                "Are you a PCBU under WHS Act?", controller.pcbuDefinition,
                (val) {
              setState(() => controller.pcbuDefinition = val ?? '');
            }, dropdownOptions),
            buildDropdown(
                "Do you understand your duties?", controller.workerDuty, (val) {
              setState(() => controller.workerDuty = val ?? '');
            }, dropdownOptions),
            buildDropdown("Would failure to assess risk cause harm?",
                controller.failureRiskAssessment, (val) {
              setState(() => controller.failureRiskAssessment = val ?? '');
            }, dropdownOptions),
            buildDropdown("What would you do in a mechanical fault?",
                controller.mechanicalFaultAction, (val) {
              setState(() => controller.mechanicalFaultAction = val ?? '');
            }, [
              "Stop work",
              "Notify supervisor",
              "Ignore",
              "Try fix yourself"
            ]),
            buildDropdown("Consequences of non-compliance?",
                controller.nonComplianceConsequences, (val) {
              setState(() => controller.nonComplianceConsequences = val ?? '');
            }, ["Disciplinary action", "Termination", "Legal action"]),
            buildDropdown(
                "What is PCBU's duty of care?", controller.pcbuDutyOfCare,
                (val) {
              setState(() => controller.pcbuDutyOfCare = val ?? '');
            }, [
              "Provide safe work environment",
              "Provide training",
              "All of the above"
            ]),
            buildDropdown("Failing to assess hazards could result in?",
                controller.failingHazardRiskAssessment, (val) {
              setState(
                  () => controller.failingHazardRiskAssessment = val ?? '');
            }, dropdownOptions),
            buildDropdown("Failing to report risks may lead to?",
                controller.failingReportRisks, (val) {
              setState(() => controller.failingReportRisks = val ?? '');
            }, dropdownOptions),
            buildDropdown("Do you use hierarchy of control?",
                controller.hierarchyOfControlUsed, (val) {
              setState(() => controller.hierarchyOfControlUsed = val ?? '');
            }, dropdownOptions),
            buildDropdown("Is elimination the strongest control?",
                controller.eliminationRiskStrength, (val) {
              setState(() => controller.eliminationRiskStrength = val ?? '');
            }, dropdownOptions),
            buildDropdown("Is a colleague affected by alcohol a risk?",
                controller.colleagueAffectedAlcohol, (val) {
              setState(() => controller.colleagueAffectedAlcohol = val ?? '');
            }, dropdownOptions),
            buildDropdown("Who to contact for safety advice?",
                controller.safeWorkAdviceContact, (val) {
              setState(() => controller.safeWorkAdviceContact = val ?? '');
            }, ["Supervisor", "Safety Rep", "Union", "All of the above"]),
            buildDropdown("Non-compliance with Linfox policies?",
                controller.nonComplianceLinfox, (val) {
              setState(() => controller.nonComplianceLinfox = val ?? '');
            }, dropdownOptions),
            buildDropdown(
                "Non-compliance with WHS Act?", controller.nonComplianceWHSAct,
                (val) {
              setState(() => controller.nonComplianceWHSAct = val ?? '');
            }, dropdownOptions),
            buildDropdown(
                "Would you stop unsafe work?", controller.stopUnsafeWork,
                (val) {
              setState(() => controller.stopUnsafeWork = val ?? '');
            }, dropdownOptions),
            const SizedBox(height: 20),
            Text("Signature",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              height: 150,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Signature(
                  controller: signatureController,
                  backgroundColor: Colors.white),
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () => signatureController.clear(),
                    child: Text("Clear Signature")),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleSubmit,
              child: Text("Submit Form"),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}
