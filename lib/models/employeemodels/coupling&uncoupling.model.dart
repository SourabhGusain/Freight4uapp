import 'dart:io';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class CouplingUncouplingQuestionnaireModel {
  final String risksIdentified;
  final String safetyControls;
  final String faultAction;
  final String uncouplingSequence; // Char, one of A, B, C, D
  final String postUnpinAction;
  final String couplingSequence; // Char, one of A, B, C, D
  final String airLeadsTwist;
  final String tugTestsCount;
  final String distractionAction;
  final String climbingSafety;
  final String name;
  final String lastName;
  final DateTime acknowledgmentDate;
  final File? signature;

  final bool isActive;
  final DateTime createdOn;
  final int? createdBy;

  CouplingUncouplingQuestionnaireModel({
    required this.risksIdentified,
    required this.safetyControls,
    required this.faultAction,
    required this.uncouplingSequence,
    required this.postUnpinAction,
    required this.couplingSequence,
    required this.airLeadsTwist,
    required this.tugTestsCount,
    required this.distractionAction,
    required this.climbingSafety,
    required this.name,
    required this.lastName,
    required this.acknowledgmentDate,
    this.signature,
    this.isActive = true,
    required this.createdOn,
    this.createdBy,
  });

  /// Map string fields for multipart form (excluding file)
  Map<String, String> toMultipartFields() {
    return {
      "risks_identified": risksIdentified,
      "safety_controls": safetyControls,
      "fault_action": faultAction,
      "uncoupling_sequence": uncouplingSequence,
      "post_unpin_action": postUnpinAction,
      "coupling_sequence": couplingSequence,
      "air_leads_twist": airLeadsTwist,
      "tug_tests_count": tugTestsCount,
      "distraction_action": distractionAction,
      "climbing_safety": climbingSafety,
      "name": name,
      "last_name": lastName,
      "acknowledgment_date":
          acknowledgmentDate.toIso8601String().split('T').first,
      "is_active": isActive.toString(),
      "created_on": createdOn.toIso8601String().split('T').first,
      if (createdBy != null) "created_by": createdBy.toString(),
    };
  }

  static Future<bool> submitForm(
      CouplingUncouplingQuestionnaireModel model) async {
    final url = "$api_url/employee/cor-form/";
    print('Submitting CoRForm to $url');
    final api = Api();
    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: model.signature != null,
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
