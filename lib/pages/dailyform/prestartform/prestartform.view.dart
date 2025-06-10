import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/dailyform/prestartform/prestartform.controller.dart';

class PrestartformPage extends StatefulWidget {
  const PrestartformPage({super.key});

  @override
  State<PrestartformPage> createState() => _PrestartformPageState();
}

class _PrestartformPageState extends State<PrestartformPage> {
  final PrestartFormController _formController = PrestartFormController();
  int _currentIndex = 0;
  bool isBackLoading = false;
  String? fileName;

  @override
  void initState() {
    super.initState();

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

  Future<void> _showFilePickerOptions({required bool isForVideo}) async {
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
                if (!isForVideo)
                  _buildPickerTile(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: _pickImageFromGallery),
                if (isForVideo)
                  _buildPickerTile(
                    icon: Icons.photo_library,
                    label: 'Video',
                    onTap: () => isForVideo
                        ? _pickVideoFromGallery()
                        : _pickVideoFromGallery(),
                  ),
                _buildPickerTile(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () => isForVideo
                      ? _pickVideoFromCamera()
                      : _pickImageFromCamera(),
                ),
                if (!isForVideo)
                  _buildPickerTile(
                    icon: Icons.insert_drive_file,
                    label: 'File (Documents)',
                    onTap: _pickFile,
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
        _formController.selectedPhoto = file;
        _formController.photoFileName =
            FilePickerHelper.getReadableFileName(file.path);
        fileName = _formController.photoFileName;
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final file = await FilePickerHelper.pickImageFromCamera();
    if (file != null) {
      setState(() {
        _formController.selectedPhoto = file;
        _formController.photoFileName =
            FilePickerHelper.getReadableFileName(file.path);
        fileName = _formController.photoFileName;
      });
    }
  }

  Future<void> _pickFile() async {
    final file = await FilePickerHelper.pickDocumentFile();
    if (file != null) {
      final size = await file.length();
      setState(() {
        _formController.selectedPhoto = file;
        _formController.photoFileName =
            FilePickerHelper.getReadableFileName(file.path, sizeBytes: size);
        fileName = _formController.photoFileName;
      });
    }
  }

  Future<void> _pickVideoFromGallery() async {
    final file = await FilePickerHelper.pickVideoFromGallery();
    if (file != null) {
      setState(() {
        _formController.selectedVideo = file;
        _formController.videoFileName =
            FilePickerHelper.getReadableFileName(file.path);
        fileName = _formController.videoFileName;
      });
    }
  }

  Future<void> _pickVideoFromCamera() async {
    final file = await FilePickerHelper.pickVideoFromCamera();
    if (file != null) {
      setState(() {
        _formController.selectedVideo = file;
        _formController.videoFileName =
            FilePickerHelper.getReadableFileName(file.path);
        fileName = _formController.videoFileName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 252, 253, 255),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: secondaryNavBar(
            context,
            "Pre-Start/Fit for Duty Declaration.",
            onBack: _handleBack,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("Forms:"),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: textField("Full Name",
                    controller: _formController.fullNameController),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: calendarDateField(
                  context: context,
                  label: "Date",
                  controller: _formController.dateController,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: textField(
                        "Rego Name",
                        hintText: "e.g. ABC123",
                        controller: _formController.regoNameController,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              customTypeSelector(
                context: context,
                text: "Select Contractor",
                hintText: "Select Contractor",
                dropdownTypes: _formController.contractorNames,
                selectedValue: _formController.selectedContractor,
                onChanged: (value) {
                  setState(() {
                    _formController.selectedContractor = value;
                  });
                },
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 20),
              textH3("Upload photo here", font_weight: FontWeight.w400),
              GestureDetector(
                onTap: () => _showFilePickerOptions(isForVideo: false),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: _formController.isUploadingPhoto
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: primaryColor,
                            ),
                          )
                        : textH3(
                            _formController.photoFileName ?? "Browse File Here",
                            color: blackColor,
                            font_size: 15,
                            font_weight: FontWeight.w500,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              textH3("Upload Videos here", font_weight: FontWeight.w400),
              GestureDetector(
                onTap: () => _showFilePickerOptions(isForVideo: true),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: _formController.isUploadingVideo
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: primaryColor,
                            ),
                          )
                        : textH3(
                            _formController.videoFileName ?? "Browse File Here",
                            color: blackColor,
                            font_size: 15,
                            font_weight: FontWeight.w500,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  textH1("FIT FOR DUTY DECLARATION:",
                      font_size: 15, font_weight: FontWeight.w600),
                  textH1(" *",
                      font_size: 20,
                      font_weight: FontWeight.bold,
                      color: Colors.red),
                ],
              ),
              const SizedBox(height: 20),
              _declaration(
                  "I have a current and valid\nlicense to operate this\nvehicle.",
                  _formController.hasValidLicense,
                  (val) =>
                      setState(() => _formController.hasValidLicense = val)),
              _declaration(
                  "I am fit to undertake my allocated tasks.",
                  _formController.isFitForTask,
                  (val) => setState(() => _formController.isFitForTask = val)),
              _declaration(
                  "I am not fatigued or suffering any medical condition (that I am aware of) that may affect my ability to drive or complete my allocated tasks",
                  _formController.noMedicalCondition,
                  (val) =>
                      setState(() => _formController.noMedicalCondition = val)),
              _declaration(
                  "I have had 24 hrs. Continuous stationary rest within the last 7 Days",
                  _formController.had24HrRest,
                  (val) => setState(() => _formController.had24HrRest = val)),
              _declaration(
                  "I have had a 10 hour rest break between shifts",
                  _formController.had10HrBreak,
                  (val) => setState(() => _formController.had10HrBreak = val)),
              _declaration(
                  "I have NOT consumed alcohol and/or drugs (prescription) or otherwise that may impair my ability to work and drive",
                  _formController.noSubstanceUse,
                  (val) =>
                      setState(() => _formController.noSubstanceUse = val)),
              _declaration(
                  "To the best of my knowledge, I have had NO driving infringements issued to me in the last 24hrs",
                  _formController.noInfringements,
                  (val) =>
                      setState(() => _formController.noInfringements = val)),
              _declaration(
                  "I am fit to undertake my allocated tasks.",
                  _formController.fitForTaskRepeat,
                  (val) =>
                      setState(() => _formController.fitForTaskRepeat = val)),
              const SizedBox(height: 100),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: darkButton(
                  buttonText("Save", color: whiteColor),
                  primary: primaryColor,
                  onPressed: () {
                    _formController.submitPrestartForm(context);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _declaration(String text, bool? value, Function(bool?) onBoolChanged) {
    DeclarationAnswer? selected = switch (value) {
      true => DeclarationAnswer.yes,
      false => DeclarationAnswer.no,
      null => null,
    };

    return Column(
      children: [
        CustomDeclarationBox(
          text: text,
          selectedAnswer: selected,
          onChanged: (DeclarationAnswer? answer) {
            bool? boolValue = switch (answer) {
              DeclarationAnswer.yes => true,
              DeclarationAnswer.no => false,
              null => null,
            };
            onBoolChanged(boolValue);
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
