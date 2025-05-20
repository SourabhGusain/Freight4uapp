import 'dart:io';
import 'dart:convert';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class InductionFormModel {
  final String driverName;
  final File? signature;
  final String date;
  final bool isActive;
  final String createdOn;
  final int? createdBy;

  InductionFormModel({
    required this.driverName,
    this.signature,
    required this.date,
    this.isActive = true,
    required this.createdOn,
    this.createdBy,
  });

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      "driver_name": driverName,
      "date": date,
      "is_active": isActive.toString(),
      "created_on":
          createdOn.contains('T') ? createdOn.split('T').first : createdOn,
    };

    if (signature != null) fields["signature"] = signature;
    if (createdBy != null) fields["created_by"] = createdBy.toString();

    return fields;
  }

  factory InductionFormModel.fromJson(Map<String, dynamic> json) {
    return InductionFormModel(
      driverName: json['driver_name'] ?? '',
      date: json['date'] ?? '',
      isActive: json['is_active'] ?? false,
      createdOn: json['created_on'] ?? '',
      createdBy: json['created_by'],
      signature: null,
    );
  }

  static Future<bool> submitForm(InductionFormModel model) async {
    final url = "$api_url/employee/induction-form/";
    print(url);
    final api = Api();

    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: model.signature != null,
    );

    if (result["ok"] == 1) {
      print("Induction form submitted successfully.");
      return true;
    } else {
      print("Failed to submit induction form: ${result["error"]}");
      return false;
    }
  }

  @override
  String toString() {
    return 'InductionFormModel {driverName: $driverName, date: $date, isActive: $isActive, createdOn: $createdOn, createdBy: $createdBy}';
  }
}
