import 'dart:io';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class WeighbridgeModel {
  final String date;
  final String name;
  final String drivername;
  final String depot;
  final File? weighbridgeDocketFile;
  final File? loadPicAndSheetFile;
  final bool isActive;
  final String createdOn;
  final int? createdBy;

  WeighbridgeModel({
    required this.date,
    required this.name,
    required this.drivername,
    required this.depot,
    this.weighbridgeDocketFile,
    this.loadPicAndSheetFile,
    this.isActive = true,
    required this.createdOn,
    this.createdBy,
  });

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      'date': date,
      'name': name,
      'drivername': drivername,
      'depot': depot,
      'is_active': isActive.toString(),
      'created_on':
          createdOn.contains('T') ? createdOn.split('T').first : createdOn,
    };

    if (createdBy != null) {
      fields['created_by'] = createdBy.toString();
    }

    if (weighbridgeDocketFile != null) {
      fields['weighbridge_docket'] = weighbridgeDocketFile!;
    }

    if (loadPicAndSheetFile != null) {
      fields['load_pic_and_sheet'] = loadPicAndSheetFile!;
    }

    return fields;
  }

  /// Submit this model using your Api helper
  static Future<bool> submitWeighbridge(WeighbridgeModel model) async {
    final url = "$api_url/dailyreport/weighbridge/";
    final api = Api();

    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: true,
    );

    if (result['ok'] == 1) {
      print('Weighbridge submitted successfully.');
      return true;
    } else {
      print('Failed to submit weighbridge: ${result['error']}');
      return false;
    }
  }
}
