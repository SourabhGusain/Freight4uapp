import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/employeemodels/safetyquestionnaire.model.dart';

class WorkHealthSafetyQuestionnaireController {
  final Session session = Session();
  int userId = 0;

  File? signatureFile;

  // Text controllers for user inputs
  final fullNameController = TextEditingController();
  final dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );

  late Map<String, String> workerDefinitionOptions;
  late Map<String, String> pcbuDefinitionOptions;
  late Map<String, String> workerDutyOptions;
  late Map<String, String> failureRiskAssessmentOptions;
  late Map<String, String> mechanicalFaultActionOptions;
  late Map<String, String> nonComplianceConsequencesOptions;
  late Map<String, String> pcbuDutyOfCareOptions;
  late Map<String, String> failingHazardRiskAssessmentOptions;
  late Map<String, String> failingReportRisksOptions;
  late Map<String, String> hierarchyOfControlUsedOptions;
  late Map<String, String> eliminationRiskStrengthOptions;
  late Map<String, String> colleagueAffectedAlcoholOptions;
  late Map<String, String> safeWorkAdviceContactOptions;
  late Map<String, String> nonComplianceLinfoxOptions;
  late Map<String, String> nonComplianceWHSActOptions;

  String? workerDefinition;
  String? pcbuDefinition;
  String? workerDuty;
  String? failureRiskAssessment;
  String? mechanicalFaultAction;
  String? nonComplianceConsequences;
  String? pcbuDutyOfCare;
  String? failingHazardRiskAssessment;
  String? failingReportRisks;
  String? hierarchyOfControlUsed;
  String? eliminationRiskStrength;
  String? colleagueAffectedAlcohol;
  String? safeWorkAdviceContact;
  String? nonComplianceLinfox;
  String? nonComplianceWHSAct;

  WorkHealthSafetyQuestionnaireController() {
    _loadChoices();
    // _setDefaultSelections();
  }

  void _loadChoices() {
    // Corrected key = label, value = id for all maps
    workerDefinitionOptions = {
      "Only full time staff": "full_time",
      "Only casual staff": "casual",
      "All employees, contractors, sub-contractors and apprentices":
          "all_inclusive",
      "Anyone who is not a contractor": "not_contractor",
    };
    pcbuDefinitionOptions = {
      "Canteen staff": "canteen",
      "PCBU or employer": "pcbu_employer",
      "Your work mates": "workmates",
      "No such thing exists": "no_such_thing",
    };
    workerDutyOptions = {
      "Ensuring health and safety themselves": "self_safety",
      "Ensuring acts and commissions to not present risks to others":
          "no_risk_to_others",
      "Complying with any instruction or policy of the work place":
          "comply_policy",
      "All of the above": "all_of_above_duty",
    };
    failureRiskAssessmentOptions = {
      "Creating risk to others in the work place": "creating_risk",
      "Normal practice at Linfox": "normal_practice",
      "Not my problem": "not_my_problem_risk",
      "None of these": "none_of_these_risk",
    };
    mechanicalFaultActionOptions = {
      "Not my problem": "not_my_problem_fault",
      "Make sure no one sees the trouble": "hide_fault",
      "Not report it to stay out of trouble": "avoid_report",
      "Report it as required as a worker under WHS law": "report_required",
    };
    nonComplianceConsequencesOptions = {
      "Dismissal of a worker in a workplace": "dismissal",
      "Penalties and fines to workers from Safework NSW": "penalties",
      "Performance management with HR": "performance_management",
      "All of the above.": "all_of_above_non_compliance",
    };
    pcbuDutyOfCareOptions = {
      "Managers only": "managers_only",
      "All workers and other persons at the work place": "all_workers",
      "Full time employees only": "full_time_only",
      "Company directors only": "company_directors",
    };
    failingHazardRiskAssessmentOptions = {
      "Not complying with Work Health and Safety Laws": "not_complying",
      "Placing other workers at risk of injury and even":
          "placing_others_at_risk",
      "All of the above": "all_of_above_hazard",
    };
    failingReportRisksOptions = {
      "Placing the community at risk": "community_at_risk",
      "Placing my job at risk": "job_at_risk",
      "Placing workers at risk": "workers_at_risk",
      "All of the above": "all_of_above_report",
    };
    hierarchyOfControlUsedOptions = {
      "Only in textbooks": "textbooks_only",
      "At every opportunity when risk has been identified": "every_opportunity",
      "Only on training days": "training_days_only",
      "Only if a manager tells me to": "manager_tells_me",
    };
    eliminationRiskStrengthOptions = {
      "The strongest control measure": "strongest",
      "The 2nd strongest control measure": "second_strongest",
      "The 4th strongest control measure": "fourth_strongest",
      "Not required": "not_required_elimination",
    };
    colleagueAffectedAlcoholOptions = {
      "Accepting this as acceptable work practices": "acceptable_practice",
      "Placing others at work at risk of injury": "placing_others_risk_alcohol",
      "Failing to comply with Work Health and Safety Laws":
          "failing_comply_alcohol",
      "All of the above": "all_of_above_alcohol",
    };
    safeWorkAdviceContactOptions = {
      "Emergency services on 000": "emergency_000",
      "Poisons Information Centre 131 126": "poisons_131126",
      "Pizza Hut 131 166": "pizza_hut_131166",
      "Safework NSW 131 050": "safework_131050",
    };
    nonComplianceLinfoxOptions = {
      "Not worth worrying about": "not_worried",
      "Only HR to deal with": "only_hr",
      "Can be a dangerous incident and reported to Safe Work NSW":
          "dangerous_report",
      "Only between management and the worker": "management_worker_only",
    };
    nonComplianceWHSActOptions = {
      "Failing to complete and submit risk assessments and reports":
          "failing_risk_assessments",
      "Not reporting damaged plant and equipment to supervisors":
          "not_reporting_damage",
      "Reporting false information on WHS reports and assessments":
          "reporting_false_info",
      "All of the above": "all_of_above_whs",
    };
  }

  // void _setDefaultSelections() {
  //   // Set defaults to the first keys (labels) of each map
  //   workerDefinition = workerDefinitionOptions.keys.first;
  //   pcbuDefinition = pcbuDefinitionOptions.keys.first;
  //   workerDuty = workerDutyOptions.keys.first;
  //   failureRiskAssessment = failureRiskAssessmentOptions.keys.first;
  //   mechanicalFaultAction = mechanicalFaultActionOptions.keys.first;
  //   nonComplianceConsequences = nonComplianceConsequencesOptions.keys.first;
  //   pcbuDutyOfCare = pcbuDutyOfCareOptions.keys.first;
  //   failingHazardRiskAssessment = failingHazardRiskAssessmentOptions.keys.first;
  //   failingReportRisks = failingReportRisksOptions.keys.first;
  //   hierarchyOfControlUsed = hierarchyOfControlUsedOptions.keys.first;
  //   eliminationRiskStrength = eliminationRiskStrengthOptions.keys.first;
  //   colleagueAffectedAlcohol = colleagueAffectedAlcoholOptions.keys.first;
  //   safeWorkAdviceContact = safeWorkAdviceContactOptions.keys.first;
  //   nonComplianceLinfox = nonComplianceLinfoxOptions.keys.first;
  //   nonComplianceWHSAct = nonComplianceWHSActOptions.keys.first;
  // }

  Future<void> init() async {
    final userIdStr = await session.getSession("userId");
    userId = int.tryParse(userIdStr ?? "") ?? 0;
  }

  DateTime parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      print(
          'Warning: Failed to parse date "$dateStr". Using DateTime.now() instead.');
      return DateTime.now();
    }
  }

  Future<void> populateFromSession() async {
    final userJson = await session.getSession('loggedInUser');
    if (userJson == null) return;

    final Map<String, dynamic> userData = jsonDecode(userJson);
    fullNameController.text = userData["name"] ?? "";
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> setSignature(Uint8List signatureBytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/signature.png');
    await file.writeAsBytes(signatureBytes);
    signatureFile = file;
  }

  bool validateFields() {
    if (signatureFile == null) {
      print('Signature is required.');
      return false;
    }

    if (fullNameController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty) {
      print('Please fill in all required fields.');
      return false;
    }

    final selectionFields = [
      workerDefinition,
      pcbuDefinition,
      workerDuty,
      failureRiskAssessment,
      mechanicalFaultAction,
      nonComplianceConsequences,
      pcbuDutyOfCare,
      failingHazardRiskAssessment,
      failingReportRisks,
      hierarchyOfControlUsed,
      eliminationRiskStrength,
      colleagueAffectedAlcohol,
      safeWorkAdviceContact,
      nonComplianceLinfox,
      nonComplianceWHSAct,
    ];

    if (selectionFields.any((item) => item == null || item.trim().isEmpty)) {
      print('Please select all required options.');
      return false;
    }

    try {
      parseDate(dateController.text.trim());
    } catch (e) {
      print('Invalid date format.');
      return false;
    }

    return true;
  }

  Future<bool> submitForm() async {
    if (!validateFields()) return false;

    final model = WorkHealthSafetyQuestionnaireModel(
      name: fullNameController.text.trim(),
      date: dateController.text.trim(),
      workerDefinition: workerDefinitionOptions[workerDefinition!]!,
      pcbuDefinition: pcbuDefinitionOptions[pcbuDefinition!]!,
      workerDuty: workerDutyOptions[workerDuty!]!,
      failureRiskAssessment:
          failureRiskAssessmentOptions[failureRiskAssessment!]!,
      mechanicalFaultAction:
          mechanicalFaultActionOptions[mechanicalFaultAction!]!,
      nonComplianceConsequences:
          nonComplianceConsequencesOptions[nonComplianceConsequences!]!,
      pcbuDutyOfCare: pcbuDutyOfCareOptions[pcbuDutyOfCare!]!,
      failingHazardRiskAssessment:
          failingHazardRiskAssessmentOptions[failingHazardRiskAssessment!]!,
      failingReportRisks: failingReportRisksOptions[failingReportRisks!]!,
      hierarchyOfControlUsed:
          hierarchyOfControlUsedOptions[hierarchyOfControlUsed!]!,
      eliminationRiskStrength:
          eliminationRiskStrengthOptions[eliminationRiskStrength!]!,
      colleagueAffectedAlcohol:
          colleagueAffectedAlcoholOptions[colleagueAffectedAlcohol!]!,
      safeWorkAdviceContact:
          safeWorkAdviceContactOptions[safeWorkAdviceContact!]!,
      nonComplianceLinfox: nonComplianceLinfoxOptions[nonComplianceLinfox!]!,
      nonComplianceWHSAct: nonComplianceWHSActOptions[nonComplianceWHSAct!]!,
      signature: signatureFile,
      isActive: true,
      createdOn: DateTime.now().toIso8601String(),
      createdBy: userId,
    );

    final success = await WorkHealthSafetyQuestionnaireModel.submitForm(model);
    print('Submission status: $success');
    return success;
  }

  void reset() {
    fullNameController.clear();
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    signatureFile = null;

    // _setDefaultSelections();
  }

  void dispose() {
    fullNameController.dispose();
    dateController.dispose();
  }
}
