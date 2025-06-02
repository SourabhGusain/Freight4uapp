import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/helpers/session.dart';
import 'scissorlifttraining.controller.dart';

class ScissorLiftTrainingPage extends StatefulWidget {
  final Session session;
  const ScissorLiftTrainingPage({super.key, required this.session});

  @override
  State<ScissorLiftTrainingPage> createState() =>
      _ScissorLiftTrainingPageState();
}

class _ScissorLiftTrainingPageState extends State<ScissorLiftTrainingPage> {
  final ScissorLiftTrainingController _formcontroller =
      ScissorLiftTrainingController();
  late SignatureController _signatureController;

  bool isBackLoading = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 3,
      exportBackgroundColor: Colors.transparent,
    );
    _formcontroller.init().then((_) => setState(() {}));
    _loadUserData();
  }

  @override
  void dispose() {
    _formcontroller.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    await _formcontroller.populateFromSession(widget.session);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleBack() async {
    setState(() => isBackLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) Navigator.of(context).pop();
  }

  Widget _dateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: calendarDateField(
        context: context,
        label: label,
        controller: controller,
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
        backgroundColor: const Color.fromARGB(255, 252, 253, 255),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: secondaryNavBar(context, "Scissor Lift Training",
              onBack: _handleBack),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("Scissor Lift Training Form"),
              const SizedBox(height: 20),
              textField(
                "Trainee Organisation",
                controller: _formcontroller.traineeOrganizationnameController,
              ),
              const SizedBox(height: 15),
              textField(
                "Trainee Name",
                controller: _formcontroller.nameController,
              ),
              const SizedBox(height: 15),
              _dateField("Training Date", _formcontroller.dateController),
              textH3("Signature:", font_size: 17, font_weight: FontWeight.w400),
              const SizedBox(height: 15),
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
              const SizedBox(height: 80),
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

                      _formcontroller.signatureFile = file;

                      await _formcontroller.submitForm(context);
                      print(
                          'Signature file: ${_formcontroller.signatureFile?.path}');
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
}
