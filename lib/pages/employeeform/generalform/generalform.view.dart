import 'package:flutter/material.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/values.dart';
import 'generalform.controller.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/helpers/session.dart';

class GeneralFormPage extends StatefulWidget {
  final Session session;
  const GeneralFormPage({super.key, required this.session});

  @override
  State<GeneralFormPage> createState() => _GeneralFormPageState();
}

class _GeneralFormPageState extends State<GeneralFormPage> {
  final GeneralFormController _controller = GeneralFormController();
  bool isBackLoading = false;
  bool isLoading = true; // to show loading state

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await _controller.populateFromSession(widget.session);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _field(String label, TextEditingController controller,
      TextInputType keyboardType,
      {bool obscure = false}) {
    return Column(
      children: [
        const SizedBox(height: 10),
        textField(
          label,
          controller: controller,
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  Widget _dateField(String label, TextEditingController controller) {
    return Column(
      children: [
        const SizedBox(height: 10),
        calendarDateField(
          context: context,
          label: label,
          controller: controller,
        ),
      ],
    );
  }

  Widget _sectionTitle(String label) {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: textH2(label, font_weight: FontWeight.w500),
        ),
        const Expanded(child: Divider(thickness: 1)),
      ],
    );
  }

  Future<void> _handleBack() async {
    setState(() {
      isBackLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // show loading spinner while session loads
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 252, 253, 255),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: secondaryNavBar(context, "General Form", onBack: _handleBack),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("General Employment Information:"),
              const SizedBox(height: 10),
              Column(
                children: [
                  _field(
                      "Name", _controller.nameController, TextInputType.name),
                  _dateField(
                      "Date of Birth", _controller.dateOfBirthController),
                  _field("Street Address", _controller.streetAddressController,
                      TextInputType.streetAddress),
                  _field(
                      "Street Address Line 2",
                      _controller.streetAddressLine2Controller,
                      TextInputType.streetAddress),
                  _field(
                      "City", _controller.cityController, TextInputType.text),
                  _field(
                      "State", _controller.stateController, TextInputType.text),
                  _field("Zip Code", _controller.zipCodeController,
                      TextInputType.number),
                  _field("Area Code", _controller.areaCodeController,
                      TextInputType.number),
                  _field("Phone", _controller.phoneController,
                      TextInputType.phone),
                  _field("Email", _controller.emailController,
                      TextInputType.emailAddress),
                  _field("Password", _controller.passwordController,
                      TextInputType.visiblePassword,
                      obscure: true),
                  _field(
                      "TFN", _controller.tnfController, TextInputType.number),
                  const SizedBox(height: 30),
                  _sectionTitle("Emergency Contact"),
                  const SizedBox(height: 10),
                  _field("Emergency Name", _controller.emergencyNameController,
                      TextInputType.name),
                  _field(
                      "Relationship",
                      _controller.emergencyRelationshipController,
                      TextInputType.text),
                  _field("Area Code", _controller.emergencyAreaCodeController,
                      TextInputType.number),
                  _field("Phone", _controller.emergencyPhoneController,
                      TextInputType.phone),
                  _field(
                      "Street Address",
                      _controller.emergencyStreetAddressController,
                      TextInputType.streetAddress),
                  _field(
                      "Street Address Line 2",
                      _controller.emergencyStreetAddressLine2Controller,
                      TextInputType.streetAddress),
                  _field("City", _controller.emergencyCityController,
                      TextInputType.text),
                  _field("State", _controller.emergencyStateController,
                      TextInputType.text),
                  _field("Zip Code", _controller.emergencyZipCodeController,
                      TextInputType.number),
                  const SizedBox(height: 30),
                  _sectionTitle("Bank Details"),
                  const SizedBox(height: 10),
                  _field(
                      "Name of Institution",
                      _controller.institutionNameController,
                      TextInputType.text),
                  _field("Account Number", _controller.accountNumberController,
                      TextInputType.number),
                  _field("Branch BSB", _controller.branchBSBController,
                      TextInputType.number),
                  const SizedBox(height: 20),
                  _sectionTitle("Superfund"),
                  const SizedBox(height: 10),
                  _field("Superfund", _controller.superfundController,
                      TextInputType.text),
                  _field(
                      "Superfund Number",
                      _controller.superfundNumberController,
                      TextInputType.number),
                  _field(
                      "Account Name",
                      _controller.superfundAccountNameController,
                      TextInputType.name),
                  _field("Branch BSB", _controller.superfundBranchBSBController,
                      TextInputType.number),
                  _field(
                      "Account Number",
                      _controller.superfundAccountNumberController,
                      TextInputType.number),
                  const SizedBox(height: 30),
                  _sectionTitle("Employment History"),
                  const SizedBox(height: 10),
                  _field(
                      "Sites Previously Worked",
                      _controller.sitesPreviouslyWorkedController,
                      TextInputType.text),
                  _field("Coles Induction",
                      _controller.colesInductionController, TextInputType.text),
                  _dateField("Start Date", _controller.startDateController),
                  _dateField("Expiry Date", _controller.expiryDateController),
                  _field("Last Employer in 24 Months",
                      _controller.lastEmployerController, TextInputType.text),
                  _field(
                      "Reason for Leaving",
                      _controller.reasonForLeavingController,
                      TextInputType.text),
                  const SizedBox(height: 30),
                  _sectionTitle("Reference"),
                  const SizedBox(height: 10),
                  _field("Reference First Name",
                      _controller.referenceNameController, TextInputType.name),
                  _field(
                      "Reference Last Name",
                      _controller.referenceLastNameController,
                      TextInputType.name),
                  _field(
                      "Reference Phone Number",
                      _controller.referencePhoneNumberController,
                      TextInputType.phone),
                  const SizedBox(height: 50),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: darkButton(
                      buttonText("Save", color: whiteColor),
                      primary: primaryColor,
                      onPressed: () {
                        // Implement save logic here
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
