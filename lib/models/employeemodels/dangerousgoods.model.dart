import 'dart:io';
import 'package:dio/dio.dart';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class DangerousGoodsCompetencyModel {
  final String classificationBasis;
  final String packagingGroups;
  final String subsidiaryRisksLabeling;
  final String adgClassesDivisions;
  final String competentAuthority;
  final String transportPreparationSteps;
  final String placardedPassengerException;
  final String emergencyScenario;

  final String name;
  final DateTime date;
  final File? signature;

  final bool isActive;
  final DateTime createdOn;
  final int? createdBy;

  DangerousGoodsCompetencyModel({
    required this.classificationBasis,
    required this.packagingGroups,
    required this.subsidiaryRisksLabeling,
    required this.adgClassesDivisions,
    required this.competentAuthority,
    required this.transportPreparationSteps,
    required this.placardedPassengerException,
    required this.emergencyScenario,
    required this.name,
    required this.date,
    this.signature,
    this.isActive = true,
    required this.createdOn,
    this.createdBy,
  });

  /// Return only string fields for multipart fields, **excluding** files
  Map<String, String> toMultipartFields() {
    return {
      "classification_basis": classificationBasis,
      "packaging_groups": packagingGroups,
      "subsidiary_risks_labeling": subsidiaryRisksLabeling,
      "adg_classes_divisions": adgClassesDivisions,
      "competent_authority": competentAuthority,
      "transport_preparation_steps": transportPreparationSteps,
      "placarded_passenger_exception": placardedPassengerException,
      "emergency_scenario": emergencyScenario,
      "name": name,
      "date": date.toIso8601String().split('T').first,
      "is_active": isActive.toString(),
      "created_on": createdOn.toIso8601String().split('T').first,
      if (createdBy != null) "created_by": createdBy.toString(),
    };
  }

  /// Return the signature file for multipart upload (if any)
  File? getSignatureFile() => signature;

  /// Submit form data including file if present
  static Future<bool> submitForm(DangerousGoodsCompetencyModel model) async {
    final url = "$api_url/employee/dangerous-goods-competency/";
    final api = Api();

    final Map<String, String> fields = model.toMultipartFields();
    final formData = FormData.fromMap(fields);

    if (model.signature != null && await model.signature!.exists()) {
      String fileName = model.signature!.path.split('/').last;
      formData.files.add(MapEntry(
        "signature",
        await MultipartFile.fromFile(model.signature!.path, filename: fileName),
      ));
    }

    final File? signatureFile = model.getSignatureFile();

    final result = await api.multipartOrJsonPostCall(
      url,
      formData,
      isMultipart: signatureFile != null,
    );

    if (result["ok"] == 1) {
      print("Submission success");
      return true;
    } else {
      print("Submission failed: ${result["error"]}");
      return false;
    }
  }
}
