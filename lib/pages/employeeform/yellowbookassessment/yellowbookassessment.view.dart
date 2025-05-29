import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/widgets/form.dart';
import 'yellowbookassessment.controller.dart';
import 'package:Freight4u/helpers/session.dart';

class YellowBookAssessmentFormPage extends StatefulWidget {
  final Session session;
  const YellowBookAssessmentFormPage({Key? key, required this.session})
      : super(key: key);

  @override
  State<YellowBookAssessmentFormPage> createState() =>
      _YellowBookAssessmentFormPageState();
}

class _YellowBookAssessmentFormPageState
    extends State<YellowBookAssessmentFormPage> {
  late YellowBookAssessmentController controller;
  late TextEditingController _dateController;

  bool _loading = true;

  final Map<String, String> yellowBookChoices = {
    'A':
        'A simple reference to company expectations, policies, procedures, and information that impact on day to day activities at Linfox.',
    'B':
        'A directory of all departments, phone numbers and email addresses of staff.',
    'C': 'A list of all Safe Working Procedures at Linfox.',
    'D': 'A record of training completed',
  };

  late SignatureController _signatureController;

  @override
  void initState() {
    super.initState();

    controller = YellowBookAssessmentController();

    _signatureController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 3,
      exportBackgroundColor: Colors.white,
    );

    _dateController = TextEditingController();

    controller.init().then((_) {
      // Initialize _dateController text with formatted date
      _dateController.text =
          DateFormat('yyyy-MM-dd').format(controller.selectedDate);
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _signatureController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != controller.selectedDate) {
      setState(() {
        controller.selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _clearSignature() {
    _signatureController.clear();
  }

  Future<void> _onSubmit() async {
    await controller.submitForm(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: secondaryNavBar(
            context,
            "Yellow Book Assessment",
            onBack: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("Yellow Book Assessment Form:"),
              const SizedBox(height: 20),

              // Dropdown for question 1

              // Name TextField
              textField(
                "Name",
                controller: controller.nameController,
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 20),

              calendarDateField(
                  context: context, label: "Date", controller: _dateController),
              const SizedBox(height: 20),
              customTypeSelector(
                context: context,
                text: "What is Yellow Book?",
                hintText: "What is Yellow Book?",
                dropdownfontsize: 14.0,
                dropdownTypes: yellowBookChoices.entries
                    .map((e) => "${e.key}. ${e.value}")
                    .toList(),
                selectedValue: controller.selectedQuestion1 == null
                    ? ''
                    : "${controller.selectedQuestion1}. ${yellowBookChoices[controller.selectedQuestion1]!}",
                onChanged: (value) {
                  if (value != null && value.isNotEmpty) {
                    final key = value.substring(0, 1);
                    setState(() {
                      controller.selectedQuestion1 = key;
                    });
                  }
                },
              ),

              const SizedBox(height: 350),

              SizedBox(
                height: 45,
                width: double.infinity,
                child: darkButton(
                  buttonText("Submit", color: whiteColor),
                  primary: primaryColor,
                  onPressed: _onSubmit,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
