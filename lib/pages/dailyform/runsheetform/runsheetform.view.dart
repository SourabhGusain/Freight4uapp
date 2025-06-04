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

  int _currentIndex = 0;
  bool _isPickingFile = false;

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

  Future<void> _pickFile() async {
    setState(() => _isPickingFile = true);
    try {
      await _formController.pickFile();
      setState(() {}); // Refresh to show new file name
    } catch (e) {
      print("File pick error: $e");
    } finally {
      setState(() => _isPickingFile = false);
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
                      const SizedBox(height: 15),
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
                                text: "Select Contractor",
                                hintText: "Shift",
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
                          // validator removed
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 50,
                        child: textField(
                          "Email",
                          hintText: "e.g. xyz@gmail.com",
                          controller: _formController.emailController,
                          // validator removed
                        ),
                      ),
                      const SizedBox(height: 15),
                      customTypeSelector(
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
                      const SizedBox(height: 15),
                      customTypeSelector(
                        context: context,
                        text: "Select Shape",
                        hintText: "Shape",
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
                          // validator removed
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
                        onTap: _isPickingFile ? null : _pickFile,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: _isPickingFile
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: primaryColor,
                                    ),
                                  )
                                : textH3(
                                    _formController.fileName ??
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
                      const SizedBox(height: 40),
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
