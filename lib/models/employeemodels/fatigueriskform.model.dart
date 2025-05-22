import 'dart:io';
import 'dart:convert';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class FatigueRiskManagementModel {
  final String q1DriveWithoutBreak;
  final String q2RestBetweenShifts;
  final String q3RestBreakDuration;
  final String q4DriveNoBreaksBetweenShifts;
  final String q5NotifyManagerOfFatigueChange;

  final String name;
  final DateTime acknowledgmentDate;
  final File? signature;
  final bool isActive;
  final DateTime createdOn;
  final int? createdBy;

  FatigueRiskManagementModel({
    required this.q1DriveWithoutBreak,
    required this.q2RestBetweenShifts,
    required this.q3RestBreakDuration,
    required this.q4DriveNoBreaksBetweenShifts,
    required this.q5NotifyManagerOfFatigueChange,
    required this.name,
    required this.acknowledgmentDate,
    this.signature,
    this.isActive = true,
    required this.createdOn,
    this.createdBy,
  });

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      "q1_drive_without_break": q1DriveWithoutBreak,
      "q2_rest_between_shifts": q2RestBetweenShifts,
      "q3_rest_break_duration": q3RestBreakDuration,
      "q4_drive_no_breaks_between_shifts": q4DriveNoBreaksBetweenShifts,
      "q5_notify_manager_of_fatigue_change": q5NotifyManagerOfFatigueChange,
      "name": name,
      "acknowledgment_date":
          acknowledgmentDate.toIso8601String().split('T').first,
      "is_active": isActive.toString(),
      "created_on": createdOn.toIso8601String().split('T').first,
    };

    if (signature != null) fields["signature"] = signature;
    if (createdBy != null) fields["created_by"] = createdBy.toString();

    return fields;
  }

  factory FatigueRiskManagementModel.fromJson(Map<String, dynamic> json) {
    return FatigueRiskManagementModel(
      q1DriveWithoutBreak: json['q1_drive_without_break'] ?? '',
      q2RestBetweenShifts: json['q2_rest_between_shifts'] ?? '',
      q3RestBreakDuration: json['q3_rest_break_duration'] ?? '',
      q4DriveNoBreaksBetweenShifts:
          json['q4_drive_no_breaks_between_shifts'] ?? '',
      q5NotifyManagerOfFatigueChange:
          json['q5_notify_manager_of_fatigue_change'] ?? '',
      name: json['name'] ?? '',
      acknowledgmentDate:
          DateTime.tryParse(json['acknowledgment_date'] ?? '') ??
              DateTime.now(),
      signature: null,
      isActive: json['is_active'] ?? false,
      createdOn: DateTime.tryParse(json['created_on'] ?? '') ?? DateTime.now(),
      createdBy: json['created_by'],
    );
  }

  static Future<bool> submitForm(FatigueRiskManagementModel model) async {
    final url = "$api_url/employee/fatigue-risk-management/";
    print('Submitting to $url');
    final api = Api();

    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: model.signature != null,
    );

    if (result["ok"] == 1) {
      print("Fatigue Risk Management form submitted successfully.");
      return true;
    } else {
      print(
          "Failed to submit Fatigue Risk Management form: ${result["error"]}");
      return false;
    }
  }

  @override
  String toString() {
    return 'FatigueRiskManagementModel {name: $name, acknowledgmentDate: $acknowledgmentDate, isActive: $isActive, createdOn: $createdOn, createdBy: $createdBy}';
  }
}
