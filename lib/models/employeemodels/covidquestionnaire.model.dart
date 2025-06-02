import 'dart:io';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class CovidQuestionnaireModel {
  final bool vehiclesDisinfected;
  final bool continueShiftThenIsolate;
  final bool disinfectBeforeOnly;
  final bool eatLunchOutside;
  final bool noUnsafeDelivery;

  final String name;
  final DateTime date;
  final File? signature;

  final bool isActive;
  final DateTime createdOn;
  final int? createdBy;

  CovidQuestionnaireModel({
    required this.vehiclesDisinfected,
    required this.continueShiftThenIsolate,
    required this.disinfectBeforeOnly,
    required this.eatLunchOutside,
    required this.noUnsafeDelivery,
    required this.name,
    required this.date,
    this.signature,
    this.isActive = true,
    required this.createdOn,
    this.createdBy,
  });

  Map<String, dynamic> toMultipartFields() {
    final fields = {
      "vehicles_disinfected": vehiclesDisinfected.toString(),
      "continue_shift_then_isolate": continueShiftThenIsolate.toString(),
      "disinfect_before_only": disinfectBeforeOnly.toString(),
      "eat_lunch_outside": eatLunchOutside.toString(),
      "no_unsafe_delivery": noUnsafeDelivery.toString(),
      "name": name,
      "date": date.toIso8601String().split('T').first,
      "is_active": isActive.toString(),
      "created_on": createdOn.toIso8601String().split('T').first,
    };

    if (createdBy != null) fields["created_by"] = createdBy.toString();
    return fields;
  }

  static Future<bool> submitForm(CovidQuestionnaireModel model) async {
    final url = "$api_url/employee/covid-questionnaire/";
    print("Submitting COVID Questionnaire to $url");
    final api = Api();
    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: model.signature != null,
    );

    if (result["ok"] == 1) {
      print("COVID form submitted successfully.");
      return true;
    } else {
      print("Submission failed: ${result["error"]}");
      return false;
    }
  }

  factory CovidQuestionnaireModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String? dateStr) =>
        DateTime.tryParse(dateStr ?? '') ?? DateTime.now();

    return CovidQuestionnaireModel(
      vehiclesDisinfected: json['vehicles_disinfected'] ?? false,
      continueShiftThenIsolate: json['continue_shift_then_isolate'] ?? false,
      disinfectBeforeOnly: json['disinfect_before_only'] ?? false,
      eatLunchOutside: json['eat_lunch_outside'] ?? false,
      noUnsafeDelivery: json['no_unsafe_delivery'] ?? false,
      name: json['name'] ?? '',
      date: parseDate(json['date']),
      signature: null,
      isActive: json['is_active'] ?? true,
      createdOn: parseDate(json['created_on']),
      createdBy: json['created_by'],
    );
  }
}
