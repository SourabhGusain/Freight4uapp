import 'dart:io';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class CoRFormModel {
  final String name;
  final File? signature; // Initial signature
  final String driverResponsibilities;
  final String corIssueSteps;
  final String primaryDutyHolder;
  final String corPenalties;
  final String driverFatigue;
  final String frmsComponents;
  final String actionIfSomethingWrong;
  final String equipmentForOverloading;
  final String overloadRisks;
  final String loadNotOverloadingSteps;

  final String traineeName;
  final DateTime traineeDate;
  final File? traineeSignature;
  final bool isActive;
  final DateTime createdOn;
  final int? createdBy;

  CoRFormModel({
    required this.name,
    this.signature,
    required this.driverResponsibilities,
    required this.corIssueSteps,
    required this.primaryDutyHolder,
    required this.corPenalties,
    required this.driverFatigue,
    required this.frmsComponents,
    required this.actionIfSomethingWrong,
    required this.equipmentForOverloading,
    required this.overloadRisks,
    required this.loadNotOverloadingSteps,
    required this.traineeName,
    required this.traineeDate,
    this.traineeSignature,
    this.isActive = true,
    required this.createdOn,
    this.createdBy,
  });

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      "name": name,
      "driver_responsibilities": driverResponsibilities,
      "cor_issue_steps": corIssueSteps,
      "primary_duty_holder": primaryDutyHolder,
      "cor_penalties": corPenalties,
      "driver_fatigue": driverFatigue,
      "frms_components": frmsComponents,
      "action_if_something_wrong": actionIfSomethingWrong,
      "equipment_for_overloading": equipmentForOverloading,
      "overload_risks": overloadRisks,
      "load_not_overloading_steps": loadNotOverloadingSteps,
      "trainee_name": traineeName,
      "trainee_date": traineeDate.toIso8601String().split('T').first,
      "is_active": isActive.toString(),
      "created_on": createdOn.toIso8601String().split('T').first,
    };

    if (signature != null) fields["signature"] = signature;
    if (traineeSignature != null)
      fields["trainee_signature"] = traineeSignature;
    if (createdBy != null) fields["created_by"] = createdBy.toString();

    return fields;
  }

  factory CoRFormModel.fromJson(Map<String, dynamic> json) {
    return CoRFormModel(
      name: json['name'] ?? '',
      driverResponsibilities: json['driver_responsibilities'] ?? '',
      corIssueSteps: json['cor_issue_steps'] ?? '',
      primaryDutyHolder: json['primary_duty_holder'] ?? '',
      corPenalties: json['cor_penalties'] ?? '',
      driverFatigue: json['driver_fatigue'] ?? '',
      frmsComponents: json['frms_components'] ?? '',
      actionIfSomethingWrong: json['action_if_something_wrong'] ?? '',
      equipmentForOverloading: json['equipment_for_overloading'] ?? '',
      overloadRisks: json['overload_risks'] ?? '',
      loadNotOverloadingSteps: json['load_not_overloading_steps'] ?? '',
      traineeName: json['trainee_name'] ?? '',
      traineeDate:
          DateTime.tryParse(json['trainee_date'] ?? '') ?? DateTime.now(),
      createdOn: DateTime.tryParse(json['created_on'] ?? '') ?? DateTime.now(),
      isActive: json['is_active'] ?? false,
      signature: null,
      traineeSignature: null,
      createdBy: json['created_by'],
    );
  }

  static Future<bool> submitForm(CoRFormModel model) async {
    final url = "$api_url/employee/cor-form/";
    print('Submitting CoRForm to $url');
    final api = Api();
    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: model.signature != null || model.traineeSignature != null,
    );

    if (result["ok"] == 1) {
      print("CoR Form submitted successfully.");
      return true;
    } else {
      print("Failed to submit CoR Form: ${result["error"]}");
      return false;
    }
  }
}
