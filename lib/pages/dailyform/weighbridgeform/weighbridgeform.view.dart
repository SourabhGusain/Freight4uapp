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

class WeighbridgePage extends StatefulWidget {
  const WeighbridgePage({super.key});

  @override
  State<WeighbridgePage> createState() => _WeighbridgePageState();
}

class _WeighbridgePageState extends State<WeighbridgePage> {
  int _currentIndex = 0;

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
                "Weighbridge & Load Pic",
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
                      child: textField("Full Name"),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: textField(
                              "Date",
                              hintText: "i.e DD/MM/YYYY",
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: customTypeSelector(
                              context: context,
                              text: "Select Depo",
                              hintText: "Depo",
                              dropdownTypes: ['Day Shift', 'Night Shift'],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(height: 50, child: textField("Driver Name")),
                    const SizedBox(height: 15),
                    textH3("Weighbridge Docket- Upload here",
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
                    const SizedBox(height: 15),
                    textH3("Load Pic & Matching Load Sheet - Upload here",
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
