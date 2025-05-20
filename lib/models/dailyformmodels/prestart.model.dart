import 'dart:convert';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class PrestartModel {
  final String date;
  final String time;
  final String name;
  final String rego;
  final int contract;
  final int shape;
  final String validLicense;
  final String fitForTask;
  final String notFatigued;
  final String willNotify;
  final String weeklyRest;
  final String restBreak;
  final String substanceClear;
  final String noInfringements;
  final bool isActive;
  final String createdOn;
  final int createdBy;

  PrestartModel({
    required this.date,
    required this.time,
    required this.name,
    required this.rego,
    required this.contract,
    required this.shape,
    required this.validLicense,
    required this.fitForTask,
    required this.notFatigued,
    required this.willNotify,
    required this.weeklyRest,
    required this.restBreak,
    required this.substanceClear,
    required this.noInfringements,
    required this.isActive,
    required this.createdOn,
    required this.createdBy,
  });

  PrestartModel.empty()
      : date = '',
        time = '',
        name = '',
        rego = '',
        contract = 0,
        shape = 0,
        validLicense = '',
        fitForTask = '',
        notFatigued = '',
        willNotify = '',
        weeklyRest = '',
        restBreak = '',
        substanceClear = '',
        noInfringements = '',
        isActive = false,
        createdOn = '',
        createdBy = 0;

  factory PrestartModel.fromJson(Map<String, dynamic> json) {
    return PrestartModel(
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      name: json['name'] ?? '',
      rego: json['rego'] ?? '',
      contract: json['contract'] ?? 0,
      shape: json['shape'] ?? 0,
      validLicense: json['valid_license'] ?? '',
      fitForTask: json['fit_for_task'] ?? '',
      notFatigued: json['not_fatigued'] ?? '',
      willNotify: json['will_notify'] ?? '',
      weeklyRest: json['weekly_rest'] ?? '',
      restBreak: json['rest_break'] ?? '',
      substanceClear: json['substance_clear'] ?? '',
      noInfringements: json['no_infringements'] ?? '',
      isActive: json['is_active'] ?? false,
      createdOn: json['created_on'] ?? '',
      createdBy: json['created_by'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "time": time,
      "name": name,
      "rego": rego,
      "contract": contract,
      "shape": shape,
      "valid_license": validLicense,
      "fit_for_task": fitForTask,
      "not_fatigued": notFatigued,
      "will_notify": willNotify,
      "weekly_rest": weeklyRest,
      "rest_break": restBreak,
      "substance_clear": substanceClear,
      "no_infringements": noInfringements,
      "is_active": isActive,
      "created_on": createdOn.split('T').first,
      "created_by": createdBy,
    };
  }

  @override
  String toString() {
    return 'PrestartModel {date: $date, time: $time, name: $name, rego: $rego, contract: $contract, '
        'shape: $shape, validLicense: $validLicense, fitForTask: $fitForTask, notFatigued: $notFatigued, '
        'willNotify: $willNotify, weeklyRest: $weeklyRest, restBreak: $restBreak, substanceClear: $substanceClear, '
        'noInfringements: $noInfringements, isActive: $isActive, createdOn: $createdOn, createdBy: $createdBy}';
  }

  static Future<bool> preStartForm(PrestartModel prestartModel) async {
    final url = '$api_url/dailyreport/prestart/';
    print('API URL: $url');

    try {
      final data = prestartModel.toJson();
      print('Sending data: $data');

      final response = await Api().postCalling(
        url,
        jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print('Response: $response');

      if (response != null && response['ok'] == 1) {
        print('Prestart form submitted successfully');
        return true;
      } else {
        print(
            'Failed to create prestart: ${response?['error'] ?? "Unknown error"}');
        return false;
      }
    } catch (e) {
      print('Error during preStartForm: $e');
      return false;
    }
  }
}
