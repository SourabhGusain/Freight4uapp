import 'dart:io';
import 'dart:convert';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class DriverAssessmentModel {
  final String name;
  final String lastName;
  final DateTime date;
  final String licenceNumber;
  final DateTime expiryDate;
  final String stateOfValidation;

  final String streetAddress;
  final String streetAddress2;
  final String city;
  final String stateOrProvince;
  final String postalCode;

  final String buddyAssessorName;
  final DateTime buddyAssessorDate;
  final String vehicleType;
  final String gearboxType;
  final String licenceRestrictions;
  final File? signature;

  final String preTripInspection;
  final String uncouplingCouplingTrailer;
  final String loadSecuring;
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
  final String roadLaw;
  final String cornering;
  final String roundabout;
  final String reversing;
  final String last100Metres;
  final String atDestination;
  final String paperWork;

  final bool isActive;
  final DateTime createdOn;
  final int? createdBy;

  DriverAssessmentModel({
    required this.name,
    required this.lastName,
    required this.date,
    required this.licenceNumber,
    required this.expiryDate,
    required this.stateOfValidation,
    required this.streetAddress,
    required this.streetAddress2,
    required this.city,
    required this.stateOrProvince,
    required this.postalCode,
    required this.buddyAssessorName,
    required this.buddyAssessorDate,
    required this.vehicleType,
    required this.gearboxType,
    required this.licenceRestrictions,
    this.signature,
    required this.preTripInspection,
    required this.uncouplingCouplingTrailer,
    required this.loadSecuring,
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
    required this.roadLaw,
    required this.cornering,
    required this.roundabout,
    required this.reversing,
    required this.last100Metres,
    required this.atDestination,
    required this.paperWork,
    this.isActive = true,
    required this.createdOn,
    this.createdBy,
  });

  Map<String, dynamic> toMultipartFields() {
    final fields = {
      "name": name,
      "last_name": lastName,
      "date": date.toIso8601String().split('T').first,
      "licence_number": licenceNumber,
      "expiry_date": expiryDate.toIso8601String().split('T').first,
      "state_of_validation": stateOfValidation,
      "street_address": streetAddress,
      "street_address_2": streetAddress2,
      "city": city,
      "state_or_province": stateOrProvince,
      "postal_code": postalCode,
      "buddy_assessor_name": buddyAssessorName,
      "buddy_assessor_date":
          buddyAssessorDate.toIso8601String().split('T').first,
      "vehicle_type": vehicleType,
      "gearbox_type": gearboxType,
      "licence_restrictions": licenceRestrictions,
      "pre_trip_inspection": preTripInspection,
      "uncoupling_coupling_trailer": uncouplingCouplingTrailer,
      "load_securing": loadSecuring,
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
      "road_law": roadLaw,
      "cornering": cornering,
      "roundabout": roundabout,
      "reversing": reversing,
      "last_100_metres": last100Metres,
      "at_destination": atDestination,
      "paper_work": paperWork,
      "is_active": isActive.toString(),
      "created_on": createdOn.toIso8601String().split('T').first,
    };

    // if (signature != null) fields["signature"] = signature;
    if (createdBy != null) fields["created_by"] = createdBy.toString();

    return fields;
  }

  static Future<bool> submitForm(DriverAssessmentModel model) async {
    final url = "$api_url/employee/driver-assessment/";
    print("Submitting DriverAssessment to $url");
    final api = Api();
    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: model.signature != null,
    );

    if (result["ok"] == 1) {
      print("Driver Assessment submitted successfully.");
      return true;
    } else {
      print("Driver Assessment submission failed: ${result["error"]}");
      return false;
    }
  }

  factory DriverAssessmentModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String? dateStr) {
      return DateTime.tryParse(dateStr ?? '') ?? DateTime.now();
    }

    return DriverAssessmentModel(
      name: json['name'] ?? '',
      lastName: json['last_name'] ?? '',
      date: parseDate(json['date']),
      licenceNumber: json['licence_number'] ?? '',
      expiryDate: parseDate(json['expiry_date']),
      stateOfValidation: json['state_of_validation'] ?? '',

      streetAddress: json['street_address'] ?? '',
      streetAddress2: json['street_address_2'] ?? '',
      city: json['city'] ?? '',
      stateOrProvince: json['state_or_province'] ?? '',
      postalCode: json['postal_code'] ?? '',

      buddyAssessorName: json['buddy_assessor_name'] ?? '',
      buddyAssessorDate: parseDate(json['buddy_assessor_date']),
      vehicleType: json['vehicle_type'] ?? '',
      gearboxType: json['gearbox_type'] ?? '',
      licenceRestrictions: json['licence_restrictions'] ?? '',
      signature: null, // Cannot be restored from JSON

      preTripInspection: json['pre_trip_inspection'] ?? 'N/A',
      uncouplingCouplingTrailer: json['uncoupling_coupling_trailer'] ?? 'N/A',
      loadSecuring: json['load_securing'] ?? 'N/A',
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
      roadLaw: json['road_law'] ?? 'N/A',
      cornering: json['cornering'] ?? 'N/A',
      roundabout: json['roundabout'] ?? 'N/A',
      reversing: json['reversing'] ?? 'N/A',
      last100Metres: json['last_100_metres'] ?? 'N/A',
      atDestination: json['at_destination'] ?? 'N/A',
      paperWork: json['paper_work'] ?? 'N/A',

      isActive: json['is_active'] ?? true,
      createdOn: parseDate(json['created_on']),
      createdBy: json['created_by'],
    );
  }
}
