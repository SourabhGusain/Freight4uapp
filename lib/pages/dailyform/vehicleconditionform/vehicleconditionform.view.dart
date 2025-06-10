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
  String? fileName;

  @override
  void initState() {
    super.initState();
    _formController.populateFromSession();
    _signatureController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 3,
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

    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _showFilePickerOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: textH2(
                    "Select File Source",
                    font_size: 16,
                    font_weight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPickerTile(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: _pickImageFromGallery,
                ),
                _buildPickerTile(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: _pickImageFromCamera,
                ),
                _buildPickerTile(
                  icon: Icons.insert_drive_file,
                  label: 'File (Documents)',
                  onTap: _pickFile,
                ),
                const Divider(height: 24),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: const Icon(Icons.close, color: Colors.grey),
                  title: textH2(
                    'Cancel',
                    font_size: 16,
                    font_weight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPickerTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        leading: CircleAvatar(
          backgroundColor: primaryColor.withOpacity(0.08),
          child: Icon(icon, color: primaryColor),
        ),
        title: textH2(
          label,
          font_size: 15,
          font_weight: FontWeight.w500,
        ),
        onTap: () {
          Navigator.of(context).pop();
          onTap();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hoverColor: primaryColor.withOpacity(0.05),
        splashColor: primaryColor.withOpacity(0.1),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final file = await FilePickerHelper.pickImageFromGallery();
    if (file != null) {
      setState(() {
        _formController.selectedFile = file;
        _formController.selectedfileName =
            FilePickerHelper.getReadableFileName(file.path);
        fileName = _formController.selectedfileName;
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final file = await FilePickerHelper.pickImageFromCamera();
    if (file != null) {
      setState(() {
        _formController.selectedFile = file;
        _formController.selectedfileName =
            FilePickerHelper.getReadableFileName(file.path);
        fileName = _formController.selectedfileName;
      });
    }
  }

  Future<void> _pickFile() async {
    final file = await FilePickerHelper.pickDocumentFile();
    if (file != null) {
      final size = await file.length();
      setState(() {
        _formController.selectedFile = file;
        _formController.selectedfileName =
            FilePickerHelper.getReadableFileName(file.path, sizeBytes: size);
        fileName = _formController.selectedfileName;
      });
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
                      hintText: "Select Site",
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
                    onTap: _showFilePickerOptions,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: textH3(
                          _formController.selectedfileName ??
                              "Browse File Here",
                          color: blackColor,
                          font_size: 15,
                          font_weight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  textH3(
                    "Signature:",
                  ),
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

                  const SizedBox(height: 15),

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

                  const SizedBox(height: 100),

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
                  const SizedBox(height: 20),
                ],
              ),
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
