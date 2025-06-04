import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/dailyform/fuelreceiptform/fuelreceiptform.controller.dart';

class FuelReceiptPage extends StatefulWidget {
  const FuelReceiptPage({super.key});

  @override
  State<FuelReceiptPage> createState() => _FuelReceiptPageState();
}

class _FuelReceiptPageState extends State<FuelReceiptPage> {
  final FuelReceiptFormController _formController = FuelReceiptFormController();
  String? fileName;
  bool isBackLoading = false;

  @override
  void initState() {
    super.initState();
    _formController.populateFromSession();
    _formController.dateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    _formController.init().then((_) {
      setState(() {});
    });
  }

  Future<void> _pickFile() async {
    await _formController.pickFuelReceiptFile();
    if (_formController.fuelReceiptFileName != null) {
      setState(() {
        fileName = _formController.fuelReceiptFileName;
      });
    }
  }

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  Future<void> _handleBack() async {
    setState(() {
      isBackLoading = true;
    });

    // Optional small delay so loading spinner is visible
    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFCFDFE),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: secondaryNavBar(context, "Fuel Receipt Form",
              onBack: _handleBack),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("Forms:"),
              const SizedBox(height: 15),
              _buildTextField("Full Name", _formController.nameController),
              const SizedBox(height: 15),
              _buildCalendarDateField(
                  "Date", _formController.dateController, context),
              const SizedBox(height: 15),
              _buildTextField("Rego", _formController.regoController),
              const SizedBox(height: 15),
              _declaration(
                  "Payment made with company fuel card.",
                  _formController.declarationAnswer,
                  (value) => setState(
                      () => _formController.declarationAnswer = value)),
              const SizedBox(height: 15),
              textH3("Upload Fuel Receipt", font_weight: FontWeight.w400),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const Icon(Icons.upload_file, color: Colors.grey),
                        const SizedBox(width: 8),
                        textH3(
                          fileName ?? "Browse File Here",
                          color: blackColor,
                          font_size: 15,
                          font_weight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: darkButton(
                  buttonText("Save", color: whiteColor),
                  primary: primaryColor,
                  onPressed: () => _formController.submitForm(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return SizedBox(
      height: 50,
      child: textField(label, controller: controller),
    );
  }

  Widget _buildCalendarDateField(
      String label, TextEditingController controller, BuildContext context) {
    return SizedBox(
      height: 50,
      child: calendarDateField(
        context: context,
        label: label,
        controller: controller,
      ),
    );
  }

  Widget _declaration(String text, bool? value, Function(bool?) onBoolChanged) {
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
            bool? boolValue = switch (answer) {
              DeclarationAnswer.yes => true,
              DeclarationAnswer.no => false,
              null => null,
            };
            onBoolChanged(boolValue);
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
