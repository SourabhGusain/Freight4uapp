import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/pages/employeeform/roadassessment/roadassessment.controller.dart';

class RoadAssessmentFormPage extends StatefulWidget {
  final Session session;
  const RoadAssessmentFormPage({super.key, required this.session});

  @override
  State<RoadAssessmentFormPage> createState() => _RoadAssessmentFormPageState();
}

class _RoadAssessmentFormPageState extends State<RoadAssessmentFormPage> {
  final DriverAssessmentController _formController =
      DriverAssessmentController();
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

    _initializeForm();
  }

  Future<void> _initializeForm() async {
    await _formController.init();
    await _formController.populateFromSession();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _signatureController.dispose();
    _formController.dispose();
    super.dispose();
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

  Widget _vehicleCheckField(String label, TextEditingController controller) {
    return Column(
      children: [
        customTypeSelector(
          context: context,
          text: label,
          hintText: label,
          dropdownTypes: ['N/A', 'P', 'F'],
          selectedValue: controller.text,
          onChanged: (val) => setState(() {
            controller.text = val ?? '';
          }),
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
          child: secondaryNavBar(
            context,
            "Driver Assessment Form",
            onBack: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarkdownWidget(
                data: """
**Road assessment training in NSW**\n\n encompasses various courses, including those for occupational therapists becoming driving assessors, Safe System Assessments, and those focusing on road safety risk assessments. These programs equip individuals with the knowledge and skills to evaluate road safety, driving ability, and implement improvements.

---

**Specific training options include:**

- **Occupational Therapy Driving Assessor Courses**  
  These courses train occupational therapists to conduct on-road and off-road driving assessments, including evaluating the need for vehicle modifications and assessing driving skills. The Institute of Driver Health offers online and blended courses for this.

- **Safe System Assessment Framework (SSAF) Training**  
  This training focuses on the Austroads Safe System approach, which aims to eliminate death and serious injury on roads by addressing all aspects of the road system. NTRO Training offers a course on this.

- **Assessing Road Safety Risk on Road Networks**  
  This training provides an overview of infrastructure risk assessments, including the Australian Risk Assessment Program (AusRAP), Australian National Risk Assessment Model (ANRAM), and Austroads Network Design for Road Safety. NTRO Training offers a course on this.

- **AusRAP (Australian Road Assessment Program)**  
  This program, managed by Austroads, provides tools and support to local governments and jurisdictions to improve road safety.

- **Commercial Vehicle Driver Assessment & Rehabilitation Course**  
  This course focuses on assessing and rehabilitating commercial vehicle drivers, often in a 100% online format. The Institute of Driver Health offers a course on this.
""",
                shrinkWrap: true,
                selectable: true,
                config: MarkdownConfig(configs: [
                  const PConfig(textStyle: TextStyle(fontSize: 15)),
                  const H1Config(
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const H2Config(
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ]),
              ),

              const SizedBox(height: 20),

              textH1("Driver Road Assessment Form"),
              const SizedBox(height: 20),

              // Form Fields
              calendarDateField(
                context: context,
                label: "Assessment Date",
                controller: _formController.dateController,
              ),
              const SizedBox(height: 15),
              textField("Full Name",
                  controller: _formController.fullNameController),
              const SizedBox(height: 15),
              textField("Licence Number",
                  controller: _formController.licenceNumberController),
              const SizedBox(height: 15),
              calendarDateField(
                context: context,
                label: "Licence Expiry Date",
                controller: _formController.expiryDateController,
              ),
              const SizedBox(height: 15),
              customTypeSelector(
                context: context,
                text: "State / Province",
                hintText: "State / Province",
                dropdownTypes: [
                  'NSW',
                  'QLD',
                  'NT',
                  'VIC',
                  'WA',
                  'SA',
                  'TAS',
                  'ACT',
                ],
                selectedValue: _formController.stateOfValidationController.text,
                onChanged: (val) {
                  setState(() {
                    _formController.stateOfValidationController.text =
                        val ?? '';
                  });
                },
              ),
              const SizedBox(height: 20),

              textField("Street Address",
                  controller: _formController.streetAddressController),
              const SizedBox(height: 15),
              textField("Street Address 2",
                  controller: _formController.streetAddress2Controller),
              const SizedBox(height: 15),
              textField("City", controller: _formController.cityController),
              const SizedBox(height: 15),
              textField("Postal Code",
                  controller: _formController.postalCodeController),
              const SizedBox(height: 15),

              textField("Buddy Assessor Name",
                  controller: _formController.buddyAssessorNameController),
              const SizedBox(height: 15),
              calendarDateField(
                context: context,
                label: "Buddy Assessor Date",
                controller: _formController.buddyAssessorDateController,
              ),
              const SizedBox(height: 15),

              textField("Vehicle Type",
                  controller: _formController.vehicleTypeController),
              const SizedBox(height: 15),
              textField("Gearbox Type",
                  controller: _formController.gearboxTypeController),
              const SizedBox(height: 15),
              textField("Licence Restrictions",
                  controller: _formController.licenceRestrictionsController),
              const SizedBox(height: 20),

              const Divider(),
              textH2("Driving Behaviour"),
              const SizedBox(height: 15),

              ..._formController.vehicleCheckFields.entries.map(
                (entry) => _vehicleCheckField(entry.key, entry.value),
              ),

              const SizedBox(height: 15),
              textH3("Signature:"),
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
                      await _showErrorDialog('Please provide your signature.');
                      return;
                    }

                    final bytes = await _signatureController.toPngBytes();
                    if (bytes != null) {
                      final tempFile = File(
                        '${Directory.systemTemp.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png',
                      );
                      await tempFile.writeAsBytes(bytes);

                      _formController.signatureFile = tempFile;

                      final success = await _formController.submitForm();
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
}
