import 'dart:io';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class WorkHealthSafetyQuestionnaireModel {
  final String name;
  final String date;

  // Choices as String fields
  final String workerDefinition;
  final String pcbuDefinition;
  final String workerDuty;
  final String failureRiskAssessment;
  final String mechanicalFaultAction;
  final String nonComplianceConsequences;
  final String pcbuDutyOfCare;
  final String failingHazardRiskAssessment;
  final String failingReportRisks;
  final String hierarchyOfControlUsed;
  final String eliminationRiskStrength;
  final String colleagueAffectedAlcohol;
  final String safeWorkAdviceContact;
  final String nonComplianceLinfox;
  final String nonComplianceWHSAct;

  final File? signature;

  final bool isActive;
  final String createdOn;
  final int? createdBy;

  WorkHealthSafetyQuestionnaireModel({
    required this.name,
    required this.date,
    required this.workerDefinition,
    required this.pcbuDefinition,
    required this.workerDuty,
    required this.failureRiskAssessment,
    required this.mechanicalFaultAction,
    required this.nonComplianceConsequences,
    required this.pcbuDutyOfCare,
    required this.failingHazardRiskAssessment,
    required this.failingReportRisks,
    required this.hierarchyOfControlUsed,
    required this.eliminationRiskStrength,
    required this.colleagueAffectedAlcohol,
    required this.safeWorkAdviceContact,
    required this.nonComplianceLinfox,
    required this.nonComplianceWHSAct,
    this.signature,
    required this.isActive,
    required this.createdOn,
    this.createdBy,
  });

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      "name": name,
      "date": date,
      "worker_definition": workerDefinition,
      "pcbu_definition": pcbuDefinition,
      "worker_duty": workerDuty,
      "failure_risk_assessment": failureRiskAssessment,
      "mechanical_fault_action": mechanicalFaultAction,
      "non_compliance_consequences": nonComplianceConsequences,
      "pcbu_duty_of_care": pcbuDutyOfCare,
      "failing_hazard_risk_assessment": failingHazardRiskAssessment,
      "failing_report_risks": failingReportRisks,
      "hierarchy_of_control_used": hierarchyOfControlUsed,
      "elimination_risk_strength": eliminationRiskStrength,
      "colleague_affected_alcohol": colleagueAffectedAlcohol,
      "safe_work_advice_contact": safeWorkAdviceContact,
      "non_compliance_linfox": nonComplianceLinfox,
      "non_compliance_whs_act": nonComplianceWHSAct,
      "is_active": isActive ? true : false,
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

  factory WorkHealthSafetyQuestionnaireModel.fromJson(
      Map<String, dynamic> json) {
    return WorkHealthSafetyQuestionnaireModel(
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      workerDefinition: json['worker_definition'] ?? '',
      pcbuDefinition: json['pcbu_definition'] ?? '',
      workerDuty: json['worker_duty'] ?? '',
      failureRiskAssessment: json['failure_risk_assessment'] ?? '',
      mechanicalFaultAction: json['mechanical_fault_action'] ?? '',
      nonComplianceConsequences: json['non_compliance_consequences'] ?? '',
      pcbuDutyOfCare: json['pcbu_duty_of_care'] ?? '',
      failingHazardRiskAssessment: json['failing_hazard_risk_assessment'] ?? '',
      failingReportRisks: json['failing_report_risks'] ?? '',
      hierarchyOfControlUsed: json['hierarchy_of_control_used'] ?? '',
      eliminationRiskStrength: json['elimination_risk_strength'] ?? '',
      colleagueAffectedAlcohol: json['colleague_affected_alcohol'] ?? '',
      safeWorkAdviceContact: json['safe_work_advice_contact'] ?? '',
      nonComplianceLinfox: json['non_compliance_linfox'] ?? '',
      nonComplianceWHSAct: json['non_compliance_whs_act'] ?? '',
      signature: null,
      isActive: json['is_active'] ?? true,
      createdOn: json['created_on'] ?? '',
      createdBy: _parseInt(json['created_by']),
    );
  }

  static bool _parseBool(dynamic val, {bool defaultValue = false}) {
    if (val is bool) return val;
    if (val is String) {
      final v = val.toLowerCase();
      return v == 'true' || v == '1';
    }
    if (val is int) return val == 1;
    return defaultValue;
  }

  static int? _parseInt(dynamic val) {
    if (val == null) return null;
    if (val is int) return val;
    if (val is String) return int.tryParse(val);
    return null;
  }

  static Future<bool> submitForm(
      WorkHealthSafetyQuestionnaireModel model) async {
    final api = Api();
    final url = '$api_url/employee/work-health-safety-questionnaire/';
    print(url);
    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: model.signature != null,
    );
    print(result);

    return result["ok"] == 1;
  }

  @override
  String toString() {
    return 'WorkHealthSafetyQuestionnaireModel(name: $name, date: $date)';
  }
}
