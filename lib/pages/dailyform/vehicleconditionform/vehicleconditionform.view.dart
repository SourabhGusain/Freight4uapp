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

class VehileconditionPage extends StatefulWidget {
  const VehileconditionPage({super.key});

  @override
  State<VehileconditionPage> createState() => _VehileconditionPageState();
}

class _VehileconditionPageState extends State<VehileconditionPage> {
  int _currentIndex = 0;
  late SignatureController _signatureController;
  String _selectedSite = '';
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
                "Vehicle Condition Report",
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textH1("Forms:"),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 50,
                      child: textField("Driver Full Name"),
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
                              controller: _dateController,
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
                              controller: _timeController,
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
                        dropdownTypes: ['Day Shift', 'Night Shift'],
                        selectedValue: _selectedSite,
                        onChanged: (value) {
                          setState(() {
                            _selectedSite = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(height: 50, child: textField("Registration")),
                    const SizedBox(height: 15),
                    SizedBox(height: 50, child: textField("Odometer Reading")),
                    const SizedBox(height: 15),
                    SizedBox(height: 50, child: textField("Site Manager")),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        textH3("CATEGORY", font_weight: FontWeight.w400),
                        textH3(" *",
                            font_size: 18,
                            font_weight: FontWeight.w400,
                            color: Colors.red)
                      ],
                    ),
                    buildCommentTextField(
                      // controller: myController,
                      hintText: "Type here...",
                      maxLines: null, // for unlimited lines
                      fillColor: Colors.white,
                      borderColor: Colors.grey,
                      focusedBorderColor: Colors.black,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        textH3("DESCRIPTION", font_weight: FontWeight.w400),
                        textH3(" *",
                            font_size: 18,
                            font_weight: FontWeight.w400,
                            color: Colors.red)
                      ],
                    ),
                    buildCommentTextField(
                      // controller: myController,
                      hintText: "Type here...",
                      maxLines: null, // for unlimited lines
                      fillColor: Colors.white,
                      borderColor: Colors.grey,
                      focusedBorderColor: Colors.black,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        textH3("Comment", font_weight: FontWeight.w400),
                        textH3(" *",
                            font_size: 18,
                            font_weight: FontWeight.w400,
                            color: Colors.red)
                      ],
                    ),
                    buildCommentTextField(
                      // controller: myController,
                      hintText: "Type here...",
                      maxLines: null, // for unlimited lines
                      fillColor: Colors.white,
                      borderColor: Colors.grey,
                      focusedBorderColor: Colors.black,
                    ),
                    const SizedBox(height: 15),
                    textH3("Upload photos here", font_weight: FontWeight.w400),
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
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: darkButton(
                        buttonText("Save", color: whiteColor),
                        primary: primaryColor,
                      ),
                    ),
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
