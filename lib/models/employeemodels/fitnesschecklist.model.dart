import 'dart:io';
import 'dart:convert';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class FitnessChecklistModel {
  final String driverName;
  final String dateOf;
  final File signature;

  final String fitForDuty;
  final String mentallyFit;
  final String freeFromTiredness;
  final String freeFromRecreationalFatigue;
  final String visualAcuityOk;
  final String medicalIncidentReported;
  final String recentIncidentsAgeRelatedDecline;
  final String periodicDriverMedicalExaminations;
  final String availableRestAreasAndAmenities;
  final String receiveWelfareChecks;
  final String suitableVentilatedAirConditioned;
  final String bloodAlcoholLevel;
  final String breathSkillsTest;
  final String drugsOrMedication;
  final String counterDrugs;
  final String minimumContinuousBreak;
  final String nonWorkTime;
  final String workADay;
  final String restFor30Minutes;
  final String validLicenceClass;

  final bool isActive;
  final String createdOn;
  final int? createdBy;

  FitnessChecklistModel({
    required this.driverName,
    required this.dateOf,
    required this.signature,
    required this.fitForDuty,
    required this.mentallyFit,
    required this.freeFromTiredness,
    required this.freeFromRecreationalFatigue,
    required this.visualAcuityOk,
    required this.medicalIncidentReported,
    required this.recentIncidentsAgeRelatedDecline,
    required this.periodicDriverMedicalExaminations,
    required this.availableRestAreasAndAmenities,
    required this.receiveWelfareChecks,
    required this.suitableVentilatedAirConditioned,
    required this.bloodAlcoholLevel,
    required this.breathSkillsTest,
    required this.drugsOrMedication,
    required this.counterDrugs,
    required this.minimumContinuousBreak,
    required this.nonWorkTime,
    required this.workADay,
    required this.restFor30Minutes,
    required this.validLicenceClass,
    required this.isActive,
    required this.createdOn,
    this.createdBy,
  });

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      "driver_name": driverName,
      "date_of": dateOf,
      "signature": signature,
      "fit_for_duty": fitForDuty,
      "mentally_fit": mentallyFit,
      "free_from_tiredness": freeFromTiredness,
      "free_from_recreational_fatigue": freeFromRecreationalFatigue,
      "visual_acuity_ok": visualAcuityOk,
      "medical_incident_reported": medicalIncidentReported,
      "recent_incidents_age_related_decline": recentIncidentsAgeRelatedDecline,
      "periodic_driver_medical_examinations": periodicDriverMedicalExaminations,
      "available_rest_areas_and_amenities": availableRestAreasAndAmenities,
      "receive_welfare_checks": receiveWelfareChecks,
      "suitable_ventilated_air_conditioned": suitableVentilatedAirConditioned,
      "blood_alcohol_level": bloodAlcoholLevel,
      "breath_skills_test": breathSkillsTest,
      "drugs_or_medication": drugsOrMedication,
      "counter_drugs": counterDrugs,
      "minimum_continuous_break": minimumContinuousBreak,
      "non_work_time": nonWorkTime,
      "work_a_day": workADay,
      "rest_for_30_minutes": restFor30Minutes,
      "valid_licence_class": validLicenceClass,
      "is_active": isActive.toString(),
      "created_on":
          createdOn.contains('T') ? createdOn.split('T').first : createdOn,
    };

    if (createdBy != null) {
      fields["created_by"] = createdBy.toString();
    }

    return fields;
  }

  static Future<bool> submitChecklist(FitnessChecklistModel model) async {
    final api = Api();
    final url = "$api_url/employee/fitness-checklist/";

    final result = await api.multipartOrJsonPostCall(
      url,
      model.toMultipartFields(),
      isMultipart: true,
    );

    if (result["ok"] == 1) {
      print("✅ Fitness checklist submitted successfully.");
      return true;
    } else {
      print("❌ Error submitting fitness checklist: ${result["error"]}");
      return false;
    }
  }
}
