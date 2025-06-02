import 'dart:io';
import 'package:dio/dio.dart';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class ScissorLiftTrainingModel {
  final String traineeOrganization;
  final String name;
  final DateTime date;
  final File? signature;

  final bool isActive;
  final DateTime createdOn;
  final int? createdBy;

  ScissorLiftTrainingModel({
    this.traineeOrganization = "Freight4You",
    required this.name,
    required this.date,
    this.signature,
    this.isActive = true,
    required this.createdOn,
    this.createdBy,
  });

  Map<String, String> toMultipartFields() {
    final fields = {
      "trainee_organization": traineeOrganization,
      "name": name,
      "date": date.toIso8601String().split('T').first,
      "is_active": isActive.toString(),
      "created_on": createdOn.toIso8601String().split('T').first,
    };

    if (createdBy != null) fields["created_by"] = createdBy.toString();
    return fields;
  }

  static Future<bool> submitInductionForm(
      ScissorLiftTrainingModel model) async {
    final url = "$api_url/employee/scissor-lift-training/";
    print("Submitting Scissor Lift Training to $url");

    final api = Api();

    // Build multipart FormData
    final Map<String, String> fields = model.toMultipartFields();
    final formData = FormData.fromMap(fields);

    if (model.signature != null && await model.signature!.exists()) {
      String fileName = model.signature!.path.split('/').last;
      formData.files.add(MapEntry(
        "signature",
        await MultipartFile.fromFile(model.signature!.path, filename: fileName),
      ));
    }

    final result = await api.multipartOrJsonPostCall(
      url,
      formData,
      isMultipart: true,
    );

    print(result);

    if (result["ok"] == 1) {
      print("Scissor Lift Training submitted successfully.");
      return true;
    } else {
      print("Submission failed: ${result["error"]}");
      return false;
    }
  }

  factory ScissorLiftTrainingModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String? dateStr) =>
        DateTime.tryParse(dateStr ?? '') ?? DateTime.now();

    return ScissorLiftTrainingModel(
      traineeOrganization: json['trainee_organization'] ?? 'Freight4You',
      name: json['name'] ?? '',
      date: parseDate(json['date']),
      signature: null,
      isActive: json['is_active'] ?? true,
      createdOn: parseDate(json['created_on']),
      createdBy: json['created_by'],
    );
  }
}
