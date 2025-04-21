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
  int _currentIndex = 0;
  int _numberOfBreaks = 0;
  String _selectedBreakValue = '';
  List<DeclarationAnswer?> _declarationAnswers = List.filled(8, null);
  late SignatureController _signatureController;
  String _selectedShift = '';
  String _selectedSite = '';
  String _selectedShape = '';
  String _selectedRego = '';

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String? fileName;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        final pickedFile = result.files.first;
        fileName =
            "${pickedFile.name} (${(pickedFile.size / 1024).toStringAsFixed(1)} KB)";
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize the signature controller
    _signatureController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 5.0,
      exportBackgroundColor: Colors.transparent,
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
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
              child: secondaryNavBar(
                context,
                " Runsheet",
              ),
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
                    textH2("Daily Driving & Working Limits:"),
                    const SizedBox(height: 10),
                    textH3(
                        font_weight: FontWeight.w500,
                        "• Maximum 12 hours of driving time allowed within a 14-hour working day (from clock-on to clock-off)."),
                    const SizedBox(height: 5),
                    textH3(
                        font_weight: FontWeight.w500,
                        "• A minimum 30-minute rest break is required before or after 5 hours of work time."),
                    const SizedBox(height: 10),
                    textH2("Weekly Driving & Rest Requirements:"),
                    textH3(
                        font_weight: FontWeight.w500,
                        "• No more than 72 hours of driving and/or work allowed within any 7-day period."),
                    const SizedBox(height: 5),
                    textH3(
                        font_weight: FontWeight.w500,
                        "• A minimum of 24 continuous hours of stationary rest must be taken within that 7-day period."),
                    const SizedBox(height: 10),
                    textH2("Shift Transition Rest:"),
                    textH3(
                        font_weight: FontWeight.w500,
                        "• A mandatory 10-hour rest period is required between finishing a PM shift and commencing the next AM shift."),
                    const SizedBox(height: 10),
                    textH2("IMPORTANT:"),
                    textH3(
                        font_weight: FontWeight.w500,
                        "• If any of the above limits are exceeded, you must STOP WORK IMMEDIATELY and contact your Shift Manager for further instructions."),
                    const SizedBox(height: 10),
                    textH2(
                        "For further information, please refer to the policy or contact management."),
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
                                setState(() {
                                  _selectedShift = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(height: 50, child: textField("Driver Name")),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: textField("Email", hintText: "e.g. xyz@gmail.com"),
                    ),
                    const SizedBox(height: 10),
                    customTypeSelector(
                      context: context,
                      text: "Select Site",
                      hintText: "Site",
                      dropdownTypes: ['Full-time', 'Part-time', 'Freelance'],
                      selectedValue: _selectedSite,
                      onChanged: (value) {
                        setState(() {
                          _selectedSite = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    customTypeSelector(
                      context: context,
                      text: "Select Shape",
                      hintText: "Shape",
                      dropdownTypes: ['Box', 'Flatbed', 'Reefer'],
                      selectedValue: _selectedShape,
                      onChanged: (value) {
                        setState(() {
                          _selectedShape = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    customTypeSelector(
                      context: context,
                      text: "Select Rego",
                      hintText: "Rego",
                      dropdownTypes: ['Full-time', 'Part-time', 'Freelance'],
                      selectedValue: _selectedRego,
                      onChanged: (value) {
                        setState(() {
                          _selectedRego = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: SizedBox(
                              height: 50,
                              child: calendarTimeField(
                                context: context,
                                label: "Start Time",
                                controller: _timeController,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: SizedBox(
                              height: 50,
                              child: calendarTimeField(
                                context: context,
                                label: "End Time",
                                controller: _timeController,
                              ),
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
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 🆕 Updated Selector with persistent value
                    customTypeBreakSelector(
                      context: context,
                      text: "Select Breaks",
                      hintText: "How many breaks taken?",
                      dropdownTypes: ['0', '1', '2', '3', '4'],
                      selectedValue: _selectedBreakValue,
                      onChanged: (value) {
                        setState(() {
                          _selectedBreakValue = value;
                          _numberOfBreaks = int.tryParse(value) ?? 0;
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
                                  controller: _timeController,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: calendarTimeField(
                                  context: context,
                                  label: "Start Time (${index + 1})",
                                  controller: _timeController,
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
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
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
                      // controller: myController,
                      hintText: "Type your comment...",
                      maxLines: null, // for unlimited lines
                      fillColor: Colors.white,
                      borderColor: Colors.grey,
                      focusedBorderColor: Colors.black,
                    ),
                    const SizedBox(height: 10),
                    textH3("Signature:",
                        font_size: 17, font_weight: FontWeight.w400),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
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
                        width: 90,
                        child: darkButton(
                          buttonText("Clear", color: whiteColor, font_size: 10),
                          primary: primaryColor,
                          onPressed: () {
                            _signatureController.clear();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: darkButton(
                        buttonText("Save", color: whiteColor),
                        primary: primaryColor,
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

Widget customTypeBreakSelector({
  required BuildContext context,
  required String text,
  required List<String> dropdownTypes,
  String? hintText,
  String? selectedValue,
  Function(String)? onChanged,
}) {
  return GestureDetector(
    onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                textH1(text,
                    font_size: 20,
                    font_weight: FontWeight.w500,
                    color: blackColor),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dropdownTypes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final dropdownType = dropdownTypes[index];
                    final isSelected = dropdownType == selectedValue;

                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        if (onChanged != null) onChanged(dropdownType);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color.fromARGB(255, 237, 244, 255)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color.fromARGB(255, 0, 123, 255)
                                : Colors.grey.shade300,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textH3(
                              dropdownType,
                              font_size: 16,
                              font_weight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              color: isSelected
                                  ? const Color.fromARGB(255, 0, 123, 255)
                                  : Colors.black87,
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle,
                                  color: primaryColor),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    },
    child: InputDecorator(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textH3(
            selectedValue != null && selectedValue.isNotEmpty
                ? selectedValue
                : (hintText ?? 'Select an option'),
            color: const Color.fromARGB(255, 54, 54, 54),
            font_size: 15,
            font_weight: FontWeight.w400,
          ),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    ),
  );
}
