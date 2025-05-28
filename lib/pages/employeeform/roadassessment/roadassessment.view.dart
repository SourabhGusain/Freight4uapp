import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
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
    _formController.init().then((_) async {
      await _formController.populateFromSession();
      if (mounted) setState(() => isLoading = false);
    });
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
          onChanged: (val) => setState(() => controller.text = val ?? ''),
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
              textH1("Driver Road Assessment Form"),
              const SizedBox(height: 20),
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
              textField("State of Licence",
                  controller: _formController.stateOfValidationController),
              const SizedBox(height: 15),
              textField("Street Address",
                  controller: _formController.streetAddressController),
              const SizedBox(height: 15),
              textField("Street Address 2",
                  controller: _formController.streetAddress2Controller),
              const SizedBox(height: 15),
              textField("City", controller: _formController.cityController),
              const SizedBox(height: 15),
              customTypeSelector(
                context: context,
                text: "State / Province",
                hintText: "State / Province",
                dropdownTypes: [
                  'NSW', // New South Wales
                  'QLD', // Queensland
                  'NT', // Northern Territory
                  'VIC', // Victoria
                  'WA', // Western Australia
                  'SA', // South Australia
                  'ACT', // Australian Capital Territory
                  'TAS', // Tasmania
                ],
                selectedValue: _formController.stateOrProvinceController.text,
                onChanged: (val) => setState(() =>
                    _formController.stateOrProvinceController.text = val ?? ''),
              ),
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
              const SizedBox(height: 30),
              textH2("Vehicle Check:"),
              Divider(),
              const SizedBox(height: 15),
              ..._formController.vehicleCheckFields.entries
                  .map((entry) => _vehicleCheckField(entry.key, entry.value)),
              const SizedBox(height: 15),
              textH3("Signature :"),
              const SizedBox(height: 5),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Signature(
                  controller: _signatureController,
                  height: 200,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
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
              const SizedBox(height: 80),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: darkButton(
                  buttonText("Submit", color: whiteColor),
                  primary: primaryColor,
                  onPressed: () async {
                    final success = await _formController.submitForm(context);
                    // if (!success) {
                    //   await _showErrorDialog(
                    //       "Please fill in all fields and sign the form.");
                    // } else {
                    //   await _showSuccessDialog("Form submitted successfully!");
                    // }
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
