import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'covidquestionnaire.controller.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/helpers/widgets.dart';

class CovidQuestionnairePage extends StatefulWidget {
  final Session session;
  const CovidQuestionnairePage({super.key, required this.session});

  @override
  State<CovidQuestionnairePage> createState() => _CovidQuestionnairePageState();
}

class _CovidQuestionnairePageState extends State<CovidQuestionnairePage> {
  final CovidQuestionnaireController controller =
      CovidQuestionnaireController();
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
            "COVID-19 Questionnaire",
            onBack: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("COVID-19 Questionnaire Form :"),
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
              _declaration(
                "1. Vehicles are to be disinfected before and after every load.",
                controller.vehiclesDisinfected,
                (val) => setState(() => controller.vehiclesDisinfected = val),
              ),
              _declaration(
                "2. If you suspect you are affected by or around COVID-19, continue your shift then isolate.",
                controller.continueShiftThenIsolate,
                (val) =>
                    setState(() => controller.continueShiftThenIsolate = val),
              ),
              _declaration(
                "3. You are only to disinfect and clean your vehicle before a load.",
                controller.disinfectBeforeOnly,
                (val) => setState(() => controller.disinfectBeforeOnly = val),
              ),
              _declaration(
                "4. You should eat your lunch outside rather than in the lunch room.",
                controller.eatLunchOutside,
                (val) => setState(() => controller.eatLunchOutside = val),
              ),
              _declaration(
                "5. You must not attempt a delivery if it is unsafe to do so.",
                controller.noUnsafeDelivery,
                (val) => setState(() => controller.noUnsafeDelivery = val),
              ),
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
              const SizedBox(height: 100),
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
                          '${Directory.systemTemp.path}/covid_signature_${DateTime.now().millisecondsSinceEpoch}.png');
                      await tempFile.writeAsBytes(bytes);
                      controller.signatureFile = tempFile;
                      print(controller.submitCovidQuestionnaireForm());
                      final success =
                          await controller.submitCovidQuestionnaireForm();
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
        const SizedBox(height: 15),
      ],
    );
  }
}
