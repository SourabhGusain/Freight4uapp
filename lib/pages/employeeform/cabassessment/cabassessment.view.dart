import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:Freight4u/pages/employeeform/cabassessment/cabassessment.controller.dart';

class InCabAssessmentFormPage extends StatefulWidget {
  final Session session;
  const InCabAssessmentFormPage({super.key, required this.session});

  @override
  State<InCabAssessmentFormPage> createState() =>
      _InCabAssessmentFormPageState();
}

class _InCabAssessmentFormPageState extends State<InCabAssessmentFormPage> {
  final InCabAssessmentController _formController = InCabAssessmentController();
  late SignatureController _signatureController;
  bool isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 3,
      exportBackgroundColor: Colors.white,
    );

    _formController.init().then((_) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    });
  }

  @override
  void dispose() {
    _signatureController.dispose();
    _formController.dispose();
    super.dispose();
  }

  Widget _yesNoNASelector(
      String label, String? value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customTypeSelector(
          context: context,
          text: label,
          hintText: label,
          dropdownTypes: _formController.yesNoNAOptions.values.toList(),
          selectedValue:
              value == null ? "" : _formController.yesNoNAOptions[value!] ?? "",
          onChanged: (label) {
            setState(() {
              value = _formController.yesNoNAOptions.entries
                  .firstWhere((e) => e.value == label)
                  .key;
            });
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _assessmentSelector(
      String label, String? value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customTypeSelector(
          context: context,
          text: label,
          hintText: label,
          dropdownTypes: _formController.assessmentOptions.values.toList(),
          selectedValue: value == null
              ? ""
              : _formController.assessmentOptions[value!] ?? "",
          onChanged: (label) {
            setState(() {
              value = _formController.assessmentOptions.entries
                  .firstWhere((e) => e.value == label)
                  .key;
            });
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: secondaryNavBar(context, "In-Cab Assessment",
              onBack: () => Navigator.pop(context)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarkdownWidget(
                data: """
**In-cab Assessment for Heavy Vehicle Licensing in NSW**

An **"in-cab assessment"** in the context of heavy vehicle licensing in NSW (and likely other jurisdictions) refers to a practical, competency-based assessment conducted within the driver's cab while operating a heavy vehicle. This assessment ensures drivers demonstrate the core skills needed for safe and competent operation of their vehicle type.

---

### Purpose:
- To verify that the driver has the necessary skills to safely operate the heavy vehicle, as learned during prior training.  
- To assess the driver's ability to perform various tasks while inside the vehicle, such as pre-drive checks, vehicle operation, and safe driving practices.

---

### Key Aspects:

**Pre-Drive Checks:**  
The assessment will likely include checking gauges, instruments, and ensuring the vehicle is in safe working order before starting.

**Vehicle Control and Operation:**  
This involves demonstrating skills like starting, moving off, shutting down, and securing the vehicle, as well as demonstrating proper control of the vehicle while driving.

**Safe Driving Practices:**  
The assessor will evaluate the driver's ability to maintain crash avoidance space, adhere to road rules, and demonstrate appropriate risk management.

---

### Final Competency Assessment (FCA):  
The in-cab assessment is part of the Final Competency Assessment, which must be conducted by a separate assessor after training.

---

### How to Arrange an Assessment:
- Contact a Transport for NSW accredited Registered Training Organisation (RTO).  
- Arrange the appointment, duration, and fees with the assessor.  
- Training and assessment can sometimes be combined during a session if learning with an assessor, but time spent training must be deducted from the minimum assessment time.
""",
                shrinkWrap: true,
                selectable: true,
                config: MarkdownConfig(configs: [
                  const PConfig(textStyle: TextStyle(fontSize: 15)),
                  const H1Config(
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const H2Config(
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ]),
              ),

              const SizedBox(height: 20),
              textH1("In-Cab Assessment Form:"),
              const SizedBox(height: 20),

              calendarDateField(
                context: context,
                label: "Date",
                controller: _formController.dateController,
              ),
              const SizedBox(height: 15),

              textField("Driver First Name",
                  controller: _formController.driverNameController),
              const SizedBox(height: 15),

              textField("Vehicle Rego",
                  controller: _formController.vehicleRegoController),
              const SizedBox(height: 15),

              customTypeSelector(
                context: context,
                text:
                    "Which of these can be deemed as non-compliance with WHS Act and Regulation:",
                hintText: "Select non-compliance",
                dropdownTypes: _formController.truckTypeOptions.values.toList(),
                selectedValue: _formController.selectedTruckType == null
                    ? ""
                    : _formController.truckTypeOptions[
                            _formController.selectedTruckType!] ??
                        "",
                onChanged: (label) {
                  setState(() {
                    _formController.selectedTruckType = _formController
                        .truckTypeOptions.entries
                        .firstWhere((e) => e.value == label)
                        .key;
                  });
                },
              ),
              const SizedBox(height: 20),

              _yesNoNASelector(
                "1. Overview of the Vehicle, HP Rating, Torque Rating",
                _formController.selectedOverviewVehicle,
                (val) => _formController.selectedOverviewVehicle = val,
              ),

              _yesNoNASelector(
                "2. Transmission & Suspension",
                _formController.selectedTransmissionSuspension,
                (val) => _formController.selectedTransmissionSuspension = val,
              ),

              _yesNoNASelector(
                "3. Raise Bonnet - Under Bonnet Checks",
                _formController.selectedRaiseBonnetChecks,
                (val) => _formController.selectedRaiseBonnetChecks = val,
              ),

              _yesNoNASelector(
                "4. Method of Tilting Cabin",
                _formController.selectedMethodTiltingCabin,
                (val) => _formController.selectedMethodTiltingCabin = val,
              ),

              _yesNoNASelector(
                "5. Walk around Truck covering:",
                _formController.selectedWalkAroundTruck,
                (val) => _formController.selectedWalkAroundTruck = val,
              ),

              _yesNoNASelector(
                "Fuel Tank Capacity:",
                _formController.selectedFuelTankCapacity,
                (val) => _formController.selectedFuelTankCapacity = val,
              ),

              _yesNoNASelector(
                "Isolation Switch (if fitted):",
                _formController.selectedIsolationSwitch,
                (val) => _formController.selectedIsolationSwitch = val,
              ),

              _yesNoNASelector(
                "Tailgate Operation (if fitted):",
                _formController.selectedTailgateOperation,
                (val) => _formController.selectedTailgateOperation = val,
              ),

              _yesNoNASelector(
                "Danger of Tray Swing due to Rear Overhang of Tray",
                _formController.selectedDangerTraySwing,
                (val) => _formController.selectedDangerTraySwing = val,
              ),

              _yesNoNASelector(
                "Danger of Front Corner Overhang on Cornering:",
                _formController.selectedDangerFrontCornerOverhang,
                (val) =>
                    _formController.selectedDangerFrontCornerOverhang = val,
              ),

              _yesNoNASelector(
                "Air Tank Drain Cocks (if applicable)",
                _formController.selectedAirTankDrainCocks,
                (val) => _formController.selectedAirTankDrainCocks = val,
              ),

              _yesNoNASelector(
                "Circuit Breakers (Location in vehicle)",
                _formController.selectedCircuitBreakersLocation,
                (val) => _formController.selectedCircuitBreakersLocation = val,
              ),

              _yesNoNASelector(
                "Trailer Electrical 12/24 Volts",
                _formController.selectedTrailerElectricalVolts,
                (val) => _formController.selectedTrailerElectricalVolts = val,
              ),

              _yesNoNASelector(
                "Trailer Connections and Airlines (Always Twist Locking Collars)",
                _formController.selectedTrailerConnectionsAirlines,
                (val) =>
                    _formController.selectedTrailerConnectionsAirlines = val,
              ),

              _yesNoNASelector(
                "6. Method of Entry and Exit Cabin",
                _formController.selectedMethodEntryExitCabin,
                (val) => _formController.selectedMethodEntryExitCabin = val,
              ),

              _yesNoNASelector(
                "7. Seat Adjustment",
                _formController.selectedSeatAdjustment,
                (val) => _formController.selectedSeatAdjustment = val,
              ),

              _yesNoNASelector(
                "8. Steering Wheel Adjustment & Controls on the Wheel",
                _formController.selectedSteeringWheelAdjustment,
                (val) => _formController.selectedSteeringWheelAdjustment = val,
              ),

              _yesNoNASelector(
                "9. Power Divider & Diff Locks",
                _formController.selectedPowerDividerDiffLocks,
                (val) => _formController.selectedPowerDividerDiffLocks = val,
              ),

              _yesNoNASelector(
                "10. Hand Brake Operation",
                _formController.selectedHandBrakeOperation,
                (val) => _formController.selectedHandBrakeOperation = val,
              ),

              // ASSESSMENT_CHOICES selectors
              // Assessment choices: N/A, P, F
              _assessmentSelector(
                "5. Engine Idle Time: Start vehicle, drives off limiting engine load until engine warms up.",
                _formController.selectedEngineIdleTime,
                (val) => setState(
                    () => _formController.selectedEngineIdleTime = val),
              ),

              _assessmentSelector(
                "6. Mirror Use: Checks mirrors (4-8 seconds)",
                _formController.selectedMirrorUse,
                (val) =>
                    setState(() => _formController.selectedMirrorUse = val),
              ),

              _assessmentSelector(
                "7. Clutch Use: Does not rest foot over clutch pedal",
                _formController.selectedClutchUse,
                (val) =>
                    setState(() => _formController.selectedClutchUse = val),
              ),

              _assessmentSelector(
                "8. Gear Selection",
                _formController.selectedGearSelection,
                (val) =>
                    setState(() => _formController.selectedGearSelection = val),
              ),

              _assessmentSelector(
                "9. Rev-Range: operates within the manufacture's recommended rev range.",
                _formController.selectedRevRange,
                (val) => setState(() => _formController.selectedRevRange = val),
              ),

              _assessmentSelector(
                "10. Engine Brake / Retarder Use: understands the operation and when to use them effectively",
                _formController.selectedEngineBrakeRetarderUse,
                (val) => setState(
                    () => _formController.selectedEngineBrakeRetarderUse = val),
              ),

              _assessmentSelector(
                "11. Check intersections",
                _formController.selectedCheckIntersections,
                (val) => setState(
                    () => _formController.selectedCheckIntersections = val),
              ),

              _assessmentSelector(
                "12. Courtesy to Others: Shows courtesy to other road users (e.g. allows lane changing).",
                _formController.selectedCourtesyToOthers,
                (val) => setState(
                    () => _formController.selectedCourtesyToOthers = val),
              ),

              _assessmentSelector(
                "13. Observation & Planning: Forward planning for traffic flow/ lights.",
                _formController.selectedObservationPlanning,
                (val) => setState(
                    () => _formController.selectedObservationPlanning = val),
              ),

              _assessmentSelector(
                "14. Overtaking: Sufficient indication only when safe.",
                _formController.selectedOvertaking,
                (val) =>
                    setState(() => _formController.selectedOvertaking = val),
              ),

              _assessmentSelector(
                "15. Speed for Environment: drives in accordance to weather/traffic conditions.",
                _formController.selectedSpeedForEnvironment,
                (val) => setState(
                    () => _formController.selectedSpeedForEnvironment = val),
              ),

              _assessmentSelector(
                "16. Hang back Distance: 4 sec rule while moving and min 5 metres while stationary.",
                _formController.selectedHangBackDistance,
                (val) => setState(
                    () => _formController.selectedHangBackDistance = val),
              ),

// Back to Yes/No/N/A selectors for the next batch
              _yesNoNASelector(
                "11. Cruise Control",
                _formController.selectedCruiseControl,
                (val) =>
                    setState(() => _formController.selectedCruiseControl = val),
              ),

              _yesNoNASelector(
                "12. Operation of Driver Buttons/Switches",
                _formController.selectedOperationDriverButtonsSwitches,
                (val) => setState(() => _formController
                    .selectedOperationDriverButtonsSwitches = val),
              ),

              _yesNoNASelector(
                "13. Operation of the Engine Retarder",
                _formController.selectedOperationEngineRetarder,
                (val) => setState(() =>
                    _formController.selectedOperationEngineRetarder = val),
              ),

              _yesNoNASelector(
                "14. Pre-Start Checks",
                _formController.selectedPreStartChecks,
                (val) => setState(
                    () => _formController.selectedPreStartChecks = val),
              ),

              _yesNoNASelector(
                "15. Gearbox Operation",
                _formController.selectedGearboxOperation,
                (val) => setState(
                    () => _formController.selectedGearboxOperation = val),
              ),

              _yesNoNASelector(
                "16. Clutch Operation Check",
                _formController.selectedClutchOperationCheck,
                (val) => setState(
                    () => _formController.selectedClutchOperationCheck = val),
              ),

              _yesNoNASelector(
                "17. Speed Limiter Operation",
                _formController.selectedSpeedLimiterOperation,
                (val) => setState(
                    () => _formController.selectedSpeedLimiterOperation = val),
              ),

              _yesNoNASelector(
                "18. Hill Start Switch Operation",
                _formController.selectedHillStartSwitchOperation,
                (val) => setState(() =>
                    _formController.selectedHillStartSwitchOperation = val),
              ),

              _yesNoNASelector(
                "19. Add Blue Tank Capacity",
                _formController.selectedAddBlueTankCapacity,
                (val) => setState(
                    () => _formController.selectedAddBlueTankCapacity = val),
              ),

              _yesNoNASelector(
                "20. Additional Features",
                _formController.selectedAdditionalFeatures,
                (val) => setState(
                    () => _formController.selectedAdditionalFeatures = val),
              ),

              _yesNoNASelector(
                "21. Air Bag Controls",
                _formController.selectedAirBagControls,
                (val) => setState(
                    () => _formController.selectedAirBagControls = val),
              ),

              textH3("Signature:", font_size: 17, font_weight: FontWeight.w400),
              const SizedBox(height: 15),
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
                          content: const Text('Please provide your signature.'),
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
                      print(
                          'Signature file: ${_formController.signatureFile?.path}');
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Error"),
                          content: const Text("Failed to export signature."),
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
  }
}
