import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/session.dart';
import 'corform.controller.dart';
import 'package:url_launcher/url_launcher.dart';

class CoRFormPage extends StatefulWidget {
  final Session session;
  const CoRFormPage({super.key, required this.session});

  @override
  State<CoRFormPage> createState() => _CoRFormPageState();
}

class _CoRFormPageState extends State<CoRFormPage> {
  final CoRFormController _controller = CoRFormController();
  bool isLoading = true;
  bool showQuestionnaire = false;

  @override
  void initState() {
    super.initState();
    _controller.init().then((_) {
      setState(() => isLoading = false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        textH3(label, font_size: 13, font_weight: FontWeight.w400),
        buildCommentTextField(
          controller: controller,
          hintText: "write here..",
          minLines: 1,
          maxLines: null,
          fillColor: Colors.white,
          borderColor: Colors.grey,
          focusedBorderColor: Colors.black,
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: secondaryNavBar(context, "Chain of Responsibility",
              onBack: () => Navigator.pop(context)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("Chain of Responsibility Form"),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  launchUrl(
                      Uri.parse('https://yourdomain.com/cor-document.pdf'));
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
                          "Read the Chain of Responsibility PDF before filling the form",
                          text_border: TextDecoration.underline,
                          color: primaryColor,
                          font_weight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: textField(
                  "Full Name",
                  controller: _controller.nameController,
                ),
              ),
              const SizedBox(height: 20),
              textH3("Sign if you read the chain of responsibility :"),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                height: 200,
                child: Signature(
                  controller: _controller.initialSignatureController,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 25,
                  width: 75,
                  child: darkButton(
                    buttonText("Clear", color: whiteColor, font_size: 10),
                    primary: primaryColor,
                    onPressed: () => _controller.initialSignatureController
                        .clear(), // FIXED here
                  ),
                ),
              ),
              if (!showQuestionnaire) ...[
                const SizedBox(height: 130),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: darkButton(
                    buttonText("Next", color: whiteColor),
                    primary: primaryColor,
                    onPressed: () {
                      if (_controller.nameController.text.trim().isEmpty ||
                          _controller.initialSignatureController.isEmpty) {
                        _showErrorDialog(
                            "Please enter your name and sign before proceeding.");
                      } else {
                        setState(() {
                          showQuestionnaire = true;
                        });
                      }
                    },
                  ),
                ),
              ],
              if (showQuestionnaire) ...[
                const SizedBox(height: 40),
                const Divider(color: blackColor, thickness: 0.5),
                const SizedBox(height: 20),
                textH2("Competency Questionnaire:",
                    font_size: 18, font_weight: FontWeight.w400),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: textField(
                    "Trainee Name",
                    controller: _controller.traineeNameController,
                  ),
                ),
                const SizedBox(height: 20),
                calendarDateField(
                  context: context,
                  label: "Date",
                  controller: _controller.traineeDateController,
                ),
                const SizedBox(height: 10),
                _buildTextField("List 3 driver responsibilities",
                    _controller.driverResponsibilitiesController),
                _buildTextField("CoR issue response steps",
                    _controller.corIssueStepsController),
                _buildTextField("Primary duty holder?",
                    _controller.primaryDutyHolderController),
                _buildTextField("Penalties for CoR breach",
                    _controller.corPenaltiesController),
                _buildTextField("What is driver fatigue?",
                    _controller.driverFatigueController),
                _buildTextField(
                    "FRMS components", _controller.frmsComponentsController),
                _buildTextField("If something is wrong, what do you do?",
                    _controller.actionIfSomethingWrongController),
                _buildTextField("Equipment to prevent overloading",
                    _controller.equipmentForOverloadingController),
                _buildTextField("Risks of overloading",
                    _controller.overloadRisksController),
                _buildTextField("3 steps to avoid overloading",
                    _controller.loadNotOverloadingStepsController),
                textH3("Trainee Signature :"),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  height: 200,
                  child: Signature(
                    controller: _controller.traineeSignatureController,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 25,
                    width: 75,
                    child: darkButton(
                      buttonText("Clear", color: whiteColor, font_size: 10),
                      primary: primaryColor,
                      onPressed: () =>
                          _controller.traineeSignatureController.clear(),
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
                      final success = await _controller.submitForm();
                      if (!success) {
                        _showErrorDialog(
                            "Please fill in all fields and sign the form.");
                      } else {
                        _showSuccessDialog("Form submitted successfully!");
                      }
                    },
                  ),
                ),
                const SizedBox(height: 40),
              ]
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

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Close form after success maybe?
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
