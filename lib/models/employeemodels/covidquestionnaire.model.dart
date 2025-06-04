import 'dart:io';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class CovidQuestionnaireModel {
  final String name;
  final String date;

  final String vehiclesDisinfected;
  final String continueShiftThenIsolate;
  final String disinfectBeforeOnly;
  final String eatLunchOutside;
  final String noUnsafeDelivery;

  final File? signature;

  final bool isActive;
  final String createdOn;
  final int? createdBy;

  CovidQuestionnaireModel({
    required this.name,
    required this.date,
    required this.vehiclesDisinfected,
    required this.continueShiftThenIsolate,
    required this.disinfectBeforeOnly,
    required this.eatLunchOutside,
    required this.noUnsafeDelivery,
    this.signature,
    required this.isActive,
    required this.createdOn,
    this.createdBy,
  });

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      "name": name,
      "date": _formatDate(date),
      "vehicles_disinfected": vehiclesDisinfected,
      "continue_shift_then_isolate": continueShiftThenIsolate,
      "disinfect_before_only": disinfectBeforeOnly,
      "eat_lunch_outside": eatLunchOutside,
      "no_unsafe_delivery": noUnsafeDelivery,
      "is_active": isActive.toString(),
      "created_on": _formatDate(createdOn),
    };

    if (createdBy != null) {
      fields["created_by"] = createdBy.toString();
    }

    if (signature != null) {
      fields["signature"] = signature!;
    }

    return fields;
  }

  static String _formatDate(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      return dt.toIso8601String().split('T').first;
    } catch (e) {
      return isoString;
    }
  }

  factory CovidQuestionnaireModel.fromJson(Map<String, dynamic> json) {
    return CovidQuestionnaireModel(
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      vehiclesDisinfected: json['vehicles_disinfected'] ?? '',
      continueShiftThenIsolate: json['continue_shift_then_isolate'] ?? '',
      disinfectBeforeOnly: json['disinfect_before_only'] ?? '',
      eatLunchOutside: json['eat_lunch_outside'] ?? '',
      noUnsafeDelivery: json['no_unsafe_delivery'] ?? '',
      signature: null,
      isActive: json['is_active'] ?? true,
      createdOn: json['created_on'] ?? '',
      createdBy: _parseInt(json['created_by']),
    );
  }

  static int? _parseInt(dynamic val) {
    if (val == null) return null;
    if (val is int) return val;
    if (val is String) return int.tryParse(val);
    return null;
  }

  static Future<bool> submitForm(CovidQuestionnaireModel model) async {
    final api = Api();
    final url = '$api_url/employee/covid-questionnaire/';
    print('Submitting to $url');
    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: model.signature != null,
    );

    print('API Response: $result');
    return result["ok"] == 1;
  }

  @override
  String toString() {
    return 'CovidQuestionnaireModel(name: $name, date: $date)';
  }
}
