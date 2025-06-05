import 'dart:io';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class MassLoadRestraintQuestionnaireModel {
  final String question1;
  final String question2;
  final String question3;
  final String question4;

  final String name;
  final DateTime date;
  final File? signature;
  final bool isActive;
  final DateTime createdOn;
  final int? createdBy;

  MassLoadRestraintQuestionnaireModel({
    required this.question1,
    required this.question2,
    required this.question3,
    required this.question4,
    required this.name,
    required this.date,
    this.signature,
    this.isActive = true,
    required this.createdOn,
    this.createdBy,
  });

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      "question_1": question1,
      "question_2": question2,
      "question3": question3,
      "question_4": question4,
      "name": name,
      "date": date.toIso8601String().split('T').first,
      "is_active": isActive.toString(),
      "created_on": createdOn.toIso8601String().split('T').first,
    };

    if (signature != null) fields["signature"] = signature;
    if (createdBy != null) fields["created_by"] = createdBy.toString();

    return fields;
  }

  factory MassLoadRestraintQuestionnaireModel.fromJson(
      Map<String, dynamic> json) {
    return MassLoadRestraintQuestionnaireModel(
      question1: json['question_1'] ?? '',
      question2: json['question_2'] ?? '',
      question3: json['question3'] ?? '',
      question4: json['question_4'] ?? '',
      name: json['name'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      signature: null,
      isActive: json['is_active'] ?? false,
      createdOn: DateTime.tryParse(json['created_on'] ?? '') ?? DateTime.now(),
      createdBy: json['created_by'],
    );
  }

  static Future<bool> submitMassLoadRestraintQuestionnaireForm(
      MassLoadRestraintQuestionnaireModel model) async {
    final url = "$api_url/employee/mass-load-restraint/";
    print('Submitting to $url');
    final api = Api();

    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: model.signature != null,
    );

    if (result["ok"] == 1) {
      print("Mass Load Restraint Questionnaire submitted successfully.");
      return true;
    } else {
      print(
          "Failed to submit Mass Load Restraint Questionnaire: ${result["error"]}");
      return false;
    }
  }

  @override
  String toString() {
    return 'MassLoadRestraintQuestionnaireModel {name: $name, date: $date, isActive: $isActive, createdOn: $createdOn, createdBy: $createdBy}';
  }
}
