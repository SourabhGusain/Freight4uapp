import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/login/login.view.dart';
import 'package:Freight4u/pages/format/format.controller.dart';
import 'package:Freight4u/pages/dailyform/runsheetform/runsheetform.controller.dart';

class RunsheetPage extends StatefulWidget {
  const RunsheetPage({super.key});

  @override
  State<RunsheetPage> createState() => _RunsheetPageState();
}

class _RunsheetPageState extends State<RunsheetPage> {
  final RunsheetFormController _formController = RunsheetFormController();

  int _currentIndex = 0;
  int _numberOfBreaks = 0;
  String _selectedBreakValue = '';
  String _selectedShift = '';
  String _selectedSite = '';
  String _selectedShape = '';
  String? fileName;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _regoController = TextEditingController();
  final TextEditingController _loadCountController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  final List<TextEditingController> _breakStartControllers = [];
  final List<TextEditingController> _breakEndControllers = [];

  late SignatureController _signatureController;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        final pickedFile = result.files.first;
        fileName =
            "${pickedFile.name} (${(pickedFile.size / 1024).toStringAsFixed(1)} KB)";
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize Signature Controller
    _signatureController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 5.0,
      exportBackgroundColor: Colors.transparent,
    );

    // Automatically set current date
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Automatically set current time for start and end time
    String formattedTime = DateFormat('HH:mm').format(DateTime.now());
    _startTimeController.text = formattedTime;
    _endTimeController.text = formattedTime;
  }

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _driverNameController.dispose();
    _emailController.dispose();
    _regoController.dispose();
    _loadCountController.dispose();
    _commentController.dispose();

    for (var c in _breakStartControllers) {
      c.dispose();
    }
    for (var c in _breakEndControllers) {
      c.dispose();
    }

    _signatureController.dispose();
    super.dispose();
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
              child: secondaryNavBar(context, " Runsheet"),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textH1(
                        "NSW RUNSHEET INFORMATION – STANDARD HOURS GUIDELINES:"),
                    Divider(),
                    const SizedBox(height: 10),
                    // --- Truncated guidelines content for brevity ---

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
                              controller: _dateController,
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
                              selectedValue: _selectedShift,
                              onChanged: (value) {
                                setState(() => _selectedShift = value);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    SizedBox(
                      height: 50,
                      child: textField("Driver Name",
                          controller: _driverNameController),
                    ),
                    const SizedBox(height: 10),

                    SizedBox(
                      height: 50,
                      child: textField("Email",
                          hintText: "e.g. xyz@gmail.com",
                          controller: _emailController),
                    ),
                    const SizedBox(height: 10),

                    customTypeSelector(
                      context: context,
                      text: "Select Site",
                      hintText: "Site",
                      dropdownTypes: _formController.siteNames,
                      selectedValue: _formController.selectedSite,
                      onChanged: (value) {
                        setState(() => _selectedSite = value);
                      },
                    ),
                    const SizedBox(height: 10),

                    customTypeSelector(
                      context: context,
                      text: "Select Shape",
                      hintText: "Shape",
                      dropdownTypes: _formController.shapeNames,
                      selectedValue: _formController.selectedShape,
                      onChanged: (value) {
                        setState(() => _selectedShape = value);
                      },
                    ),
                    const SizedBox(height: 10),

                    SizedBox(
                      height: 50,
                      child: textField("rego",
                          hintText: "e.g.Au1233", controller: _regoController),
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
                              controller: _startTimeController,
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
                              controller: _endTimeController,
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
                        "Enter how many loads have you done ?",
                        hintText: "e.g. 10, 20, etc.",
                        controller: _loadCountController,
                      ),
                    ),
                    const SizedBox(height: 20),

                    customTypeBreakSelector(
                      context: context,
                      text: "Select Breaks",
                      hintText: "How many breaks taken?",
                      dropdownTypes: ['0', '1', '2', '3', '4'],
                      // selectedValue: _selectedBreakValue,
                      onChanged: (value) {
                        setState(() {
                          _selectedBreakValue = value;
                          _numberOfBreaks = int.tryParse(value) ?? 0;
                          _breakStartControllers.clear();
                          _breakEndControllers.clear();
                          for (int i = 0; i < _numberOfBreaks; i++) {
                            _breakStartControllers.add(TextEditingController());
                            _breakEndControllers.add(TextEditingController());
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    ...List.generate(_numberOfBreaks, (index) {
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
                                  controller: _breakStartControllers[index],
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
                                  controller: _breakEndControllers[index],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    textH3("Upload Load sheet here....",
                        font_weight: FontWeight.w400),
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
                          child: textH3(
                            fileName ?? "Browse File Here",
                            color: blackColor,
                            font_size: 15,
                            font_weight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    textH3("Comment", font_weight: FontWeight.w400),

                    buildCommentTextField(
                      controller: _commentController,
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
                          _formController.submitRunsheetForm(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
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
}
