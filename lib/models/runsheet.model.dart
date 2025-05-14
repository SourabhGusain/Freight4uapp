import 'dart:convert';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class RunsheetModel {
  final String shiftType;
  final String shiftDate;
  final String name;
  final String email;
  final int site;
  final int shape;
  final String rego;
  final String shiftStartTime;
  final String shiftEndTime;
  final int loadsDone;
  final int breaksTaken;
  final String loadSheet;
  final bool isActive;
  final String createdOn;
  final int createdBy;

  RunsheetModel({
    required this.shiftType,
    required this.shiftDate,
    required this.name,
    required this.email,
    required this.site,
    required this.shape,
    required this.rego,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.loadsDone,
    required this.breaksTaken,
    required this.loadSheet,
    required this.isActive,
    required this.createdOn,
    required this.createdBy,
  });

  factory RunsheetModel.fromJson(Map<String, dynamic> json) {
    return RunsheetModel(
      shiftDate: json['shift_date'] ?? '',
      shiftType: json['shift_type'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      site: json['site'] ?? 0,
      shape: json['shape'] ?? 0,
      rego: json['rego'] ?? '',
      shiftStartTime: json['shift_start_time'] ?? '',
      shiftEndTime: json['shift_end_time'] ?? '',
      loadsDone: json['loads_done'] ?? 0,
      breaksTaken: json['breaks_taken'] ?? 0,
      loadSheet: json['load_sheet'] ?? '',
      isActive: json['is_active'] ?? false,
      createdOn: json['created_on'] ?? '',
      createdBy: json['created_by'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "shift_date": shiftDate,
      "shift_type": shiftType,
      "name": name,
      "email": email,
      "site": site,
      "shape": shape,
      "rego": rego,
      "shift_start_time": shiftStartTime,
      "shift_end_time": shiftEndTime,
      "loads_done": loadsDone,
      "breaks_taken": breaksTaken,
      "load_sheet": loadSheet,
      "is_active": isActive,
      "created_on": createdOn.split('T').first,
      "created_by": createdBy,
    };
  }

  @override
  String toString() {
    return 'RunsheetModel {shiftType: $shiftType, shiftDate: $shiftDate, name: $name, email: $email, '
        'site: $site, shape: $shape, rego: $rego, shiftStartTime: $shiftStartTime, shiftEndTime: $shiftEndTime, '
        'loadsDone: $loadsDone, breaksTaken: $breaksTaken, loadSheet: $loadSheet, isActive: $isActive, '
        'createdOn: $createdOn, createdBy: $createdBy}';
  }

  static Future<bool> submitRunsheet(RunsheetModel RunsheetModel) async {
    final url = '$api_url/dailyreport/runsheet/';
    print('API URL: $url');

    try {
      final data = RunsheetModel.toJson();
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
        print('Shift form submitted successfully');
        return true;
      } else {
        print(
            'Failed to submit shift: ${response?['error'] ?? "Unknown error"}');
        return false;
      }
    } catch (e) {
      print('Error during submitRunsheet: $e');
      return false;
    }
  }
}
