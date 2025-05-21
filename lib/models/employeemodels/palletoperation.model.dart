import 'dart:io';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class EPJMPJAssessmentModel {
  final String acknowledgmentDate;
  final String name;
  final File? signature;
  final String q1ManualPalletCheck;
  final bool q2RideOnPalletJack;
  final String q3SurfaceCheck;
  final bool q4PushWithHandle;
  final bool q5EnsureLoadStable;
  final String q6IfDifficultToMove;
  final bool isActive;
  final String createdOn;
  final int createdBy;

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
    required this.isActive,
    required this.createdOn,
    required this.createdBy,
  });

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      "acknowledgment_date": acknowledgmentDate,
      "name": name,
      "q1_manual_pallet_check": q1ManualPalletCheck,
      "q2_ride_on_pallet_jack": q2RideOnPalletJack.toString(),
      "q3_surface_check": q3SurfaceCheck,
      "q4_push_with_handle": q4PushWithHandle.toString(),
      "q5_ensure_load_stable": q5EnsureLoadStable.toString(),
      "q6_if_difficult_to_move": q6IfDifficultToMove,
      "is_active": isActive.toString(),
      "created_on": createdOn.split('T').first,
      "created_by": createdBy.toString(),
    };

    if (signature != null) {
      fields["signature"] = signature;
    }

    return fields;
  }

  factory EPJMPJAssessmentModel.fromJson(Map<String, dynamic> json) {
    return EPJMPJAssessmentModel(
      acknowledgmentDate: json['acknowledgment_date'] ?? '',
      name: json['name'] ?? '',
      signature: null,
      q1ManualPalletCheck: json['q1_manual_pallet_check'] ?? '',
      q2RideOnPalletJack: json['q2_ride_on_pallet_jack'] == true ||
          json['q2_ride_on_pallet_jack'] == 'true',
      q3SurfaceCheck: json['q3_surface_check'] ?? '',
      q4PushWithHandle: json['q4_push_with_handle'] == true ||
          json['q4_push_with_handle'] == 'true',
      q5EnsureLoadStable: json['q5_ensure_load_stable'] == true ||
          json['q5_ensure_load_stable'] == 'true',
      q6IfDifficultToMove: json['q6_if_difficult_to_move'] ?? '',
      isActive: json['is_active'] == true || json['is_active'] == 'true',
      createdOn: json['created_on'] ?? '',
      createdBy: json['created_by'] ?? 0,
    );
  }

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
    return 'EPJMPJAssessmentModel(acknowledgmentDate: $acknowledgmentDate, name: $name, signature: ${signature?.path}, createdBy: $createdBy)';
  }
}
