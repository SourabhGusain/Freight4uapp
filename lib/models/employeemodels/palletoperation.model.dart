import 'dart:io';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class EPJMPJAssessmentModel {
  final String acknowledgmentDate;
  final String name;
  final File? signature;

  // Choice fields (Strings expected by Django)
  final String q1ManualPalletCheck;
  final String q2RideOnPalletJack; // "Yes" / "No"
  final String q3SurfaceCheck;
  final String q4PushWithHandle; // "Yes" / "No"
  final String q5EnsureLoadStable; // "Yes" / "No"
  final String q6IfDifficultToMove;

  // Read-only server-managed fields
  final bool? isActive;
  final String? createdOn;
  final int? createdBy;

  EPJMPJAssessmentModel({
    required this.acknowledgmentDate,
    required this.name,
    this.signature,
    required this.q1ManualPalletCheck,
    required this.q2RideOnPalletJack,
    required this.q3SurfaceCheck,
    required this.q4PushWithHandle,
    required this.q5EnsureLoadStable,
    required this.q6IfDifficultToMove,
    this.isActive,
    this.createdOn,
    this.createdBy,
  });

  /// Data to send to API
  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      "acknowledgment_date": acknowledgmentDate,
      "name": name,
      "q1_manual_pallet_check": q1ManualPalletCheck,
      "q2_ride_on_pallet_jack": q2RideOnPalletJack,
      "q3_surface_check": q3SurfaceCheck,
      "q4_push_with_handle": q4PushWithHandle,
      "q5_ensure_load_stable": q5EnsureLoadStable,
      "q6_if_difficult_to_move": q6IfDifficultToMove,
    };

    if (isActive != null) {
      fields["is_active"] = isActive.toString();
    }
    if (createdOn != null) {
      fields["created_on"] = createdOn!.split('T').first;
    }
    if (createdBy != null) {
      fields["created_by"] = createdBy.toString();
    }
    if (signature != null) {
      fields["signature"] = signature;
    }

    return fields;
  }

  /// Convert from JSON response (e.g. from GET)
  factory EPJMPJAssessmentModel.fromJson(Map<String, dynamic> json) {
    return EPJMPJAssessmentModel(
      acknowledgmentDate: json['acknowledgment_date'] ?? '',
      name: json['name'] ?? '',
      signature: null, // Handle separately
      q1ManualPalletCheck: json['q1_manual_pallet_check'] ?? '',
      q2RideOnPalletJack: json['q2_ride_on_pallet_jack'] ?? 'No',
      q3SurfaceCheck: json['q3_surface_check'] ?? '',
      q4PushWithHandle: json['q4_push_with_handle'] ?? 'No',
      q5EnsureLoadStable: json['q5_ensure_load_stable'] ?? 'No',
      q6IfDifficultToMove: json['q6_if_difficult_to_move'] ?? '',
      isActive: json['is_active'] ?? true,
      createdOn: json['created_on'],
      createdBy: json['created_by'],
    );
  }

  /// Send POST request
  static Future<bool> submitForm(EPJMPJAssessmentModel model) async {
    final api = Api();
    final url = '$api_url/employee/epjmpj-assessment/';
    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: model.signature != null,
    );

    return result["ok"] == 1;
  }

  @override
  String toString() {
    return 'EPJMPJAssessmentModel('
        'acknowledgmentDate: $acknowledgmentDate, '
        'name: $name, '
        'signature: ${signature?.path}, '
        'q1ManualPalletCheck: $q1ManualPalletCheck, '
        'q2RideOnPalletJack: $q2RideOnPalletJack, '
        'q3SurfaceCheck: $q3SurfaceCheck, '
        'q4PushWithHandle: $q4PushWithHandle, '
        'q5EnsureLoadStable: $q5EnsureLoadStable, '
        'q6IfDifficultToMove: $q6IfDifficultToMove, '
        'createdBy: $createdBy, '
        'createdOn: $createdOn, '
        'isActive: $isActive'
        ')';
  }
}
