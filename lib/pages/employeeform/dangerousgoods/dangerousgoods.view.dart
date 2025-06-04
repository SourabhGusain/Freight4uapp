import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/session.dart';
import 'dangerousgoods.controller.dart';

class DangerousGoodsCompetencyPage extends StatefulWidget {
  final Session session;
  const DangerousGoodsCompetencyPage({super.key, required this.session});

  @override
  State<DangerousGoodsCompetencyPage> createState() =>
      _DangerousGoodsCompetencyPageState();
}

class _DangerousGoodsCompetencyPageState
    extends State<DangerousGoodsCompetencyPage> {
  final DangerousGoodsController _controller = DangerousGoodsController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller.init().then((_) {
      _controller.loadUploadDocuments().then((_) {
        setState(() => isLoading = false);
      });
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
        textH3(label, font_size: 13, font_weight: FontWeight.w400),
        buildCommentTextField(
          controller: controller,
          hintText: "Write here...",
          minLines: 6,
          maxLines: null,
          fillColor: Colors.white,
          borderColor: Colors.grey,
          focusedBorderColor: Colors.black,
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDangerousGoodsDocumentLink() {
    if (_controller.uploadDocuments == null) {
      return const Text("Loading documents...");
    }

    final docs = _controller.uploadDocuments!
        .where((doc) => doc.name == "Dangerous Goods Competency")
        .toList();

    if (docs.isEmpty) {
      return const Text("No Dangerous Goods Competency document found.");
    }

    final doc = docs.first;
    final fullUrl = 'https://freight4you.com.au${doc.documentUrl}';

    return Container(
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
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: primaryColor,
                      strokeWidth: 2,
                    ),
                  )
                : GestureDetector(
                    onTap: () async {
                      setState(() => isLoading = true);

                      final uri = Uri.parse(fullUrl);

                      try {
                        final launched = await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );

                        await Future.delayed(const Duration(seconds: 2));

                        if (!launched) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Failed to open document.")),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
                      }

                      setState(() => isLoading = false);
                    },
                    child: textH3(
                      "Read the Dangerous Goods Competency PDF before filling the form",
                      text_border: TextDecoration.underline,
                      color: primaryColor,
                      font_weight: FontWeight.w500,
                    ),
                  ),
          ),
        ],
      ),
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
          child: secondaryNavBar(
            context,
            "Dangerous Goods Competency",
            onBack: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("Dangerous Goods Competency Form:"),
              _buildDangerousGoodsDocumentLink(),
              const SizedBox(height: 15),
              SizedBox(
                height: 50,
                child: textField(
                  "Trainee Name",
                  controller: _controller.nameController,
                ),
              ),
              const SizedBox(height: 25),
              calendarDateField(
                context: context,
                label: "Date",
                controller: _controller.dateController,
              ),
              const SizedBox(height: 15),
              _buildTextField("1. Classification basis",
                  _controller.classificationBasisController),
              _buildTextField(
                  "2. Packaging groups", _controller.packagingGroupsController),
              _buildTextField("3. Subsidiary risks labeling",
                  _controller.subsidiaryRisksLabelingController),
              _buildTextField("4. ADG classes/divisions",
                  _controller.adgClassesDivisionsController),
              _buildTextField("5. Competent authority",
                  _controller.competentAuthorityController),
              _buildTextField("6. Transport preparation steps",
                  _controller.transportPreparationStepsController),
              _buildTextField("7. Placarded passenger exception",
                  _controller.placardedPassengerExceptionController),
              _buildTextField("8. Emergency scenario",
                  _controller.emergencyScenarioController),
              const SizedBox(height: 20),
              textH3("Signature:"),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                height: 200,
                child: Signature(
                  controller: _controller.signatureController,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 30,
                  width: 80,
                  child: darkButton(
                    buttonText("Clear", color: whiteColor, font_size: 12),
                    primary: primaryColor,
                    onPressed: () => _controller.signatureController.clear(),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: darkButton(
                  buttonText("Save", color: whiteColor),
                  primary: primaryColor,
                  onPressed: () async {
                    if (_controller.signatureController.isEmpty) {
                      _showDialog('Error', 'Please provide your signature.');
                      return;
                    }

                    final signatureBytes =
                        await _controller.signatureController.toPngBytes();
                    if (signatureBytes == null) {
                      _showDialog('Error', 'Failed to export signature.');
                      return;
                    }

                    final tempDir = Directory.systemTemp;
                    final tempPath =
                        '${tempDir.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png';
                    final file = File(tempPath);
                    await file.writeAsBytes(signatureBytes);

                    _controller.signatureFile = file;

                    bool success = await _controller.submitForm(context);

                    if (success) {
                      _showDialog('Success', 'Form submitted successfully.',
                          isSuccess: true);
                    } else {
                      _showDialog('Error',
                          'Failed to submit the form. Please try again.');
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

  void _showDialog(String title, String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              if (isSuccess) Navigator.pop(context); // pop page on success
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
