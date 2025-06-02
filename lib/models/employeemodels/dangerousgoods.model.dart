import 'dart:io';
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

  Map<String, dynamic> toMultipartFields() {
    final fields = {
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
    };

    if (createdBy != null) fields["created_by"] = createdBy.toString();
    return fields;
  }

  static Future<bool> submitForm(DangerousGoodsCompetencyModel model) async {
    final url = "$api_url/employee/dangerous-goods/";
    print("Submitting Dangerous Goods Competency to $url");
    final api = Api();
    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: model.signature != null,
    );

    if (result["ok"] == 1) {
      print("Dangerous Goods submitted successfully.");
      return true;
    } else {
      print("Submission failed: ${result["error"]}");
      return false;
    }
  }

  factory DangerousGoodsCompetencyModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String? dateStr) =>
        DateTime.tryParse(dateStr ?? '') ?? DateTime.now();

    return DangerousGoodsCompetencyModel(
      classificationBasis: json['classification_basis'] ?? '',
      packagingGroups: json['packaging_groups'] ?? '',
      subsidiaryRisksLabeling: json['subsidiary_risks_labeling'] ?? '',
      adgClassesDivisions: json['adg_classes_divisions'] ?? '',
      competentAuthority: json['competent_authority'] ?? '',
      transportPreparationSteps: json['transport_preparation_steps'] ?? '',
      placardedPassengerException: json['placarded_passenger_exception'] ?? '',
      emergencyScenario: json['emergency_scenario'] ?? '',
      name: json['name'] ?? '',
      date: parseDate(json['date']),
      signature: null,
      isActive: json['is_active'] ?? true,
      createdOn: parseDate(json['created_on']),
      createdBy: json['created_by'],
    );
  }
}
