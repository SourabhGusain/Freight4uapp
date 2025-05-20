import 'dart:io';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/format/format.controller.dart';
import 'package:Freight4u/pages/dailyform/vehicleconditionform/vehicleconditionform.controller.dart';

class VehileconditionPage extends StatefulWidget {
  const VehileconditionPage({super.key});

  @override
  State<VehileconditionPage> createState() => _VehileconditionPageState();
}

class _VehileconditionPageState extends State<VehileconditionPage> {
  int _currentIndex = 0;
  final VehicleConditionFormController _formController =
      VehicleConditionFormController();

  late SignatureController _signatureController;
  bool isBackLoading = false;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 5.0,
      exportBackgroundColor: Colors.transparent,
    );
    DateTime now = DateTime.now();
    _formController.dateController.text = DateFormat('yyyy-MM-dd').format(now);
    _formController.timeController.text = DateFormat('HH:mm').format(now);
    _formController.init().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _formController.dispose();
    _signatureController.dispose();
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
    return ViewModelBuilder<FormatController>.reactive(
      viewModelBuilder: () => FormatController(),
      onViewModelReady: (controller) => controller.init(),
      builder: (context, ctrl, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 252, 253, 255),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65),
              child: secondaryNavBar(context, "Vehicle Condition Report",
                  onBack: _handleBack),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textH1("Forms:"),
                  const SizedBox(height: 15),

                  // Driver Name
                  SizedBox(
                    height: 50,
                    child: textField(
                      "Driver Full Name",
                      controller: _formController.driverNameController,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Date and Time fields
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: calendarDateField(
                            context: context,
                            label: "Date",
                            controller: _formController.dateController,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: calendarTimeField(
                            context: context,
                            label: "Time",
                            controller: _formController.timeController,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    height: 50,
                    child: customTypeSelector(
                      context: context,
                      text: "Select Site",
                      hintText: "Site",
                      dropdownTypes: _formController.siteNames,
                      selectedValue: _formController.selectedSite,
                      onChanged: (value) {
                        setState(() {
                          _formController.selectedSite = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Registration
                  SizedBox(
                    height: 50,
                    child: textField(
                      "Registration",
                      controller: _formController.registrationController,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Odometer Reading
                  SizedBox(
                    height: 50,
                    child: textField(
                      "Odometer Reading",
                      controller: _formController.odometerReadingController,
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Site Manager
                  SizedBox(
                    height: 50,
                    child: textField(
                      "Site Manager",
                      controller: _formController.siteManagerController,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Category Label + TextField
                  labelWithAsterisk("CATEGORY"),
                  buildCommentTextField(
                    controller: _formController.categoryController,
                    hintText: "Type here...",
                    maxLines: null,
                    fillColor: Colors.white,
                    borderColor: Colors.grey,
                    focusedBorderColor: Colors.black,
                  ),

                  const SizedBox(height: 15),

                  // Description
                  labelWithAsterisk("DESCRIPTION"),
                  buildCommentTextField(
                    controller: _formController.descriptionController,
                    hintText: "Type here...",
                    maxLines: null,
                    fillColor: Colors.white,
                    borderColor: Colors.grey,
                    focusedBorderColor: Colors.black,
                  ),

                  const SizedBox(height: 15),

                  // Comments
                  labelWithAsterisk("Comment"),
                  buildCommentTextField(
                    controller: _formController.commentsController,
                    hintText: "Type here...",
                    maxLines: null,
                    fillColor: Colors.white,
                    borderColor: Colors.grey,
                    focusedBorderColor: Colors.black,
                  ),

                  const SizedBox(height: 15),

                  // Upload photo
                  textH3("Upload photos here", font_weight: FontWeight.w400),
                  GestureDetector(
                    onTap: () async {
                      await _formController.pickUploadPhotoFile();
                      setState(() {});
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: textH3(
                          _formController.fileName ?? "Browse File Here",
                          color: blackColor,
                          font_size: 15,
                          font_weight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Signature
                  textH3("Signature:",
                      font_size: 17, font_weight: FontWeight.w400),
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

                  const SizedBox(height: 50),

                  // Save Button
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
                              content:
                                  const Text('Please provide your signature.'),
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
                          _formController.signatureFile = file;

                          await _formController.submitForm(context);
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Error"),
                              content:
                                  const Text("Failed to export signature."),
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
                ],
              ),
            ),
            bottomNavigationBar: customBottomNavigationBar(
              context: context,
              selectedIndex: _currentIndex,
            ),
          ),
        );
      },
    );
  }

  Widget labelWithAsterisk(String label) {
    return Row(
      children: [
        textH3(label, font_weight: FontWeight.w400),
        textH3(" *",
            font_size: 18, font_weight: FontWeight.w400, color: Colors.red),
      ],
    );
  }
}
