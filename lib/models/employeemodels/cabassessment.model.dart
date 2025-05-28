import 'dart:io';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class InCabAssessmentModel {
  final String driverName;
  final String date; // ISO string format "YYYY-MM-DD"
  final String vehicleRego;
  final String truckType; // from TRUCK_TYPE_CHOICES

  final String overviewVehicle;
  final String transmissionSuspension;
  final String raiseBonnetChecks;
  final String methodTiltingCabin;
  final String walkAroundTruck;
  final String fuelTankCapacity;
  final String isolationSwitch;
  final String tailgateOperation;
  final String dangerTraySwing;
  final String dangerFrontCornerOverhang;
  final String airTankDrainCocks;
  final String circuitBreakersLocation;
  final String trailerElectricalVolts;
  final String trailerConnectionsAirlines;
  final String methodEntryExitCabin;
  final String seatAdjustment;
  final String steeringWheelAdjustment;
  final String powerDividerDiffLocks;
  final String handBrakeOperation;
  final String cruiseControl;
  final String operationDriverButtonsSwitches;
  final String operationEngineRetarder;
  final String preStartChecks;
  final String gearboxOperation;
  final String clutchOperationCheck;
  final String speedLimiterOperation;
  final String hillStartSwitchOperation;
  final String addBlueTankCapacity;
  final String additionalFeatures;
  final String airBagControls;

  // ASSESSMENT_CHOICES fields (max 3 length strings)
  final String engineIdleTime;
  final String mirrorUse;
  final String clutchUse;
  final String gearSelection;
  final String revRange;
  final String engineBrakeRetarderUse;
  final String checkIntersections;
  final String courtesyToOthers;
  final String observationPlanning;
  final String overtaking;
  final String speedForEnvironment;
  final String hangBackDistance;

  final String assessorName;
  final File? signature;

  // Server-managed fields
  final bool? isActive;
  final String? createdOn; // ISO date string
  final int? createdBy;

  InCabAssessmentModel({
    required this.driverName,
    required this.date,
    required this.vehicleRego,
    required this.truckType,
    required this.overviewVehicle,
    required this.transmissionSuspension,
    required this.raiseBonnetChecks,
    required this.methodTiltingCabin,
    required this.walkAroundTruck,
    required this.fuelTankCapacity,
    required this.isolationSwitch,
    required this.tailgateOperation,
    required this.dangerTraySwing,
    required this.dangerFrontCornerOverhang,
    required this.airTankDrainCocks,
    required this.circuitBreakersLocation,
    required this.trailerElectricalVolts,
    required this.trailerConnectionsAirlines,
    required this.methodEntryExitCabin,
    required this.seatAdjustment,
    required this.steeringWheelAdjustment,
    required this.powerDividerDiffLocks,
    required this.handBrakeOperation,
    required this.cruiseControl,
    required this.operationDriverButtonsSwitches,
    required this.operationEngineRetarder,
    required this.preStartChecks,
    required this.gearboxOperation,
    required this.clutchOperationCheck,
    required this.speedLimiterOperation,
    required this.hillStartSwitchOperation,
    required this.addBlueTankCapacity,
    required this.additionalFeatures,
    required this.airBagControls,
    required this.engineIdleTime,
    required this.mirrorUse,
    required this.clutchUse,
    required this.gearSelection,
    required this.revRange,
    required this.engineBrakeRetarderUse,
    required this.checkIntersections,
    required this.courtesyToOthers,
    required this.observationPlanning,
    required this.overtaking,
    required this.speedForEnvironment,
    required this.hangBackDistance,
    required this.assessorName,
    this.signature,
    this.isActive,
    this.createdOn,
    this.createdBy,
  });

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      "driver_name": driverName,
      "date": date,
      "vehicle_rego": vehicleRego,
      "truck_type": truckType,
      "overview_vehicle": overviewVehicle,
      "transmission_suspension": transmissionSuspension,
      "raise_bonnet_checks": raiseBonnetChecks,
      "method_tilting_cabin": methodTiltingCabin,
      "walk_around_truck": walkAroundTruck,
      "fuel_tank_capacity": fuelTankCapacity,
      "isolation_switch": isolationSwitch,
      "tailgate_operation": tailgateOperation,
      "danger_tray_swing": dangerTraySwing,
      "danger_front_corner_overhang": dangerFrontCornerOverhang,
      "air_tank_drain_cocks": airTankDrainCocks,
      "circuit_breakers_location": circuitBreakersLocation,
      "trailer_electrical_volts": trailerElectricalVolts,
      "trailer_connections_airlines": trailerConnectionsAirlines,
      "method_entry_exit_cabin": methodEntryExitCabin,
      "seat_adjustment": seatAdjustment,
      "steering_wheel_adjustment": steeringWheelAdjustment,
      "power_divider_diff_locks": powerDividerDiffLocks,
      "hand_brake_operation": handBrakeOperation,
      "cruise_control": cruiseControl,
      "operation_driver_buttons_switches": operationDriverButtonsSwitches,
      "operation_engine_retarder": operationEngineRetarder,
      "pre_start_checks": preStartChecks,
      "gearbox_operation": gearboxOperation,
      "clutch_operation_check": clutchOperationCheck,
      "speed_limiter_operation": speedLimiterOperation,
      "hill_start_switch_operation": hillStartSwitchOperation,
      "add_blue_tank_capacity": addBlueTankCapacity,
      "additional_features": additionalFeatures,
      "air_bag_controls": airBagControls,
      "engine_idle_time": engineIdleTime,
      "mirror_use": mirrorUse,
      "clutch_use": clutchUse,
      "gear_selection": gearSelection,
      "rev_range": revRange,
      "engine_brake_retarder_use": engineBrakeRetarderUse,
      "check_intersections": checkIntersections,
      "courtesy_to_others": courtesyToOthers,
      "observation_planning": observationPlanning,
      "overtaking": overtaking,
      "speed_for_environment": speedForEnvironment,
      "hang_back_distance": hangBackDistance,
      "assessor_name": assessorName,
    };

    if (isActive != null) fields["is_active"] = isActive.toString();
    if (createdOn != null) fields["created_on"] = createdOn!;
    if (createdBy != null) fields["created_by"] = createdBy.toString();
    if (signature != null) fields["signature"] = signature;

    return fields;
  }

  factory InCabAssessmentModel.fromJson(Map<String, dynamic> json) {
    return InCabAssessmentModel(
      driverName: json['driver_name'] ?? '',
      date: json['date'] ?? '',
      vehicleRego: json['vehicle_rego'] ?? '',
      truckType: json['truck_type'] ?? 'HR',

      overviewVehicle: json['overview_vehicle'] ?? 'N/A',
      transmissionSuspension: json['transmission_suspension'] ?? 'N/A',
      raiseBonnetChecks: json['raise_bonnet_checks'] ?? 'N/A',
      methodTiltingCabin: json['method_tilting_cabin'] ?? 'N/A',
      walkAroundTruck: json['walk_around_truck'] ?? 'N/A',
      fuelTankCapacity: json['fuel_tank_capacity'] ?? 'N/A',
      isolationSwitch: json['isolation_switch'] ?? 'N/A',
      tailgateOperation: json['tailgate_operation'] ?? 'N/A',
      dangerTraySwing: json['danger_tray_swing'] ?? 'N/A',
      dangerFrontCornerOverhang: json['danger_front_corner_overhang'] ?? 'N/A',
      airTankDrainCocks: json['air_tank_drain_cocks'] ?? 'N/A',
      circuitBreakersLocation: json['circuit_breakers_location'] ?? 'N/A',
      trailerElectricalVolts: json['trailer_electrical_volts'] ?? 'N/A',
      trailerConnectionsAirlines: json['trailer_connections_airlines'] ?? 'N/A',
      methodEntryExitCabin: json['method_entry_exit_cabin'] ?? 'N/A',
      seatAdjustment: json['seat_adjustment'] ?? 'N/A',
      steeringWheelAdjustment: json['steering_wheel_adjustment'] ?? 'N/A',
      powerDividerDiffLocks: json['power_divider_diff_locks'] ?? 'N/A',
      handBrakeOperation: json['hand_brake_operation'] ?? 'N/A',
      cruiseControl: json['cruise_control'] ?? 'N/A',
      operationDriverButtonsSwitches:
          json['operation_driver_buttons_switches'] ?? 'N/A',
      operationEngineRetarder: json['operation_engine_retarder'] ?? 'N/A',
      preStartChecks: json['pre_start_checks'] ?? 'N/A',
      gearboxOperation: json['gearbox_operation'] ?? 'N/A',
      clutchOperationCheck: json['clutch_operation_check'] ?? 'N/A',
      speedLimiterOperation: json['speed_limiter_operation'] ?? 'N/A',
      hillStartSwitchOperation: json['hill_start_switch_operation'] ?? 'N/A',
      addBlueTankCapacity: json['add_blue_tank_capacity'] ?? 'N/A',
      additionalFeatures: json['additional_features'] ?? 'N/A',
      airBagControls: json['air_bag_controls'] ?? 'N/A',

      engineIdleTime: json['engine_idle_time'] ?? 'N/A',
      mirrorUse: json['mirror_use'] ?? 'N/A',
      clutchUse: json['clutch_use'] ?? 'N/A',
      gearSelection: json['gear_selection'] ?? 'N/A',
      revRange: json['rev_range'] ?? 'N/A',
      engineBrakeRetarderUse: json['engine_brake_retarder_use'] ?? 'N/A',
      checkIntersections: json['check_intersections'] ?? 'N/A',
      courtesyToOthers: json['courtesy_to_others'] ?? 'N/A',
      observationPlanning: json['observation_planning'] ?? 'N/A',
      overtaking: json['overtaking'] ?? 'N/A',
      speedForEnvironment: json['speed_for_environment'] ?? 'N/A',
      hangBackDistance: json['hang_back_distance'] ?? 'N/A',

      assessorName: json['assessor_name'] ?? '',
      signature: null, // Handle file separately on client side

      isActive: json['is_active'] ?? true,
      createdOn: json['created_on'],
      createdBy: json['created_by'],
    );
  }

  static Future<bool> submitForm(InCabAssessmentModel model) async {
    final api = Api();
    final url = '$api_url/employee/incab-assessment/';
    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: model.signature != null,
    );

    return result["ok"] == 1;
  }

  @override
  String toString() {
    return 'InCabAssessmentModel('
        'driverName: $driverName, date: $date, vehicleRego: $vehicleRego, truckType: $truckType, '
        'assessorName: $assessorName, signature: ${signature?.path}, isActive: $isActive, createdOn: $createdOn, createdBy: $createdBy)';
  }
}
