import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/format/format.controller.dart';
import 'package:Freight4u/pages/dailyform/runsheetform/runsheetform.controller.dart';

class RunsheetPage extends StatefulWidget {
  const RunsheetPage({super.key});

  @override
  State<RunsheetPage> createState() => _RunsheetPageState();
}

class _RunsheetPageState extends State<RunsheetPage> {
  final _formKey = GlobalKey<FormState>();
  final RunsheetFormController _formController = RunsheetFormController();
  bool isBackLoading = false;
  String? fileName;

  int _currentIndex = 0;

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
      onViewModelReady: (ctrl) => ctrl.init(),
      builder: (context, ctrl, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 252, 253, 255),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65),
              child: secondaryNavBar(context, " Runsheet", onBack: _handleBack),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textH1(
                        "NSW RUNSHEET INFORMATION – STANDARD HOURS GUIDELINES:",
                        font_size: 15,
                      ),
                      Divider(),
                      const SizedBox(height: 40),
                      textH1("Forms:"),
                      Divider(),
                      const SizedBox(height: 20),
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
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: customTypeSelector(
                                context: context,
                                text: "Select Shift",
                                hintText: "Select Shift",
                                dropdownTypes: ['Day Shift', 'Night Shift'],
                                selectedValue: _formController.selectedShift,
                                onChanged: (value) {
                                  setState(() {
                                    _formController.selectedShift = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 50,
                        child: textField(
                          "Driver Name",
                          controller: _formController.driverNameController,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 50,
                        child: textField(
                          "Email",
                          hintText: "e.g. xyz@gmail.com",
                          controller: _formController.emailController,
                        ),
                      ),
                      const SizedBox(height: 15),
                      customTypeSelector(
                        context: context,
                        text: "Select Site",
                        hintText: "Select Site",
                        dropdownTypes: _formController.siteDetails
                            .map((e) => e['name'] as String)
                            .toList(),
                        selectedValue: _formController.selectedSite,
                        onChanged: (value) {
                          setState(() {
                            _formController.selectedSite = value ?? '';
                          });
                        },
                      ),
                      if (_formController.selectedSiteObj?['enablePointCity'] ==
                          true) ...[
                        Column(
                          children: [
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: textField(
                                      "Point 1 City Name",
                                      hintText: "e.g. Sydney",
                                      controller:
                                          _formController.point1CityController,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: textField(
                                      "Point 2 City Name",
                                      hintText: "e.g. Newcastle",
                                      controller:
                                          _formController.point2CityController,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                      if (_formController
                              .selectedSiteObj?['enableWaitingTime'] ==
                          true) ...[
                        Column(
                          children: [
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 50,
                              child: textField(
                                "Waiting Time",
                                hintText: "e.g. 20:13:23",
                                controller:
                                    _formController.waitingTimeController,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 15),
                      customTypeSelector(
                        context: context,
                        text: "Select Shape",
                        hintText: "Select Shape",
                        dropdownTypes: _formController.shapeNames,
                        selectedValue: _formController.selectedShape,
                        onChanged: (value) {
                          setState(() {
                            _formController.selectedShape = value;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 50,
                        child: textField(
                          "Rego",
                          hintText: "e.g. Au1233",
                          controller: _formController.regoController,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: calendarTimeField(
                                context: context,
                                label: "Start Time",
                                controller: _formController.startTimeController,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: calendarTimeField(
                                context: context,
                                label: "End Time",
                                controller: _formController.endTimeController,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      textH1("Add Loads & Break: ",
                          font_size: 15, font_weight: FontWeight.w600),
                      Divider(),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        child: textField(
                          "Enter how many loads have you done?",
                          hintText: "e.g. 10, 20, etc.",
                          controller: _formController.loadCountController,
                          // validator removed
                        ),
                      ),
                      const SizedBox(height: 20),
                      customTypeBreakSelector(
                        context: context,
                        text: "Select Breaks",
                        hintText: "How many breaks taken?",
                        dropdownTypes: ['0', '1', '2', '3'],
                        selectedValue: _formController.selectedBreakValue,
                        onChanged: (value) {
                          setState(() {
                            _formController.updateBreaks(value);
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      ...List.generate(_formController.numberOfBreaks, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: calendarTimeField(
                                    context: context,
                                    label: "Start Time (${index + 1})",
                                    controller: _formController
                                        .breakStartControllers[index],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: calendarTimeField(
                                    context: context,
                                    label: "End Time (${index + 1})",
                                    controller: _formController
                                        .breakEndControllers[index],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 5),
                      textH3("Upload load sheet here....",
                          font_weight: FontWeight.w400, font_size: 11),
                      GestureDetector(
                        onTap: _showFilePickerOptions,
                        child: Container(
                          height: 50,
                          width: double.infinity,
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
                      textH3("Comment",
                          font_weight: FontWeight.w400, font_size: 11),
                      buildCommentTextField(
                        controller: _formController.commentController,
                        hintText: "Type your comment...",
                        maxLines: null,
                        fillColor: Colors.white,
                        borderColor: Colors.grey,
                        focusedBorderColor: Colors.black,
                      ),
                      const SizedBox(height: 100),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: darkButton(
                          buttonText("Save", color: whiteColor),
                          primary: primaryColor,
                          onPressed: () {
                            // Validation removed, so just call submit directly
                            _formController.submitRunsheetForm(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
