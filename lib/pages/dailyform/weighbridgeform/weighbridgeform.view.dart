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

enum FileTypeTag { weighbridge, loadPic }

class WeighbridgePage extends StatefulWidget {
  const WeighbridgePage({super.key});

  @override
  State<WeighbridgePage> createState() => _WeighbridgePageState();
}

class _WeighbridgePageState extends State<WeighbridgePage> {
  final WeighbridgeController _formController = WeighbridgeController();
  FileTypeTag? _currentFileTag;
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
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _showFilePickerOptions(FileTypeTag fileTag) async {
    _currentFileTag = fileTag;
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
                const Divider(),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: const Icon(Icons.close,
                      color: Color.fromARGB(255, 71, 69, 69)),
                  title: textH2(
                    'Cancel',
                    font_size: 16,
                    font_weight: FontWeight.w400,
                    color: blackColor.withOpacity(0.7),
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
        final fileName = FilePickerHelper.getReadableFileName(file.path);
        if (_currentFileTag == FileTypeTag.weighbridge) {
          _formController.weighbridgeFile = file;
          _formController.weighbridgeFileName = fileName;
        } else if (_currentFileTag == FileTypeTag.loadPic) {
          _formController.loadPicFile = file;
          _formController.loadPicFileName = fileName;
        }
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final file = await FilePickerHelper.pickImageFromCamera();
    if (file != null) {
      setState(() {
        final fileName = FilePickerHelper.getReadableFileName(file.path);
        if (_currentFileTag == FileTypeTag.weighbridge) {
          _formController.weighbridgeFile = file;
          _formController.weighbridgeFileName = fileName;
        } else if (_currentFileTag == FileTypeTag.loadPic) {
          _formController.loadPicFile = file;
          _formController.loadPicFileName = fileName;
        }
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
            backgroundColor: const Color(0xFFFCFDFF),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65),
              child: secondaryNavBar(
                context,
                "Weighbridge & Load Pic",
                onBack: _handleBack,
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textH1("Forms:"),
                  const SizedBox(height: 15),
                  _buildTextField("Full Name", _formController.nameController),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCalendarField(
                            "Date", _formController.dateController),
                      ),
                      const SizedBox(width: 15),
                      Expanded(child: _buildDepotDropdown()),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                      "Driver Name", _formController.driverNameController),
                  const SizedBox(height: 15),
                  _buildFileUploadSection(
                    label: "Weighbridge Docket - Upload here",
                    fileName: _formController.weighbridgeFileName,
                    onTap: () =>
                        _showFilePickerOptions(FileTypeTag.weighbridge),
                  ),
                  const SizedBox(height: 15),
                  _buildFileUploadSection(
                    label: "Load Pic & Matching Load Sheet - Upload here",
                    fileName: _formController.loadPicFileName,
                    onTap: () => _showFilePickerOptions(FileTypeTag.loadPic),
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
