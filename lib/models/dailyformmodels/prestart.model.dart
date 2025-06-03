import 'dart:convert';
import 'dart:io';
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

  final File? photoUploads;
  final File? videoUploads;

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
    this.photoUploads,
    this.videoUploads,
  });

  PrestartModel.empty()
      : date = '',
        time = '',
        name = '',
        rego = '',
        contract = 0,
        shape = 0,
        validLicense = 'yes',
        fitForTask = 'yes',
        notFatigued = 'yes',
        willNotify = 'yes',
        weeklyRest = 'yes',
        restBreak = 'yes',
        substanceClear = 'yes',
        noInfringements = 'yes',
        isActive = true,
        createdOn = '',
        createdBy = 0,
        photoUploads = null,
        videoUploads = null;

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      "date": date,
      "time": time,
      "name": name,
      "rego": rego,
      "contract": contract.toString(),
      "shape": shape.toString(),
      "valid_license": validLicense,
      "fit_for_task": fitForTask,
      "not_fatigued": notFatigued,
      "will_notify": willNotify,
      "weekly_rest": weeklyRest,
      "rest_break": restBreak,
      "substance_clear": substanceClear,
      "no_infringements": noInfringements,
      "is_active": isActive.toString(),
      "created_on": createdOn.split('T').first,
      "created_by": createdBy.toString(),
    };

    if (photoUploads != null) {
      fields['photo_uploads'] = photoUploads!;
    }

    if (videoUploads != null) {
      fields['video_uploads'] = videoUploads!;
    }

    return fields;
  }

  static Future<bool> submitForm(PrestartModel model) async {
    final api = Api();
    final url = '$api_url/dailyreport/prestart/';
    print('URL: $url');

    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: true,
    );

    print('Response: $result');
    return result["ok"] == 1;
  }

  @override
  String toString() {
    return 'PrestartModel {date: $date, time: $time, name: $name, rego: $rego, contract: $contract, '
        'shape: $shape, validLicense: $validLicense, fitForTask: $fitForTask, notFatigued: $notFatigued, '
        'willNotify: $willNotify, weeklyRest: $weeklyRest, restBreak: $restBreak, substanceClear: $substanceClear, '
        'noInfringements: $noInfringements, isActive: $isActive, createdOn: $createdOn, createdBy: $createdBy}';
  }
}
