import 'dart:io';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class VehicleConditionReportModel {
  final String driverName;
  final String date;
  final String time;
  final int? site;
  final String siteManager;
  final String registration;
  final int odometerReading;
  final String category;
  final String description;
  final String comments;
  final File? uploadPhoto;
  final File signature;
  final bool isActive;
  final String createdOn;
  final int? createdBy;

  VehicleConditionReportModel({
    required this.date,
    required this.time,
    required this.driverName,
    this.site,
    required this.siteManager,
    required this.registration,
    required this.odometerReading,
    required this.category,
    required this.description,
    required this.comments,
    this.uploadPhoto,
    required this.signature,
    this.isActive = true,
    required this.createdOn,
    this.createdBy,
  });

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      'date': date,
      'time': time,
      'driver_name': driverName,
      'site': site?.toString(),
      'site_manager': siteManager,
      'registration': registration,
      'odometer_reading': odometerReading.toString(),
      'category': category,
      'description': description,
      'comments': comments,
      'is_active': isActive.toString(),
      'created_on':
          createdOn.contains('T') ? createdOn.split('T').first : createdOn,
    };

    if (createdBy != null) fields['created_by'] = createdBy.toString();
    if (uploadPhoto != null) fields['photo_uploads'] = uploadPhoto;
    fields['signature'] = signature;

    fields.removeWhere((key, value) => value == null);

    return fields;
  }

  static Future<bool> submitReport(VehicleConditionReportModel model) async {
    final url = "$api_url/dailyreport/vehicle-condition/";
    final api = Api();
    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: true,
    );

    if (result['ok'] == 1) {
      print('Vehicle condition report submitted successfully.');
      return true;
    } else {
      print('Failed to submit vehicle condition report: ${result['error']}');
      return false;
    }
  }
}
