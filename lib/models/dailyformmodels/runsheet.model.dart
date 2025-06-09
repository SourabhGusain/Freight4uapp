import 'dart:io';
import 'dart:convert';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class ShiftBreak {
  final String startTime;
  final String endTime;

  ShiftBreak({required this.startTime, required this.endTime});

  factory ShiftBreak.fromJson(Map<String, dynamic> json) {
    return ShiftBreak(
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
    );
  }

  Map<String, String> toMap() => {
        'start_time': startTime,
        'end_time': endTime,
      };
}

class RunsheetModel {
  final String shiftType;
  final String shiftDate;
  final String name;
  final String email;
  final int? site;
  final String? point1CityName;
  final String? point2CityName;
  final String? waitingTime;
  final int? shape;
  final String rego;
  final String shiftStartTime;
  final String shiftEndTime;
  final int loadsDone;
  final int breaksTaken;
  final List<ShiftBreak> shiftBreaks;
  final bool isActive;
  final String createdOn;
  final int? createdBy;

  RunsheetModel({
    required this.shiftType,
    required this.shiftDate,
    required this.name,
    required this.email,
    this.site,
    this.point1CityName,
    this.point2CityName,
    this.waitingTime,
    this.shape,
    required this.rego,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.loadsDone,
    required this.breaksTaken,
    required this.shiftBreaks,
    required this.isActive,
    required this.createdOn,
    this.createdBy,
  });

  Map<String, dynamic> toMultipartFields({File? loadSheetFile}) {
    final fields = <String, dynamic>{
      "shift_type": shiftType,
      "shift_date": shiftDate,
      "name": name,
      "email": email,
      "rego": rego,
      "shift_start_time": shiftStartTime,
      "shift_end_time": shiftEndTime,
      "loads_done": loadsDone.toString(),
      "breaks_taken": breaksTaken.toString(),
      "is_active": isActive.toString(),
      "point1_city_name": point1CityName,
      "point2_city_name": point2CityName,
      "waiting_time": waitingTime,
      "created_on":
          createdOn.contains('T') ? createdOn.split('T').first : createdOn,
      "shift_breaks": jsonEncode(
        shiftBreaks.map((e) => e.toMap()).toList(),
      ),
    };
    if (site != null) fields["site"] = site.toString();
    if (shape != null) fields["shape"] = shape.toString();
    if (createdBy != null) fields["created_by"] = createdBy.toString();
    if (loadSheetFile != null) fields["load_sheet"] = loadSheetFile;

    return fields;
  }

  static Future<bool> submitRunsheet(
      RunsheetModel model, File loadSheetFile) async {
    final url = "$api_url/dailyreport/runsheet/";
    final api = Api();

    final fields = model.toMultipartFields(loadSheetFile: loadSheetFile);

    // print("______________FormData fields:______________");
    // fields.forEach((key, value) {
    //   print("Field: $key = $value");
    // });

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: true,
    );

    if (result["ok"] == 1) {
      print("Runsheet submitted successfully.");
      return true;
    } else {
      print("Failed to submit runsheet: ${result["error"]}");
      return false;
    }
  }
}
