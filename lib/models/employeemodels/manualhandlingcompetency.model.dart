import 'dart:io';
import 'dart:convert';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class ManualHandlingCompetencyModel {
  final String nonCompliance;
  final String drivingPostureCorrect;
  final String incorrectTrolleyPractice;
  final String attemptDifficultTask;

  final String name;
  final DateTime date;
  final File? signature;
  final bool isActive;
  final DateTime createdOn;
  final int? createdBy;

  ManualHandlingCompetencyModel({
    required this.nonCompliance,
    required this.drivingPostureCorrect,
    required this.incorrectTrolleyPractice,
    required this.attemptDifficultTask,
    required this.name,
    required this.date,
    this.signature,
    this.isActive = true,
    required this.createdOn,
    this.createdBy,
  });

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      "non_compliance": nonCompliance,
      "driving_posture_correct": drivingPostureCorrect,
      "incorrect_trolley_practice": incorrectTrolleyPractice,
      "attempt_difficult_task": attemptDifficultTask,
      "name": name,
      "date": date.toIso8601String().split('T').first,
      "is_active": isActive.toString(),
      "created_on": createdOn.toIso8601String().split('T').first,
    };

    if (signature != null) fields["signature"] = signature;
    if (createdBy != null) fields["created_by"] = createdBy.toString();

    return fields;
  }

  factory ManualHandlingCompetencyModel.fromJson(Map<String, dynamic> json) {
    return ManualHandlingCompetencyModel(
      nonCompliance: json['non_compliance'] ?? '',
      drivingPostureCorrect: json['driving_posture_correct'] ?? 'no',
      incorrectTrolleyPractice: json['incorrect_trolley_practice'] ?? '',
      attemptDifficultTask: json['attempt_difficult_task'] ?? 'no',
      name: json['name'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      signature: null, // Signature is upload-only
      isActive: json['is_active'] ?? false,
      createdOn: DateTime.tryParse(json['created_on'] ?? '') ?? DateTime.now(),
      createdBy: json['created_by'],
    );
  }

  static Future<bool> submitManualHandlingCompetencForm(
      ManualHandlingCompetencyModel model) async {
    final url = "$api_url/employee/manual-handling/";
    print('Submitting to $url');
    final api = Api();

    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: model.signature != null,
    );

    if (result["ok"] == 1) {
      print("Manual Handling Competency form submitted successfully.");
      return true;
    } else {
      print(
          "Failed to submit Manual Handling Competency form: ${result["error"]}");
      return false;
    }
  }

  @override
  String toString() {
    return 'ManualHandlingCompetencyModel {name: $name, date: $date, isActive: $isActive, createdOn: $createdOn, createdBy: $createdBy}';
  }
}
