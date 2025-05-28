import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/employeemodels/cabassessment.model.dart';

class InCabAssessmentController {
  final driverNameController = TextEditingController();
  final dateController = TextEditingController();
  final vehicleRegoController = TextEditingController();
  final assessorNameController = TextEditingController();

  String selectedTruckType = "";

  // Choices are Yes, No,  for most fields
  String selectedOverviewVehicle = "";
  String selectedTransmissionSuspension = "";
  String selectedRaiseBonnetChecks = "";
  String selectedMethodTiltingCabin = "";
  String selectedWalkAroundTruck = "";
  String selectedFuelTankCapacity = "";
  String selectedIsolationSwitch = "";
  String selectedTailgateOperation = "";
  String selectedDangerTraySwing = "";
  String selectedDangerFrontCornerOverhang = "";
  String selectedAirTankDrainCocks = "";
  String selectedCircuitBreakersLocation = "";
  String selectedTrailerElectricalVolts = "";
  String selectedTrailerConnectionsAirlines = "";
  String selectedMethodEntryExitCabin = "";
  String selectedSeatAdjustment = "";
  String selectedSteeringWheelAdjustment = "";
  String selectedPowerDividerDiffLocks = "";
  String selectedHandBrakeOperation = "";

  // Assessment choices: , P, F
  String selectedEngineIdleTime = "";
  String selectedMirrorUse = "";
  String selectedClutchUse = "";
  String selectedGearSelection = "";
  String selectedRevRange = "";
  String selectedEngineBrakeRetarderUse = "";
  String selectedCheckIntersections = "";
  String selectedCourtesyToOthers = "";
  String selectedObservationPlanning = "";
  String selectedOvertaking = "";
  String selectedSpeedForEnvironment = "";
  String selectedHangBackDistance = "";

  // Back to Yes/No/
  String selectedCruiseControl = "";
  String selectedOperationDriverButtonsSwitches = "";
  String selectedOperationEngineRetarder = "";
  String selectedPreStartChecks = "";
  String selectedGearboxOperation = "";
  String selectedClutchOperationCheck = "";
  String selectedSpeedLimiterOperation = "";
  String selectedHillStartSwitchOperation = "";
  String selectedAddBlueTankCapacity = "";
  String selectedAdditionalFeatures = "";
  String selectedAirBagControls = "";

  File? signatureFile;

  int userId = 0;
  final Session session = Session();

  Future<void> init() async {
    final userIdStr = await session.getSession("userId");
    userId = int.tryParse(userIdStr ?? "") ?? 0;
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await populateFromSession();
  }

  Future<void> populateFromSession() async {
    final userJson = await session.getSession('loggedInUser');
    if (userJson == null) return;
    final Map<String, dynamic> userData = jsonDecode(userJson);
    driverNameController.text = userData["name"] ?? "";
    assessorNameController.text = userData["name"] ?? "";
  }

  Future<void> submitForm(BuildContext context) async {
    if (driverNameController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty ||
        vehicleRegoController.text.trim().isEmpty ||
        selectedTruckType.isEmpty ||
        selectedOverviewVehicle.isEmpty ||
        selectedTransmissionSuspension.isEmpty ||
        selectedRaiseBonnetChecks.isEmpty ||
        selectedMethodTiltingCabin.isEmpty ||
        selectedWalkAroundTruck.isEmpty ||
        selectedFuelTankCapacity.isEmpty ||
        selectedIsolationSwitch.isEmpty ||
        selectedTailgateOperation.isEmpty ||
        selectedDangerTraySwing.isEmpty ||
        selectedDangerFrontCornerOverhang.isEmpty ||
        selectedAirTankDrainCocks.isEmpty ||
        selectedCircuitBreakersLocation.isEmpty ||
        selectedTrailerElectricalVolts.isEmpty ||
        selectedTrailerConnectionsAirlines.isEmpty ||
        selectedMethodEntryExitCabin.isEmpty ||
        selectedSeatAdjustment.isEmpty ||
        selectedSteeringWheelAdjustment.isEmpty ||
        selectedPowerDividerDiffLocks.isEmpty ||
        selectedHandBrakeOperation.isEmpty ||
        selectedEngineIdleTime.isEmpty ||
        selectedMirrorUse.isEmpty ||
        selectedClutchUse.isEmpty ||
        selectedGearSelection.isEmpty ||
        selectedRevRange.isEmpty ||
        selectedEngineBrakeRetarderUse.isEmpty ||
        selectedCheckIntersections.isEmpty ||
        selectedCourtesyToOthers.isEmpty ||
        selectedObservationPlanning.isEmpty ||
        selectedOvertaking.isEmpty ||
        selectedSpeedForEnvironment.isEmpty ||
        selectedHangBackDistance.isEmpty ||
        selectedCruiseControl.isEmpty ||
        selectedOperationDriverButtonsSwitches.isEmpty ||
        selectedOperationEngineRetarder.isEmpty ||
        selectedPreStartChecks.isEmpty ||
        selectedGearboxOperation.isEmpty ||
        selectedClutchOperationCheck.isEmpty ||
        selectedSpeedLimiterOperation.isEmpty ||
        selectedHillStartSwitchOperation.isEmpty ||
        selectedAddBlueTankCapacity.isEmpty ||
        selectedAdditionalFeatures.isEmpty ||
        selectedAirBagControls.isEmpty ||
        signatureFile == null) {
      _showDialog(context, "Missing Fields",
          "Please complete all fields and provide your signature.");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final model = InCabAssessmentModel(
      driverName: driverNameController.text.trim(),
      date: dateController.text.trim(),
      vehicleRego: vehicleRegoController.text.trim(),
      truckType: selectedTruckType.trim(),
      overviewVehicle: selectedOverviewVehicle.trim(),
      transmissionSuspension: selectedTransmissionSuspension.trim(),
      raiseBonnetChecks: selectedRaiseBonnetChecks.trim(),
      methodTiltingCabin: selectedMethodTiltingCabin.trim(),
      walkAroundTruck: selectedWalkAroundTruck.trim(),
      fuelTankCapacity: selectedFuelTankCapacity.trim(),
      isolationSwitch: selectedIsolationSwitch.trim(),
      tailgateOperation: selectedTailgateOperation.trim(),
      dangerTraySwing: selectedDangerTraySwing.trim(),
      dangerFrontCornerOverhang: selectedDangerFrontCornerOverhang.trim(),
      airTankDrainCocks: selectedAirTankDrainCocks.trim(),
      circuitBreakersLocation: selectedCircuitBreakersLocation.trim(),
      trailerElectricalVolts: selectedTrailerElectricalVolts.trim(),
      trailerConnectionsAirlines: selectedTrailerConnectionsAirlines.trim(),
      methodEntryExitCabin: selectedMethodEntryExitCabin.trim(),
      seatAdjustment: selectedSeatAdjustment.trim(),
      steeringWheelAdjustment: selectedSteeringWheelAdjustment.trim(),
      powerDividerDiffLocks: selectedPowerDividerDiffLocks.trim(),
      handBrakeOperation: selectedHandBrakeOperation.trim(),
      engineIdleTime: selectedEngineIdleTime.trim(),
      mirrorUse: selectedMirrorUse.trim(),
      clutchUse: selectedClutchUse.trim(),
      gearSelection: selectedGearSelection.trim(),
      revRange: selectedRevRange.trim(),
      engineBrakeRetarderUse: selectedEngineBrakeRetarderUse.trim(),
      checkIntersections: selectedCheckIntersections.trim(),
      courtesyToOthers: selectedCourtesyToOthers.trim(),
      observationPlanning: selectedObservationPlanning.trim(),
      overtaking: selectedOvertaking.trim(),
      speedForEnvironment: selectedSpeedForEnvironment.trim(),
      hangBackDistance: selectedHangBackDistance.trim(),
      cruiseControl: selectedCruiseControl.trim(),
      operationDriverButtonsSwitches:
          selectedOperationDriverButtonsSwitches.trim(),
      operationEngineRetarder: selectedOperationEngineRetarder.trim(),
      preStartChecks: selectedPreStartChecks.trim(),
      gearboxOperation: selectedGearboxOperation.trim(),
      clutchOperationCheck: selectedClutchOperationCheck.trim(),
      speedLimiterOperation: selectedSpeedLimiterOperation.trim(),
      hillStartSwitchOperation: selectedHillStartSwitchOperation.trim(),
      addBlueTankCapacity: selectedAddBlueTankCapacity.trim(),
      additionalFeatures: selectedAdditionalFeatures.trim(),
      airBagControls: selectedAirBagControls.trim(),
      assessorName: assessorNameController.text.trim(),
      signature: signatureFile!,
      isActive: true,
      createdOn: DateTime.now().toIso8601String(),
      createdBy: userId,
    );

    final success = await InCabAssessmentModel.submitForm(model);

    Navigator.pop(context); // close loading dialog

    if (success) {
      _showDialog(context, "Success", "Form submitted successfully.",
          onOk: () => Navigator.pop(context));
    } else {
      _showDialog(context, "Error", "Form submission failed.");
    }
  }

  void _showDialog(BuildContext context, String title, String message,
      {VoidCallback? onOk}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onOk?.call();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void dispose() {
    driverNameController.dispose();
    dateController.dispose();
    vehicleRegoController.dispose();
    assessorNameController.dispose();
  }
}
