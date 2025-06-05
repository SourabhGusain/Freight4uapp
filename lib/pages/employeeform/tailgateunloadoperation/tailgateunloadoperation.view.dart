import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/session.dart';
import 'tailgateunloadoperation.controller.dart';

class TailgateUnloadOperationFormPage extends StatefulWidget {
  final Session session;
  const TailgateUnloadOperationFormPage({Key? key, required this.session})
      : super(key: key);

  @override
  State<TailgateUnloadOperationFormPage> createState() =>
      _TailgateUnloadOperationFormPageState();
}

class _TailgateUnloadOperationFormPageState
    extends State<TailgateUnloadOperationFormPage> {
  final TailgateUnloadOperationController _formController =
      TailgateUnloadOperationController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _formController.populateFromSession();
    _formController.init().then((_) {
      setState(() => isLoading = false);
    });
  }

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
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
            "Tailgate Unload Operation",
            onBack: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("Tailgate Unload Operation Form:"),
              const SizedBox(height: 20),
              calendarDateField(
                context: context,
                label: "Date",
                controller: _formController.dateController,
              ),
              const SizedBox(height: 20),
              textField("Name", controller: _formController.nameController),
              const SizedBox(height: 20),
              _declaration(
                "Does the tailgate remote control module have to be removed prior to departing the delivery point?",
                _formController.question1,
                (val) => setState(() => _formController.question1 = val),
              ),
              customTypeSelector(
                context: context,
                text:
                    "Is a tailgate to be in the horizontal position or slightly tilted up during the unloading of stock?",
                hintText:
                    "Select an option - Is a tailgate to be in the horizontal position or slightly tilted up during the unloading of stock?",
                dropdownTypes:
                    _formController.TAILGATE_POSITION_CHOICES.values.toList(),
                selectedValue: _formController
                        .TAILGATE_POSITION_CHOICES[_formController.question2] ??
                    "",
                onChanged: (label) {
                  setState(() {
                    final key = _formController
                        .TAILGATE_POSITION_CHOICES.entries
                        .firstWhere((e) => e.value == label)
                        .key;
                    _formController.question2 = key;
                  });
                },
              ),
              const SizedBox(height: 20),
              customTypeSelector(
                context: context,
                text:
                    "How far from the edge of the tailgate must an operator stand when operating a tailgate?",
                hintText:
                    "Select an option - How far from the edge of the tailgate must an operator stand when operating a tailgate?",
                dropdownTypes: _formController.DISTANCE_CHOICES.values.toList(),
                selectedValue: _formController
                        .DISTANCE_CHOICES[_formController.question3] ??
                    "",
                onChanged: (label) {
                  setState(() {
                    final key = _formController.DISTANCE_CHOICES.entries
                        .firstWhere((e) => e.value == label)
                        .key;
                    _formController.question3 = key;
                  });
                },
              ),
              const SizedBox(height: 20),
              _declaration(
                "Can store personnel operate the tailgate?",
                _formController.question4,
                (val) => setState(() => _formController.question4 = val),
              ),
              customTypeSelector(
                context: context,
                text:
                    "What must you do if a store person or member of the public enters the immediate area of a tailgate unload?",
                hintText:
                    "Select an option - What must you do if a store person or member of the public enters the immediate area of a tailgate unload?",
                dropdownTypes:
                    _formController.PUBLIC_AREA_ACTION_CHOICES.values.toList(),
                selectedValue: _formController.PUBLIC_AREA_ACTION_CHOICES[
                        _formController.question5] ??
                    "",
                onChanged: (label) {
                  setState(() {
                    final key = _formController
                        .PUBLIC_AREA_ACTION_CHOICES.entries
                        .firstWhere((e) => e.value == label)
                        .key;
                    _formController.question5 = key;
                  });
                },
              ),
              const SizedBox(height: 20),
              _declaration(
                "Does the tailgate remote control module have to be removed prior to departing the delivery point?",
                _formController.question6,
                (val) => setState(() => _formController.question6 = val),
              ),
              customTypeSelector(
                context: context,
                text:
                    "What is the maximum number of pallets that can be unloaded at a time on a tailgate?",
                hintText:
                    "Select an option - What is the maximum number of pallets that can be unloaded at a time on a tailgate?",
                dropdownTypes: _formController.PALLET_CHOICES.values.toList(),
                selectedValue:
                    _formController.PALLET_CHOICES[_formController.question7] ??
                        "",
                onChanged: (label) {
                  setState(() {
                    final key = _formController.PALLET_CHOICES.entries
                        .firstWhere((e) => e.value == label)
                        .key;
                    _formController.question7 = key;
                  });
                },
              ),
              const SizedBox(height: 20),
              _declaration(
                "Does the tailgate remote control module have to be removed prior to departing the delivery point?",
                _formController.question8,
                (val) => setState(() => _formController.question8 = val),
              ),
              _declaration(
                "Does the tailgate remote control module have to be removed prior to departing the delivery point?",
                _formController.question9,
                (val) => setState(() => _formController.question9 = val),
              ),
              customTypeSelector(
                context: context,
                text: "When do you report an incident?",
                hintText: "Select an option - When do you report an incident?",
                dropdownTypes:
                    _formController.INCIDENT_REPORT_CHOICES.values.toList(),
                selectedValue: _formController
                        .INCIDENT_REPORT_CHOICES[_formController.question10] ??
                    "",
                onChanged: (label) {
                  setState(() {
                    final key = _formController.INCIDENT_REPORT_CHOICES.entries
                        .firstWhere((e) => e.value == label)
                        .key;
                    _formController.question10 = key;
                  });
                },
              ),
              const SizedBox(height: 20),
              textH3("Signature"),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Signature(
                  controller: _formController.signatureController,
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
                      setState(() {
                        _formController.clearSignature();
                      });
                    },
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
                    if (_formController.signatureController.isEmpty) {
                      await _showErrorDialog('Please provide your signature.');
                      return;
                    }

                    final bytes =
                        await _formController.signatureController.toPngBytes();
                    if (bytes != null) {
                      final tempFile = File(
                        '${Directory.systemTemp.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png',
                      );
                      await tempFile.writeAsBytes(bytes);

                      final success = await _formController.submitForm();
                      if (success) {
                        await _showSuccessDialog(
                            "Form submitted successfully.");
                        Navigator.pop(context);
                      } else {
                        await _showErrorDialog("Submission failed. Try again.");
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
}
