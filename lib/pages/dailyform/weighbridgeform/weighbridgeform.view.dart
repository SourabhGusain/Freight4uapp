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
import 'package:Freight4u/pages/dailyform/Weighbridgeform/Weighbridgeform.controller.dart';

class WeighbridgePage extends StatefulWidget {
  const WeighbridgePage({super.key});

  @override
  State<WeighbridgePage> createState() => _WeighbridgePageState();
}

class _WeighbridgePageState extends State<WeighbridgePage> {
  final WeighbridgeController _formController = WeighbridgeController();
  int _currentIndex = 0;
  bool isBackLoading = false;

  @override
  void initState() {
    super.initState();

    _formController.init().then((_) {
      _formController.dateController.text =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
      setState(() {});
    });
    _formController.populateFromSession();
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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FormatController>.reactive(
      viewModelBuilder: () => FormatController(),
      onViewModelReady: (controller) => controller.init(),
      builder: (context, ctrl, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFFFCFDFF),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65),
              child: secondaryNavBar(context, "Weighbridge & Load Pic",
                  onBack: _handleBack),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textH1("Forms:"),
                  const SizedBox(height: 15),

                  // Full Name
                  _buildTextField("Full Name", _formController.nameController),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: _buildCalendarField(
                            "Date", _formController.dateController),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildDepotDropdown(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Driver Name
                  _buildTextField(
                      "Driver Name", _formController.driverNameController),

                  const SizedBox(height: 15),

                  // Weighbridge Docket
                  _buildFileUploadSection(
                    label: "Weighbridge Docket - Upload here",
                    fileName: _formController.weighbridgeFileName,
                    onTap: () async {
                      await _formController.pickWeighbridgeFile();
                      setState(() {});
                    },
                  ),

                  const SizedBox(height: 15),

                  // Load Pic Upload
                  _buildFileUploadSection(
                    label: "Load Pic & Matching Load Sheet - Upload here",
                    fileName: _formController.loadPicFileName,
                    onTap: () async {
                      await _formController.pickLoadPicFile();
                      setState(() {});
                    },
                  ),

                  const SizedBox(height: 150),

                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: darkButton(
                      buttonText("Save", color: whiteColor),
                      primary: primaryColor,
                      onPressed: () async {
                        await _formController.submitWeighbridgeForm(context);
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // bottomNavigationBar: customBottomNavigationBar(
            //   context: context,
            //   selectedIndex: _currentIndex,
            // ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return SizedBox(
      height: 50,
      child: textField(label, controller: controller),
    );
  }

  Widget _buildCalendarField(String label, TextEditingController controller) {
    return SizedBox(
      height: 50,
      child: calendarDateField(
        context: context,
        label: label,
        controller: controller,
      ),
    );
  }

  Widget _buildDepotDropdown() {
    return SizedBox(
      height: 50,
      child: customTypeSelector(
        context: context,
        text: "Select Depot",
        hintText: "Select Depot",
        dropdownTypes: _formController.depotNames,
        selectedValue: _formController.selectedDepot,
        onChanged: (value) {
          setState(() {
            _formController.selectedDepot = value ?? '';
          });
        },
      ),
    );
  }

  Widget _buildFileUploadSection({
    required String label,
    required String? fileName,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textH3(label, font_weight: FontWeight.w400),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
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
      ],
    );
  }
}
