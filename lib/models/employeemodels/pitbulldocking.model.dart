import 'dart:io';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class PitbullDockingModel {
  final String date;
  final String name;
  final File? signature;
  final String q1_drivers_red_light;
  final String q2_gatehouse_procedure;
  final String q3_no_light_means_red;
  final String q4_seal_registration_check;
  final String q5_trailer_docking_step;
  final String q6_chocking_required;
  final String q7_task_commencement_light;
  final bool isActive;
  final String createdOn;
  final int createdBy;

  PitbullDockingModel({
    required this.date,
    required this.name,
    this.signature,
    required this.q1_drivers_red_light,
    required this.q2_gatehouse_procedure,
    required this.q3_no_light_means_red,
    required this.q4_seal_registration_check,
    required this.q5_trailer_docking_step,
    required this.q6_chocking_required,
    required this.q7_task_commencement_light,
    required this.isActive,
    required this.createdOn,
    required this.createdBy,
  });

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      "date": date,
      "name": name,
      "q1_drivers_red_light": q1_drivers_red_light,
      "q2_gatehouse_procedure": q2_gatehouse_procedure,
      "q3_no_light_means_red": q3_no_light_means_red,
      "q4_seal_registration_check": q4_seal_registration_check,
      "q5_trailer_docking_step": q5_trailer_docking_step,
      "q6_chocking_required": q6_chocking_required,
      "q7_task_commencement_light": q7_task_commencement_light,
      "is_active": isActive.toString(),
      "created_on": createdOn.split('T').first,
      "created_by": createdBy.toString(),
    };

    if (signature != null) fields["signature"] = signature;
    if (createdBy != null) fields["created_by"] = createdBy.toString();

    return fields;
  }

  factory PitbullDockingModel.fromJson(Map<String, dynamic> json) {
    return PitbullDockingModel(
      date: json['date'] ?? '',
      name: json['name'] ?? '',
      signature: null,
      q1_drivers_red_light: json['q1_drivers_red_light'] ?? '',
      q2_gatehouse_procedure: json['q2_gatehouse_procedure'] ?? '',
      q3_no_light_means_red: json['q3_no_light_means_red'] ?? '',
      q4_seal_registration_check: json['q4_seal_registration_check'] ?? '',
      q5_trailer_docking_step: json['q5_trailer_docking_step'] ?? '',
      q6_chocking_required: json['q6_chocking_required'] ?? '',
      q7_task_commencement_light: json['q7_task_commencement_light'] ?? '',
      isActive: json['is_active'] ?? false,
      createdOn: json['created_on'] ?? '',
      createdBy: json['created_by'] ?? 0,
    );
  }

  static Future<bool> submitForm(PitbullDockingModel model) async {
    final api = Api();
    final url = '$api_url/employee/pitbull-docking-swp/';
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
    return 'PitbullDockingModel(date: $date, name: $name, signature: ${signature?.path}, ...createdBy: $createdBy)';
  }
}
